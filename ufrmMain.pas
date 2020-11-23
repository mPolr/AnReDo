unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvSimpleXml, ComCtrls, StdCtrls, Buttons, JvComponentBase,
  JvAppStorage, JvAppIniStorage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdAntiFreezeBase, IdAntiFreeze, ImgList, Menus, JvMenus,
  ExtCtrls, ShellAPI, SQLite3, SQLiteTable3;

type
  TCustomSortStyle = (cssAlphaNum, cssNumeric, cssDateTime, cssText);
  TfrmMain = class(TForm)
    jvXML: TJvSimpleXML;
    cmdRepo: TBitBtn;
    cmdUpdate: TBitBtn;
    cmdSearch: TBitBtn;
    lstApps: TListView;
    jvINI: TJvAppIniFileStorage;
    IdHTTP: TIdHTTP;
    cmdDownloadSelected: TBitBtn;
    prbProgress: TProgressBar;
    lblStatus: TLabel;
    IdAntiFreeze: TIdAntiFreeze;
    cmdAbout: TBitBtn;
    dlgSave: TSaveDialog;
    lstImages: TImageList;
    mnuPopup: TJvPopupMenu;
    mnuSearchGoogle: TMenuItem;
    N1: TMenuItem;
    mnuSearchAndrolib: TMenuItem;
    mnuDownload: TMenuItem;
    txtSearch: TEdit;
    lblSearch: TLabel;
    procedure cmdRepoClick(Sender: TObject);
    procedure cmdUpdateClick(Sender: TObject);
    procedure cmdSearchClick(Sender: TObject);
    procedure DoCleanUp(Sender: TObject);
    procedure lstAppsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cmdDownloadSelectedClick(Sender: TObject);
    procedure cmdAboutClick(Sender: TObject);
    procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure txtSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtSearchChange(Sender: TObject);
    procedure mnuSearchAndrolibClick(Sender: TObject);
    procedure mnuSearchGoogleClick(Sender: TObject);
    procedure mnuDownloadClick(Sender: TObject);
    procedure lstAppsColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  IsDownloading: Boolean;
  { variable to hold the sort style }
  LvSortStyle: TCustomSortStyle;
  { array to hold the sort order }
  LvSortOrder: array[0..4] of Boolean; // High[LvSortOrder] = Number of Lv
  //Columns
  Apps : TSQLiteDatabase; //база данных SQLite

implementation

uses ufrmRepo, ufrmAbout;
{$R *.dfm}

function FindListViewItem(lv: TListView; const S: string; column: Integer): TListItem;
var
  i: Integer;
  found: Boolean;
begin
  Assert(Assigned(lv));
  Assert((lv.viewstyle = vsReport) or (column = 0));
  Assert(S <> '');
  for i := 0 to lv.Items.Count - 1 do
  begin
    Result := lv.Items[i];
    if column = 0 then
      found := AnsiCompareText(Result.Caption, S) = 0
    else if column > 0 then
      found := AnsiCompareText(Result.SubItems[column - 1], S) = 0
    else
      found := False;
    if found then
      Exit;
  end;
  // No hit if we get here
  Result := nil;
end;

