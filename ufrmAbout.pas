unit ufrmAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ShellAPI;

type
  TfrmAbout = class(TForm)
    cmdClose: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    lblIconAuthorURL: TLabel;
    lblAppTopicURL: TLabel;
    procedure cmdCloseClick(Sender: TObject);
    procedure lblIconAuthorURLClick(Sender: TObject);
    procedure lblAppTopicURLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.cmdCloseClick(Sender: TObject);
begin
  frmAbout.Close;
end;

procedure TfrmAbout.lblAppTopicURLClick(Sender: TObject);
begin
  ShellExecute(self.WindowHandle, 'open', 'http://4pda.ru/forum/index.php?showtopic=168136', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.lblIconAuthorURLClick(Sender: TObject);
begin
  ShellExecute(self.WindowHandle, 'open', 'http://benrulz.com/', nil, nil, SW_SHOWNORMAL);
end;

end.
