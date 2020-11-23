program AnReDo;

uses
  Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufrmRepo in 'ufrmRepo.pas' {frmRepo},
  ufrmAbout in 'ufrmAbout.pas' {frmAbout};

{$E exe}

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Android Repo Downloader';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmRepo, frmRepo);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