function CustomSortProc(Item1, Item2: TListItem; SortColumn: Integer): Integer; stdcall;
 var
   s1, s2: string;
   i1, i2: Integer;
   r1, r2: Boolean;
   d1, d2: TDateTime;

   { Helper functions }

   function IsValidNumber(AString : string; var AInteger : Integer): Boolean;
   var
     Code: Integer;
   begin
     Val(AString, AInteger, Code);
     Result := (Code = 0);
   end;

   function IsValidDate(AString : string; var ADateTime : TDateTime): Boolean;
   begin
     Result := True;
     try
       ADateTime := StrToDateTime(AString);
     except
       ADateTime := 0;
       Result := False;
     end;
   end;

   function CompareDates(dt1, dt2: TDateTime): Integer;
   begin
     if (dt1 > dt2) then Result := 1
     else
       if (dt1 = dt2) then Result := 0
     else
       Result := -1;
   end;

   function CompareNumeric(AInt1, AInt2: Integer): Integer;
   begin
     if AInt1 > AInt2 then Result := 1
     else
       if AInt1 = AInt2 then Result := 0
     else
       Result := -1;
   end;

   function CompareText(AString1, AString2 : string): Integer;
   begin
     Result := -AnsiCompareText(AString1,AString2);
   end;

 begin
   Result := 0;

   if (Item1 = nil) or (Item2 = nil) then Exit;

   case SortColumn of
     -1 :
     { Compare Captions }
     begin
       s1 := Item1.Caption;
       s2 := Item2.Caption;
     end;
     else
     { Compare Subitems }
     begin
       s1 := '';
       s2 := '';
       { Check Range }
       if (SortColumn < Item1.SubItems.Count) then
         s1 := Item1.SubItems[SortColumn];
       if (SortColumn < Item2.SubItems.Count) then
         s2 := Item2.SubItems[SortColumn]
     end;
   end;

   { Sort styles }

   case LvSortStyle of
     cssAlphaNum : Result := lstrcmp(PChar(s1), PChar(s2));
     cssDateTime : begin
                     r1 := IsValidDate(s1, d1);
                     r2 := IsValidDate(s2, d2);
                     Result := ord(r1 or r2);
                     if Result <> 0 then
                       Result := CompareDates(d1, d2);
                   end;
     cssNumeric  : begin
                     r1 := IsValidNumber(s1, i1);
                     r2 := IsValidNumber(s2, i2);
                     Result := ord(r1 or r2);
                     if Result <> 0 then
                       Result := CompareNumeric(i2, i1);
                   end;
     cssText     : begin
                     Result := -CompareText(Item1.Caption,Item2.Caption);
                   end;
   end;

   { Sort direction }

   if LvSortOrder[SortColumn + 1] then
     Result := - Result;
 end;

procedure TfrmMain.DoCleanUp(Sender:TObject);
var i, j, k, ACount: Integer;
    AStrings: TStringList;
    AList: TListItems;
begin
  AList := lstApps.Items;
  {get a pointer to the <strong class="highlight">listview</strong> items. This is faster than attempting
   to dereference using lvOne.Items each time}
  ACount := AList.Count;//how many items in the list
  AStrings := TStringList.Create;//create a temporary stringlist
  with AStrings do
  try
    Sorted := True;
    Duplicates := dupIgnore;
    //make it a sorted stringlist and ignore duplicates
    for i := 0 to ACount - 1 do AddObject(AList[i].Caption,TObject(i));
    {Add every item in the <strong class="highlight">listview</strong> to the stringlist. dupIgnore +
     Sorted ensures that duplicate entries are ignored. We want to
     add entries back to the <strong class="highlight">listview</strong> in their original order which
     will not be preserved in the stringlist since it is sorted. So
     we store the original indices in the Objects array of the
     stringlist. Note the TObject(i) typecast.}

    AList.Clear;
    {We have a safe copy of all the <strong class="highlight">listview</strong> entries we want to retain so
     why keep the <strong class="highlight">listview</strong> entries? Just clear the <strong class="highlight">listview</strong>. This issues
     just one LVM_DELETEALLITEMS message as opposed to multiple
     LVM_DELETEITEM messages}
    j := 0;
    {To repopulate the <strong class="highlight">listview</strong> we want to start finding its original
     entries starting from the first one, at index 0}
    for i := 0 to ACount - 1 do
    begin
      {The stringlist contains fewer entries than in the original <strong class="highlight">listview</strong>
       but nevertheless we have to run this loop as many times as there
       were members in the <strong class="highlight">listview</strong> since we need to identify them by
       their original position with the help of the stringlist.Objects
       array}
      k := IndexOfObject(TObject(j));
      //where is the j'th entry in the <strong class="highlight">listview</strong>?
      inc(j);//know that now so next time we want the (j + 1)th entry
      if (k >= 0) then AList.Add.Caption := Strings[k];
      {The j'th entry could have been a duplicate & may no longer
      exist. Only if it does - add it back to the listview}
    end;
  finally Free end;//don't forget to destroy the stringlist!
  ShowMessage(IntToStr(AList.Count));
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
 query: string;
