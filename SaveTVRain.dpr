program SaveTVRain;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  untfrmWebTab in 'untfrmWebTab.pas' {frmWebTab: TFrame},
  untIECompat in 'untIECompat.pas',
  untM3U in 'untM3U.pas',
  untRecode in 'untRecode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.