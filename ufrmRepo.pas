unit ufrmRepo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmRepo = class(TForm)
    cmdAddURL: TBitBtn;
    cmdDelURL: TBitBtn;
    lstRepos: TListBox;
    txtAddURL: TEdit;
    cmdSave: TButton;
    GroupBox1: TGroupBox;
    chkProxy: TCheckBox;
    Label1: TLabel;
    txtProxyHost: TEdit;
    txtProxyPort: TEdit;
    Label2: TLabel;
    procedure cmdAddURLClick(Sender: TObject);
    procedure cmdDelURLClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRepo: TfrmRepo;

implementation

uses ufrmMain;
{$R *.dfm}

procedure TfrmRepo.cmdAddURLClick(Sender: TObject);
begin
  if txtAddURL.Text <> '' then begin
    lstRepos.Items.Add(' ' + txtAddURL.Text);
    txtAddURL.Text := '';
  end;
end;

procedure TfrmRepo.cmdDelURLClick(Sender: TObject);
begin
  if lstRepos.ItemIndex <> -1 then begin
    lstRepos.DeleteSelected;
  end;
end;

procedure TfrmRepo.cmdSaveClick(Sender: TObject);
var i: integer;
begin
  frmMain.jvINI.DefaultSection := 'Repos';
  if (lstRepos.Count <> -1) then begin
    for i := 0 to lstRepos.Count - 1 do begin
      frmMain.jvINI.WriteString('Repos\Repo' + inttostr(i), trim(lstRepos.Items.ValueFromIndex[i]));
    end;
  end;
  frmMain.jvINI.WriteString('Proxy\Enabled', BoolToStr(chkProxy.Checked));
  frmMain.jvINI.WriteString('Proxy\Host', txtProxyHost.Text);
  frmMain.jvINI.WriteString('Proxy\Port', txtProxyPort.Text);
  if chkProxy.Checked = True then begin
    frmMain.IdHTTP.ProxyParams.ProxyServer := txtProxyHost.Text;
    frmMain.IdHTTP.ProxyParams.ProxyPort := strtoint(txtProxyPort.Text);
  end;
  frmMain.jvINI.Flush;
  frmRepo.Close;
end;

procedure TfrmRepo.FormCreate(Sender: TObject);
var
  Repos: TStrings;
  i: integer;
  str: string;
begin
  Repos := TStringList.Create;
  try
    chkProxy.Checked := StrToBool(frmMain.jvINI.ReadString('Proxy\Enabled'));
    txtProxyHost.Text := frmMain.jvINI.ReadString('Proxy\Host');
    txtProxyPort.Text := frmMain.jvINI.ReadString('Proxy\Port');
  except
    // error read proxy settings
  end;
  frmMain.jvINI.GetStoredValues('Repos', Repos);
  if (Repos.Count <> -1) then begin
    for i := 0 to Repos.Count - 1 do begin
      str := frmMain.jvINI.ReadString('Repos\Repo' + inttostr(i));
      lstRepos.Items.Add(' ' + str);
    end;
  end;
end;

end.