begin
  Apps := TSQLiteDatabase.Create('apps.sqlite'); //указываем файл БД
  try
  if not Apps.TableExists('apps') then //таблица в БД отсутствует - создаем
    begin
      query := 'CREATE TABLE apps (id INTEGER PRIMARY KEY AUTOINCREMENT, apkid TEXT, path TEXT, name TEXT, ver TEXT, vercode TEXT, url TEXT)';
      Apps.ExecSQL(query);
    end;
  except
    MessageBox(0,'Во время создания таблицы произошла ошибка','Ошибка',MB_OK+MB_ICONERROR);
    Application.Terminate;
  end;

end;

procedure TfrmMain.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
var
  received : extended;
begin
  if IsDownloading = False then exit;
  Application.ProcessMessages;
  prbProgress.Position := AWorkCount;
  Application.ProcessMessages;
  IdAntiFreeze.Process;
  received := AWorkCount / 1024;
  lblStatus.Caption := 'Downloading "' + lstApps.Items.Item[lstApps.Selected.Index].Caption + '"... (Received: ' + FloatToStrF(received, ffNumber, 22, 2) + ' Kb)';
  Application.ProcessMessages;
end;

procedure TfrmMain.IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  cmdUpdate.Enabled := False;
  if IsDownloading = False then exit;
  prbProgress.Max := AWorkCountMax;
end;

procedure TfrmMain.IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  cmdUpdate.Enabled := True;
  prbProgress.Position := 0;
end;

procedure TfrmMain.lstAppsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if (lstApps.Items.Count > 0) then
    cmdDownloadSelected.Enabled := true
  else
    cmdDownloadSelected.Enabled := false
end;

procedure TfrmMain.lstAppsColumnClick(Sender: TObject; Column: TListColumn);
begin
  { determine the sort style }
  if Column.Index = 0 then begin
    //LvSortStyle := cssAlphaNum;
    LvSortStyle := cssText;
  end
  else if Column.Index = 1 then begin
    LvSortStyle := cssAlphaNum;
  end
  else if Column.Index = 2 then begin
    LvSortStyle := cssAlphaNum;
  end
  else if Column.Index = 3 then begin
    LvSortStyle := cssAlphaNum;
  end
  else
    LvSortStyle := cssNumeric;

  { Call the CustomSort method }
  lstApps.CustomSort(@CustomSortProc, Column.Index -1);
  { Set the sort order for the column}
  LvSortOrder[Column.Index] := not LvSortOrder[Column.Index];
end;

procedure TfrmMain.mnuDownloadClick(Sender: TObject);
begin
  if (lstApps.Items.Count <> 0) then begin
    frmMain.cmdDownloadSelected.Click;
  end;
end;

