unit Frm_Status;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmStatus = class(TForm)
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure SetStatus(const Value: string);
  public
    { Public declarations }
    property StatusText: string write SetStatus;
  end;

var
  frmStatus: TfrmStatus;

implementation

{$R *.dfm}

procedure TfrmStatus.FormCreate(Sender: TObject);
begin
  // Definir tamanho do formulario para ocupar a tela inteira
  Width := Screen.Width;
  Height := Screen.Height;
  Left := 0;
  Top := 0;

  // Propriedades visuais
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  Color := $30000000; // Preto semi-transparente

  // Alpha blend para fundo escuro semi-transparente
  AlphaBlend := True;
  AlphaBlendValue := 200;

  // Configurar o label do status
  lblStatus.Align := alClient;
  lblStatus.Alignment := taCenter;
  lblStatus.Layout := tlCenter;
  lblStatus.Caption := 'Processando...';
  lblStatus.Font.Charset := DEFAULT_CHARSET;
  lblStatus.Font.Color := clWhite;
  lblStatus.Font.Height := -24;
  lblStatus.Font.Name := 'Segoe UI';
  lblStatus.Font.Style := [];
  lblStatus.WordWrap := True;
  lblStatus.Transparent := True;
end;

procedure TfrmStatus.SetStatus(const Value: string);
begin
  if Assigned(lblStatus) then
  begin
    lblStatus.Caption := Value;
    Application.ProcessMessages;
  end;
end;

end.