program DemoRTCompleto;

uses
  Vcl.Forms,
  uDemoRTCompleto in 'uDemoRTCompleto.pas' {frmDemoRTCompleto},
  Frm_Status in 'Frm_Status.pas' {frmStatus},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Carbon');
  Application.Title := 'Demo TNFSeTributacaoRT';
  Application.CreateForm(TfrmDemoRTCompleto, frmDemoRTCompleto);
  Application.CreateForm(TfrmStatus, frmStatus);
  Application.Run;
end.