procedure TfrmMain.mnuSearchAndrolibClick(Sender: TObject);
var appname: string;
begin
  if (lstApps.Items.Count <> 0) then begin
    appname := StringReplace(lstApps.Items.Item[lstApps.Selected.Index].Caption, ' ', '+', [rfReplaceAll, rfIgnoreCase]);
    ShellExecute(self.WindowHandle, 'open', pChar('http://www.androlib.com/r.aspx?r=' + appname), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TfrmMain.mnuSearchGoogleClick(Sender: TObject);
var appname: string;
begin
  if (lstApps.Items.Count <> 0) then begin
    appname := StringReplace(lstApps.Items.Item[lstApps.Selected.Index].Caption, ' ', '+', [rfReplaceAll, rfIgnoreCase]);
    ShellExecute(self.WindowHandle, 'open', pChar('http://www.google.com/search?q=' + appname), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TfrmMain.txtSearchChange(Sender: TObject);
begin
  // stub :)
end;

procedure TfrmMain.txtSearchKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  MyItem: TListItem;
begin
  if (txtSearch.Text = '') then begin
    txtSearch.Color := clBtnFace;
    exit;
  end;
  MyItem := lstApps.FindCaption(0,      // StartIndex: Integer;
                                  txtSearch.text,   // Search string: string;
                                  True,   // Partial,
                                  True,   // Inclusive
                                  False); // Wrap  : boolean;
  if MyItem <> nil then begin
    txtSearch.Color := clBtnFace;
    lstApps.Selected := MyItem;
    MyItem.MakeVisible(True);
    //lstApps.SetFocus;
    //txtSearch.Text := MyItem.Caption;
  end
  else begin
    txtSearch.Color := $CCCCFF;
  end;
end;

procedure TfrmMain.cmdAboutClick(Sender: TObject);
begin
  ufrmAbout.frmAbout.ShowModal;
end;

procedure TfrmMain.cmdDownloadSelectedClick(Sender: TObject);
var
  mem: TMemoryStream;
begin
  if (lstApps.Selected.Index <> -1) then
    IsDownloading := True;
    mem := TMemoryStream.create;
    IdHTTP.Get(trim(lstApps.Items.Item[lstApps.Selected.Index].SubItems.ValueFromIndex[2]), mem);
    frmMain.IdAntiFreeze.Process;
    Application.ProcessMessages;

    if (lstApps.Items.Item[lstApps.Selected.Index].SubItems.ValueFromIndex[0] = 'n/a') then begin
      dlgSave.FileName := lstApps.Items.Item[lstApps.Selected.Index].Caption;
    end
    else begin
      dlgSave.FileName := lstApps.Items.Item[lstApps.Selected.Index].Caption + ' ' + lstApps.Items.Item[lstApps.Selected.Index].SubItems.ValueFromIndex[0];
    end;

    If dlgSave.Execute(handle) Then begin
      mem.savetofile(dlgSave.FileName);
      Application.ProcessMessages;
      mem.Free;
      lblStatus.Caption := 'Saving done!';
      IsDownloading := False;
    end
    else begin
      lblStatus.Caption := 'Saving cancelled!';
      IsDownloading := False;
    end
end;

procedure TfrmMain.cmdRepoClick(Sender: TObject);
begin
  ufrmRepo.frmRepo.ShowModal;
end;

procedure TfrmMain.cmdSearchClick(Sender: TObject);
var appswithdups: integer;
begin
  appswithdups := lstApps.Items.Count;
  DoCleanUp(lstApps);
  lblStatus.Caption := 'Duplicates removing complete. With dups: ' + inttostr(appswithdups) + ', after removing: ' + inttostr(lstApps.Items.Count)
end;

procedure TfrmMain.cmdUpdateClick(Sender: TObject);
var
  Repos: TStrings;
  i, x: integer;
  str: string;
  tmpBuffer: string;
  name: string;
  apkid: string;
  prevname: string; // Тут храним название последнего добавленного в список приложения
  path: string;
  version: string;
  vercode: string;
  md5h: string;
  prevversion: string; // Тут храним версию последнего добавленного в список приложения
  searchitem1: TListItem;
  searchitem2: TListItem;
  icon_path: string;
  date: string;
  totalapps: integer;
  useproxy: Boolean;
  proxyhost: string;
  proxyport: Integer;
begin
  lstApps.Clear;
  lstApps.SortType := stNone;
  totalapps := 0;
  lblStatus.Caption := 'initializing...';
  prbProgress.Style := pbstMarquee;
  Repos := TStringList.Create;
  //frmMain.jvINI.GetStoredValues('Proxy', Proxy);
  try
    useproxy := StrToBool(frmMain.jvINI.ReadString('Proxy\Enabled'));
    proxyhost := frmMain.jvINI.ReadString('Proxy\Host');
    proxyport := strtoint(frmMain.jvINI.ReadString('Proxy\Port'));
    if useproxy = StrToBool('True') then begin
      IdHTTP.ProxyParams.ProxyServer := proxyhost;
      IdHTTP.ProxyParams.ProxyPort := proxyport;
    end;
  except
    // error read proxy settings
  end;
  frmMain.jvINI.GetStoredValues('Repos', Repos);
  if (Repos.Count <> 0) then begin
    try
      for i := 0 to Repos.Count - 1 do begin
        str := frmMain.jvINI.ReadString('Repos\Repo' + inttostr(i));
        Repos.Add(str);
        Application.ProcessMessages;
        IdHTTP.ReadTimeout := 360000;
        IdHTTP.ConnectTimeout := 60000;
        If IdHTTP.Connected then IdHTTP.Disconnect;
        lblStatus.Caption := 'connecting to repo ' + str + '...';
        Try
          Application.ProcessMessages;
          IdAntiFreeze.Process;
          tmpBuffer := IdHTTP.Get(str + '/info.xml');
        Except
          lblStatus.Caption := 'error connecting to repo ' + str + '!';
          prbProgress.Style := pbstNormal;
          MessageDlg('error connecting to repo ' + str + '!', mtInformation, [mbOK], 0);
          // Exit;
        End;

        if tmpBuffer = '' then begin
          lblStatus.Caption := 'no data from server ' + str + '!';
          // MessageDlg('no data from server ' + str + '!', mtError, [mbOK], 0);
          // Exit;
        end
        else
        begin
          jvXML.XMLData := tmpBuffer;
          prbProgress.Position := 0;
          prbProgress.Max := jvXML.Root.Items.Count - 1;
          prbProgress.Style := pbstNormal;
          totalapps := totalapps + jvXML.Root.Items.Count - 1;
          for x := 0 to jvXML.Root.Items.Count - 1 do begin
            prbProgress.Position := x;
            name := jvXML.Root.Items.Item[x].Items.ItemNamed['name'].Value;
            apkid := jvXML.Root.Items.Item[x].Items.ItemNamed['apkid'].Value;
            path := jvXML.Root.Items.Item[x].Items.ItemNamed['path'].Value;
            version := jvXML.Root.Items.Item[x].Items.ItemNamed['ver'].Value;
            vercode := jvXML.Root.Items.Item[x].Items.ItemNamed['vercode'].Value;
            //md5h := jvXML.Root.Items.Item[x].Items.ItemNamed['md5h'].Value;
            md5h := '';
            if (version = '') then version := 'n/a';
            try
              date := jvXML.Root.Items.Item[x].Items.ItemNamed['date'].Value;
            except
              date := 'n/a';
            end;
            icon_path := jvXML.Root.Items.Item[x].Items.ItemNamed['icon'].Value;
            if (name <> '') then begin
              if (prevname <> '') then begin
                if (prevversion <> '') then begin
                  searchitem1 := FindListViewItem(lstApps, prevname, 0);
                  searchitem2 := FindListViewItem(lstApps, prevversion, 1);
                  if (searchitem1 <> nil) and (searchitem2 <> nil) then begin
                    if searchitem1.Index = searchitem2.Index then frmMain.Caption := 'O_o';
                  end;
                end;
              end;

              if (AnsiPos('?', name) = 0) then begin
                Apps.ExecSQL('INSERT INTO apps (name, apkid, ver, path, vercode, url) VALUES ("'+ name + '", "' + apkid + '", "' + version + '", "' + path + '", "' + vercode + '", "' + str + '/' + path + '")');
                // DELETE FROM apps USING apps, apps as vtable WHERE (apps.vercode > vtable.vercode) AND (apps.apkid = vtable.apkid)
                lstApps.Items.Add.Caption := name;
                lstApps.Items.Item[lstApps.Items.Count-1].SubItems.Add(' ' + version);
                lstApps.Items.Item[lstApps.Items.Count-1].SubItems.Insert(1, date);
                lstApps.Items.Item[lstApps.Items.Count-1].SubItems.Insert(2, ' ' + str + '/' + path);
                prevname := name;
                prevversion := version;
              end;
            end;
            lblStatus.Caption := 'Loading ' + inttostr(x) + '/' + inttostr(jvXML.Root.Items.Count - 1);
            Application.ProcessMessages;
          end;
        end;

      end;
    except

    end;

    prbProgress.Position := 0;
    lblStatus.Caption := 'Done. ' + inttostr(lstApps.Items.Count) + ' app(s) loaded of ' + inttostr(totalapps);
    //lstApps.SortType := stText;
    lstApps.SortType := stBoth;
    txtSearch.Enabled := true;
  end
  else begin
    prbProgress.Style := pbstNormal;
    MessageDlg('No repos!', mtInformation, [mbOK], 0);
  end;
end;

end.
