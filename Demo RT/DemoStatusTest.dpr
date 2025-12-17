program DemoStatusTest;

uses
  Vcl.Forms,
  uDemoRTCompleto in 'uDemoRTCompleto.pas' {frmDemoRTCompleto},
  Frm_Status in 'Frm_Status.pas' {frmStatus};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Demo RT Status Test';
  Application.CreateForm(TfrmDemoRTCompleto, frmDemoRTCompleto);
  Application.CreateForm(TfrmStatus, frmStatus);
  Application.Run;
end.