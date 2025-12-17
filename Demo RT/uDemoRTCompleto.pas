unit uDemoRTCompleto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.OleCtrls, SHDocVw, Winapi.ShellAPI,
  Xml.XmlIntf, Xml.XmlDoc, System.Zip,
  ACBrDFeSSL,
  ACBrBase, ACBrUtil.Base, ACBrUtil.DateTime, ACBrUtil.FilesIO, ACBrDFe,
  ACBrDFeReport, ACBrMail, ACBrNFSeX, ACBrXmlBase, ACBrDFe.Conversao,
  ACBrNFSeXConversao, ACBrNFSeXWebservicesResponse,
  ACBrNFSeXDANFSeClass, ACBrNFSeXDANFSeRLClass, NFSeTributacaoRT,
  System.IniFiles, Frm_Status;

type
  // Classes para armazenar dados das NFSe
  TDadosPrestador = class
  private
    FCpfCnpj: string;
    FInscricaoMunicipal: string;
    FRazaoSocial: string;
    FNomeFantasia: string;
    FEndereco: string;
    FNumero: string;
    FBairro: string;
    FCEP: string;
    FCodigoMunicipio: string;
    FUF: string;
    FTelefone: string;
    FEmail: string;
  public
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property NomeFantasia: string read FNomeFantasia write FNomeFantasia;
    property Endereco: string read FEndereco write FEndereco;
    property Numero: string read FNumero write FNumero;
    property Bairro: string read FBairro write FBairro;
    property CEP: string read FCEP write FCEP;
    property CodigoMunicipio: string read FCodigoMunicipio write FCodigoMunicipio;
    property UF: string read FUF write FUF;
    property Telefone: string read FTelefone write FTelefone;
    property Email: string read FEmail write FEmail;
    constructor Create;
  end;

  TDadosTomador = class
  private
    FCpfCnpj: string;
    FRazaoSocial: string;
    FEndereco: string;
    FNumero: string;
    FBairro: string;
    FCEP: string;
    FCodigoMunicipio: string;
    FUF: string;
    FTelefone: string;
    FEmail: string;
  public
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property Endereco: string read FEndereco write FEndereco;
    property Numero: string read FNumero write FNumero;
    property Bairro: string read FBairro write FBairro;
    property CEP: string read FCEP write FCEP;
    property CodigoMunicipio: string read FCodigoMunicipio write FCodigoMunicipio;
    property UF: string read FUF write FUF;
    property Telefone: string read FTelefone write FTelefone;
    property Email: string read FEmail write FEmail;
    constructor Create;
  end;

  TDadosServico = class
  private
    FItemListaServico: string;
    FCodigoTributacaoMunicipio: string;
    FCodigoNBS: string;
    FCodigoMunicipio: string;
    FDiscriminacao: string;
    FValorServicos: Double;
    FAliquota: Double;
  public
    property ItemListaServico: string read FItemListaServico write FItemListaServico;
    property CodigoTributacaoMunicipio: string read FCodigoTributacaoMunicipio write FCodigoTributacaoMunicipio;
    property CodigoNBS: string read FCodigoNBS write FCodigoNBS;
    property CodigoMunicipio: string read FCodigoMunicipio write FCodigoMunicipio;
    property Discriminacao: string read FDiscriminacao write FDiscriminacao;
    property ValorServicos: Double read FValorServicos write FValorServicos;
    property Aliquota: Double read FAliquota write FAliquota;
    constructor Create;
  end;

  // Enum com os tipos de emissao do demo
  TNFSeTipoDemo = (
    tdPrestadorNormal,
    tdPrestadorISSRetido,
    tdPrestadorPF,
    tdTomadorEmite,
    tdServicoImune,
    tdExportacao
  );

  TfrmDemoRTCompleto = class(TForm)
    GroupBox1: TGroupBox;
    btnPrestadorNormal: TButton;
    btnPrestadorISSRetido: TButton;
    btnPrestadorPF: TButton;
    btnTomadorEmite: TButton;
    btnServicoImune: TButton;
    btnExportacao: TButton;
    chkAplicarRT: TCheckBox;
    lblDetalhes: TLabel;
    memoDetalhes: TMemo;
    memoLog: TMemo;
    OpenDialog1: TOpenDialog;
    NFSe: TACBrNFSeX;
    DANFE: TACBrNFSeXDANFSeRL;
    chkAplicarDiferimento: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnPrestadorNormalClick(Sender: TObject);
    procedure btnPrestadorISSRetidoClick(Sender: TObject);
    procedure btnPrestadorPFClick(Sender: TObject);
    procedure btnTomadorEmiteClick(Sender: TObject);
    procedure btnServicoImuneClick(Sender: TObject);
    procedure btnExportacaoClick(Sender: TObject);
  private
    { Private declarations }
    sArquivoINI: string;
    FRT: TNFSeTributacaoRT;
    FNumeroNota: Integer;
    FDadosPrestador: TDadosPrestador;
    FDadosTomador: TDadosTomador;
    FDadosServico: TDadosServico;
    procedure CarregarINI;
    procedure ConfigurarComponente;
    procedure GravarLog(const AMsg: string);
    procedure ConfigurarDadosComuns(Tipo: TNFSeTipoDemo);
    procedure AplicarReformaTributaria;
    procedure AtualizarDetalhes(Tipo: TNFSeTipoDemo);
    procedure CriarNFSe(Tipo: TNFSeTipoDemo; const Descricao: string);
    procedure MostrarStatus(const Mensagem: string);
    procedure OcultarStatus;
  public
    { Public declarations }
  end;

var
  frmDemoRTCompleto: TfrmDemoRTCompleto;
  frmStatus: TfrmStatus;

implementation

{$R *.dfm}

{ TDadosPrestador }

constructor TDadosPrestador.Create;
begin
  inherited Create;
  FCpfCnpj := '12345678901234';  // CNPJ Fictício para Testes
  FInscricaoMunicipal := 'IM001234';
  FRazaoSocial := 'EMPRESA DE SERVICOS DE TECNOLOGIA LTDA';
  FNomeFantasia := 'TECH SERVICOS';
  FEndereco := 'AVENIDA CENTRAL';
  FNumero := '1000';
  FBairro := 'CENTRO';
  FCEP := '30130000';
  FCodigoMunicipio := '3106200';
  FUF := 'MG';
  FTelefone := '3130000000';
  FEmail := 'empresa@teste.com.br';
end;

{ TDadosTomador }

constructor TDadosTomador.Create;
begin
  inherited Create;
  FCpfCnpj := '98765432109876';  // CNPJ Fictício para Testes
  FRazaoSocial := 'CLIENTE TESTE SERVICOS SA';
  FEndereco := 'RUA DAS FLORES';
  FNumero := '500';
  FBairro := 'VILA NOVA';
  FCEP := '01234567';
  FCodigoMunicipio := '3550308';
  FUF := 'SP';
  FTelefone := '1130000000';
  FEmail := 'cliente@teste.com.br';
end;

{ TDadosServico }

constructor TDadosServico.Create;
begin
  inherited Create;
  FItemListaServico := '080201';
  FCodigoTributacaoMunicipio := '001';
  FCodigoNBS := '122051900';
  FCodigoMunicipio := '3106200';
  FDiscriminacao := 'SERVIÇOS DE CONSULTORIA EM TI - DEMONSTRAÇÃO';
  FValorServicos := 1000.00;  // Valor mais baixo para testes
  FAliquota := 0;
end;

procedure TfrmDemoRTCompleto.FormCreate(Sender: TObject);
begin
  // Inicializar contador de notas começando com 3
  FNumeroNota := 3;

  // Criar objetos com dados padrão
  FDadosPrestador := TDadosPrestador.Create;
  FDadosTomador := TDadosTomador.Create;
  FDadosServico := TDadosServico.Create;

  // Carregar INI automaticamente
  sArquivoINI := 'C:\Program Files (x86)\Embarcadero\Componentes\TNFSeTributacaoRT\Demo\ACBrNFSeX_Exemplo.ini';
  //ExtractFilePath(ParamStr(0)) + 'DemoRTCompleto.ini';
  CarregarINI;
end;

procedure TfrmDemoRTCompleto.CarregarINI;
var
  INI: TIniFile;
  sPathSalvar: string;
begin
  if not System.SysUtils.FileExists(sArquivoINI) then
  begin
    GravarLog('ERRO: Arquivo INI não encontrado: ' + sArquivoINI);
    Exit;
  end;

  try
    INI := TIniFile.Create(sArquivoINI);
    try
      // Configurar SSL e Bibliotecas
      NFSe.Configuracoes.Geral.SSLLib := TSSLLib(INI.ReadInteger('Certificado', 'SSLLib', 4));
      NFSe.Configuracoes.Geral.SSLCryptLib := TSSLCryptLib(INI.ReadInteger('Certificado', 'CryptLib', 3));
      NFSe.Configuracoes.Geral.SSLHttpLib := TSSLHttpLib(INI.ReadInteger('Certificado', 'HttpLib', 2));
      NFSe.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(INI.ReadInteger('Certificado', 'XmlSignLib', 4));

      // Configurar Certificado
      NFSe.Configuracoes.Certificados.ArquivoPFX := String(INI.ReadString('Certificado', 'Caminho', ''));
      NFSe.Configuracoes.Certificados.Senha := String(INI.ReadString('Certificado', 'Senha', ''));
      NFSe.Configuracoes.Certificados.NumeroSerie := String(INI.ReadString('Certificado', 'NumSerie', ''));

      // Debug apenas - comentar depois
      GravarLog('Certificado: ' + NFSe.Configuracoes.Certificados.ArquivoPFX);
      if NFSe.Configuracoes.Certificados.Senha <> '' then
        GravarLog('Senha: ***CONFIGURADO***')
      else
        GravarLog('Senha: NÃO CONFIGURADO');

      // Configurações Gerais
      NFSe.Configuracoes.Geral.ExibirErroSchema := INI.ReadBool('Geral', 'ExibirErroSchema', True);
      NFSe.Configuracoes.Geral.Salvar := INI.ReadBool('Geral', 'Salvar', True);
      NFSe.Configuracoes.Arquivos.PathSalvar := INI.ReadString('Geral', 'PathSalvar', '');

      // Configurar WebService
//      NFSe.Configuracoes.WebServices.Ambiente := (TpcnTipoAmbiente(INI.ReadInteger('WebService', 'Ambiente', 1)));
      NFSe.Configuracoes.WebServices.Visualizar := INI.ReadBool('WebService', 'Visualizar', False);
      NFSe.Configuracoes.WebServices.Salvar := INI.ReadBool('WebService', 'SalvarSOAP', False);

        // Garantir que usa Padrao Nacional
      NFSe.Configuracoes.Geral.Provedor := proPadraoNacional;
      NFSe.Configuracoes.Geral.LayoutNFSe := lnfsPadraoNacionalv101;
      NFSe.Configuracoes.WebServices.Ambiente := taHomologacao;
      NFSe.Configuracoes.Geral.CodigoMunicipio :=StrToIntDef(Ini.ReadString('Emitente', 'CodCidade', ''),0);


      // Configurar Diretórios
      sPathSalvar := INI.ReadString('Arquivos', 'PathNFSe', '');
      if sPathSalvar <> '' then
        ForceDirectories(sPathSalvar);

      GravarLog('INI carregado com sucesso!');
      GravarLog('Configuracoes carregadas do arquivo: ' + sArquivoINI);

    finally
      INI.Free;
    end;
  except
    on E: Exception do
    begin
      GravarLog('ERRO ao carregar INI: ' + E.Message);
    end;
  end;
end;

procedure TfrmDemoRTCompleto.ConfigurarComponente;
begin
  try


    // Descarregar certificado anterior antes de configurar
    NFSe.SSL.DescarregarCertificado;
    GravarLog('Componente configurado com sucesso!');
    GravarLog('Provedor: Padrao Nacional configurado');
    GravarLog('Layout: Padrao Nacional v1.01 configurado');
  except
    on E: Exception do
    begin
      GravarLog('ERRO ao configurar componente: ' + E.Message);
    end;
  end;
end;

procedure TfrmDemoRTCompleto.GravarLog(const AMsg: string);
begin
  memoLog.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ' - ' + AMsg);
  memoLog.Lines.Add('');
  Application.ProcessMessages;
end;

procedure TfrmDemoRTCompleto.ConfigurarDadosComuns(Tipo: TNFSeTipoDemo);
var
  NumDFe, NumLote: String;
begin
  // Configuracoes comuns para todas as NFSe - Padrao Nacional
  // IDENTICO AO Alimentar_Componente_layout_PadraoNacional
  NumDFe := IntToStr(FNumeroNota);
  NumLote := '1';

  NFSe.NotasFiscais.Clear;
  NFSe.NotasFiscais.NumeroLote := NumLote;

  with NFSe.NotasFiscais.New.NFSe do
  begin
    // ======================
    // IDENTIFICAÇÃO DA DPS
    // ======================
    Numero := NumDFe;
    verAplic := 'ACBrNFSeX-1.00';

    IdentificacaoRps.Numero := FormatFloat('#########0', StrToInt(NumDFe));
    IdentificacaoRps.Serie  := '900';
    IdentificacaoRps.Tipo   := trRPS;

    // Garantir que a data de emissão não seja posterior à data de processamento
    // Usar Date() sem a hora para evitar problemas com fuso horário
    DataEmissao     := Date;
    DataEmissaoRPS  := Date;
    Competencia     := Date;

    tpEmit := tePrestador;
    // NÃO informar Razão Social quando emitente = prestador
    if (tpEmit <> tePrestador) then
    begin
      Prestador.RazaoSocial  := 'AGUILAR DISTRIBUIDORA DE PECAS DIESEL LTDA';
      Prestador.NomeFantasia := 'AGUILAR DISTRIBUIDORA DE PECAS DIESEL LTDA'
    end;


    // ======================
    // REGIME / SIMPLES
    // ======================
    OptanteSN := osnOptanteMEEPP;
    RegimeEspecialTributacao := retNenhum;

    // ======================
    // PRESTADOR (CNC)
    // ======================
    Prestador.IdentificacaoPrestador.CpfCnpj := FDadosPrestador.CpfCnpj;
    Prestador.IdentificacaoPrestador.InscricaoMunicipal := FDadosPrestador.InscricaoMunicipal;

    Prestador.cUF := UFparaCodigoUF(FDadosPrestador.UF);

    Prestador.Endereco.CodigoMunicipio := FDadosPrestador.CodigoMunicipio;
    Prestador.Endereco.Endereco := FDadosPrestador.Endereco;
    Prestador.Endereco.Numero   := FDadosPrestador.Numero;
    Prestador.Endereco.Bairro   := FDadosPrestador.Bairro;
    Prestador.Endereco.CEP      := FDadosPrestador.CEP;
    Prestador.Endereco.UF       := FDadosPrestador.UF;
    Prestador.Endereco.CodigoPais := 1058;
    Prestador.Endereco.xPais      := 'BRASIL';

    Prestador.Contato.Telefone := FDadosPrestador.Telefone;
    Prestador.Contato.Email    := FDadosPrestador.Email;

    // ======================
    // SERVIÇO (PONTO CRÍTICO)
    // ======================
    Servico.ItemListaServico := FDadosServico.ItemListaServico;              // ✔ cTribNac CORRETO
    Servico.CodigoTributacaoMunicipio := FDadosServico.CodigoTributacaoMunicipio;        // ✔ BH
    Servico.CodigoNBS  := FDadosServico.CodigoNBS;
    Servico.CodigoMunicipio := FDadosServico.CodigoMunicipio;
    Servico.CodigoPais := 1058;

    Servico.Discriminacao := FDadosServico.Discriminacao;

    // ======================
    // VALORES
    // ======================
    Servico.Valores.ValorServicos := FDadosServico.ValorServicos;
    Servico.Valores.ValorDeducoes := 0;
    Servico.Valores.DescontoIncondicionado := 0;
    Servico.Valores.DescontoCondicionado   := 0;

    Servico.Valores.BaseCalculo := Servico.Valores.ValorServicos;

    Servico.Valores.Aliquota := FDadosServico.Aliquota; // Simples Nacional
    Servico.Valores.tribMun.tribISSQN := tiOperacaoTributavel;
    Servico.Valores.tribMun.tpRetISSQN := trNaoRetido;
    Servico.Valores.tribMun.tpImunidade := timNenhum;

    Servico.Valores.ValorISS := 0;
    Servico.Valores.ValorLiquidoNfse := Servico.Valores.ValorServicos;

    Servico.Valores.totTrib.indTotTrib := indSim;
    Servico.Valores.totTrib.pTotTribSN := 14.01;

    // ======================
    // TOMADOR
    // ======================

    // Ajustar dados conforme o cenário
    case Tipo of
      tdPrestadorPF:
      begin
        Tomador.IdentificacaoTomador.CpfCnpj := '12345678901';
        Tomador.RazaoSocial := 'JOSE DA SILVA';
        Tomador.IdentificacaoTomador.Tipo := tpPF;
      end;
      else
      begin
        Tomador.IdentificacaoTomador.CpfCnpj := FDadosTomador.CpfCnpj;
        Tomador.RazaoSocial := FDadosTomador.RazaoSocial;
        Tomador.IdentificacaoTomador.Tipo := tpPF;
      end;
    end;

    Tomador.AtualizaTomador := snNao;
    Tomador.TomadorExterior := snNao;

    // Para o provedor IPM usar os valores:
    // tpPFNaoIdentificada ou tpPF para pessoa Fisica
    // tpPJdoMunicipio ou tpPJforaMunicipio ou tpPJforaPais para pessoa Juridica

    // Para o provedor SigISS usar os valores acima de forma adquada
    Tomador.IdentificacaoTomador.InscricaoMunicipal := '';
    Tomador.IdentificacaoTomador.InscricaoEstadual := '';
    Tomador.IdentificacaoTomador.Nif := '';
    // (tnnNaoInformado, tnnDispensado, tnnNaoExigencia);
    Tomador.IdentificacaoTomador.cNaoNIF := tnnDispensado;

    // O campo EnderecoInformado é utilizado pelo provedor IPM
    // Devemos informar: snoSim Sim ou snoNao = Não ou snoNenhum para não gerar a tag
    Tomador.Endereco.EnderecoInformado := snoSim;
    Tomador.Endereco.TipoLogradouro := 'RUA';
    Tomador.Endereco.Endereco := FDadosTomador.Endereco;
    Tomador.Endereco.Numero := FDadosTomador.Numero;
    Tomador.Endereco.Complemento := 'APTO 11';
    Tomador.Endereco.TipoBairro := 'BAIRRO';
    Tomador.Endereco.Bairro := FDadosTomador.Bairro;
    Tomador.Endereco.xMunicipio := 'Cidade do Tomador';
    Tomador.Endereco.UF := FDadosTomador.UF;
    Tomador.Endereco.CodigoPais := 1058; // Brasil
    Tomador.Endereco.CodigoMunicipio := FDadosTomador.CodigoMunicipio;
    Tomador.Endereco.CEP := FDadosTomador.CEP;
    Tomador.Endereco.xPais := 'BRASIL';

    Tomador.Contato.DDD := '16';

    case NFSE.Configuracoes.Geral.Provedor of
      proCTAConsult:
        Tomador.Contato.Telefone := '22223333';
    else
      Tomador.Contato.Telefone := FDadosTomador.Telefone;
    end;

    Tomador.Contato.Email := FDadosTomador.Email;

    // Incrementar contador da nota
    Inc(FNumeroNota);

    AplicarReformaTributaria;


    // ======================
    // REFORMA TRIBUTÁRIA
    // ======================

  end;
end;

procedure TfrmDemoRTCompleto.AplicarReformaTributaria;
var
  V: TRTCValores;
begin
  if not chkAplicarRT.Checked then
  begin
    GravarLog('Reforma Tributaria desativada');
    Exit;
  end;

  V.Clear;
  V.vServ := NFSe.NotasFiscais.Items[0].NFSe.Servico.Valores.ValorLiquidoNfse;
  V.vLiq := V.vServ;  // Valor liquido igual ao valor do servico

  // Usando a classe de integracao da Reforma Tributaria
  FRT := TNFSeTributacaoRT.New(NFSe);
  try
    if chkAplicarDiferimento.Checked then
    begin
      FRT.Finalidade(fnfsRegular)
        .IndFinal(True)
        .CIndOp('100301')
        .TpOper(TtpOperGovNFSe.togNenhum)
        .TpEnteGov(tcgNenhum)
        .IndDest(idTomadorAdquirenteDestinatarioIguais)
        .Tributacao(cst000, '000001', cpNenhum)  // Sem beneficio fiscal = tributacao integral
        .Diferimento(0.1, 0, 0.9)  // Aplicar diferimento IBS/CBS conforme marcado
        .Valores(V)
        .Aliquotas(0.20, 0.05, 0.10)  // Aliquotas de exemplo (20% UF, 5% Mun, 10% CBS)
        .Reducoes(0, 0, 0, 0)  // Sem reducoes
        .CalcularEAplicar(StrToIntDef(FormatDateTime('yyyy', Date), 2024));
      GravarLog('Reforma Tributaria aplicada COM diferimento IBS/CBS!');
    end
    else
    begin
      FRT.Finalidade(fnfsRegular)
        .IndFinal(True)
        .CIndOp('100301')
        .TpOper(TtpOperGovNFSe.togNenhum)
        .TpEnteGov(tcgNenhum)
        .IndDest(idTomadorAdquirenteDestinatarioIguais)
        .Tributacao(cst000, '000001', cpNenhum)  // Sem beneficio fiscal = tributacao integral
        .Valores(V)
        .Aliquotas(0.20, 0.05, 0.10)  // Aliquotas de exemplo (20% UF, 5% Mun, 10% CBS)
        .Reducoes(0, 0, 0, 0)  // Sem reducoes
        .CalcularEAplicar(StrToIntDef(FormatDateTime('yyyy', Date), 2024));
      GravarLog('Reforma Tributaria aplicada SEM diferimento IBS/CBS!');
    end;
  finally
    FRT.Free;
  end;
end;

procedure TfrmDemoRTCompleto.AtualizarDetalhes(Tipo: TNFSeTipoDemo);
begin
  memoDetalhes.Clear;

  // Mostrar configurações da Reforma Tributária
  memoDetalhes.Lines.Add('=== CONFIGURAÇÕES REFORMA TRIBUTÁRIA ===');
  if chkAplicarRT.Checked then
    memoDetalhes.Lines.Add('Reforma Tributária: ATIVADA')
  else
    memoDetalhes.Lines.Add('Reforma Tributária: DESATIVADA');

  if chkAplicarDiferimento.Checked then
    memoDetalhes.Lines.Add('Diferimento IBS/CBS: ATIVADO (0.1, 0, 0.9)')
  else
    memoDetalhes.Lines.Add('Diferimento IBS/CBS: DESATIVADO');

  memoDetalhes.Lines.Add('');
  memoDetalhes.Lines.Add('=== CENÁRIO SELECIONADO ===');

  case Tipo of
    tdPrestadorNormal:
    begin
      memoDetalhes.Lines.Add('tpEmit: tePrestador');
      memoDetalhes.Lines.Add('Regime: ME/EPP (Simples Nacional)');
      memoDetalhes.Lines.Add('ISS: Não Retido');
      memoDetalhes.Lines.Add('Tomador: Pessoa Jurídica');
      memoDetalhes.Lines.Add('cIndOp: 100301');
      memoDetalhes.Lines.Add('CST IBS: 000');
      memoDetalhes.Lines.Add('CST CBS: 000');
    end;
    tdPrestadorISSRetido:
    begin
      memoDetalhes.Lines.Add('tpEmit: tePrestador');
      memoDetalhes.Lines.Add('Regime: ME/EPP (Simples Nacional)');
      memoDetalhes.Lines.Add('ISS: Retido pelo Tomador');
      memoDetalhes.Lines.Add('Tomador: Pessoa Jurídica');
      memoDetalhes.Lines.Add('tpRetISSQN: trRetidoPeloTomador');
    end;
    tdPrestadorPF:
    begin
      memoDetalhes.Lines.Add('tpEmit: tePrestador');
      memoDetalhes.Lines.Add('Regime: ME/EPP (Simples Nacional)');
      memoDetalhes.Lines.Add('ISS: Não Retido');
      memoDetalhes.Lines.Add('Tomador: Pessoa Física');
      memoDetalhes.Lines.Add('CPF: 123.456.789-01');
    end;
    tdTomadorEmite:
    begin
      memoDetalhes.Lines.Add('tpEmit: teTomador');
      memoDetalhes.Lines.Add('Regime: ME/EPP (Simples Nacional)');
      memoDetalhes.Lines.Add('Emissor: Tomador do Serviço');
      memoDetalhes.Lines.Add('Prestador: Informado na NFSe');
      memoDetalhes.Lines.Add('Cenário: Substituição');
    end;
    tdServicoImune:
    begin
      memoDetalhes.Lines.Add('tpEmit: tePrestador');
      memoDetalhes.Lines.Add('Regime: ME/EPP (Simples Nacional)');
      memoDetalhes.Lines.Add('ISS: Imune/Isento');
      memoDetalhes.Lines.Add('tribISSQN: tiNaoIncidencia');
      memoDetalhes.Lines.Add('tpImunidade: timImunidade');
    end;
    tdExportacao:
    begin
      memoDetalhes.Lines.Add('tpEmit: tePrestador');
      memoDetalhes.Lines.Add('Regime: ME/EPP (Simples Nacional)');
      memoDetalhes.Lines.Add('ISS: Exportação (Não devido)');
      memoDetalhes.Lines.Add('Tomador: Exterior');
      memoDetalhes.Lines.Add('tribISSQN: tiExportacao');
      memoDetalhes.Lines.Add('País: USA');
    end;
  end;

  if chkAplicarRT.Checked then
  begin
    memoDetalhes.Lines.Add('');
    memoDetalhes.Lines.Add('Reforma Tributaria: ATIVADA');
  end;
end;

procedure TfrmDemoRTCompleto.CriarNFSe(Tipo: TNFSeTipoDemo; const Descricao: string);
var
  i: Integer;
begin
  MostrarStatus('Configurando componente...');
  ConfigurarComponente;

  MostrarStatus('Configurando dados da NFSe...');
  ConfigurarDadosComuns(Tipo);
  AtualizarDetalhes(Tipo);

  // ======================
  // REFORMA TRIBUTARIA - OPCIONAL
  // ======================
  if chkAplicarRT.Checked then
  begin
    MostrarStatus('Aplicando Reforma Tributaria...');
    try
      AplicarReformaTributaria;
    except
      on E: Exception do
      begin
        GravarLog('ERRO na Reforma Tributaria: ' + E.Message);
      end;
    end;
  end;

  try
    // Usar Emitir como no demo funcional
    MostrarStatus('Enviando NFSe para o webservice...');
    NFSe.Emitir(NFSe.NotasFiscais.NumeroLote, meUnitario);
    GravarLog(Descricao + ' - NFSe enviada com sucesso!');

    // Verificar status
    with NFSe.WebService.Emite do
    begin
      GravarLog('Protocolo: ' + Protocolo);
      GravarLog('Numero Nota: ' + NumeroNota);
      GravarLog('Link: ' + Link);
      GravarLog('Sucesso: ' + BoolToStr(Sucesso, True));

      // Verificar erros
      if NFSe.WebService.Emite.Erros.Count > 0 then
      begin
        GravarLog('ERRO(s) encontrados:');
        for i := 0 to NFSe.WebService.Emite.Erros.Count - 1 do
        begin
          GravarLog('Codigo  : ' + NFSe.WebService.Emite.Erros[i].Codigo);
          GravarLog('Mensagem: ' + NFSe.WebService.Emite.Erros[i].Descricao);
          GravarLog('Correcao: ' + NFSe.WebService.Emite.Erros[i].Correcao);
          GravarLog('---------');
        end;
      end;

      // Verificar alertas
      if NFSe.WebService.Emite.Alertas.Count > 0 then
      begin
        GravarLog('ALERTA(s):');
        for i := 0 to NFSe.WebService.Emite.Alertas.Count - 1 do
        begin
          GravarLog('Codigo  : ' + NFSe.WebService.Emite.Alertas[i].Codigo);
          GravarLog('Mensagem: ' + NFSe.WebService.Emite.Alertas[i].Descricao);
          GravarLog('---------');
        end;
      end;

      if Sucesso then
      begin
        // Salvar XML se configurado
        if NFSe.Configuracoes.Geral.Salvar then
        begin
          NFSe.NotasFiscais.Items[0].GravarXML;
          GravarLog('XML salvo em: ' + NFSe.NotasFiscais.Items[0].NomeArq);
        end;
      end;
    end;

    MostrarStatus('Processo concluido com sucesso!');
    Sleep(1000); // Pequena pausa para visualizacao

  except
    on E: Exception do
    begin
      GravarLog('ERRO ao enviar NFSe: ' + E.Message);

      // Verificar se o provedor esta configurado
      if NFSe.Configuracoes.Geral.Provedor = proNenhum then
        GravarLog('ERRO CRITICO: Nenhum provedor selecionado!');

      // Verificar se ha certificado configurado
      if (NFSe.Configuracoes.Certificados.ArquivoPFX = '') and
         (NFSe.Configuracoes.Certificados.NumeroSerie = '') then
        GravarLog('AVISO: Nenhum certificado digital configurado');

      MostrarStatus('ERRO: ' + E.Message);
      Sleep(3000);
    end;
  end;

  OcultarStatus;
end;

// ===== CENARIOS SIMPLIFICADOS =====

procedure TfrmDemoRTCompleto.btnPrestadorNormalClick(Sender: TObject);
begin
  GravarLog('========================================');
  GravarLog('CENARIO 1: Prestador -> Tomador (ME/EPP - ISS normal)');
  GravarLog('Caso mais comum de emissao');
  GravarLog('========================================');
  CriarNFSe(tdPrestadorNormal, 'Prestador Normal');
end;

procedure TfrmDemoRTCompleto.btnPrestadorISSRetidoClick(Sender: TObject);
begin
  GravarLog('========================================');
  GravarLog('CENARIO 2: Prestador -> Tomador (ISS Retido)');
  GravarLog('Construtoras, grandes empresas, orgaos publicos');
  GravarLog('========================================');
  CriarNFSe(tdPrestadorISSRetido, 'ISS Retido');
end;

procedure TfrmDemoRTCompleto.btnPrestadorPFClick(Sender: TObject);
begin
  GravarLog('========================================');
  GravarLog('CENARIO 3: Prestador -> Pessoa Fisica');
  GravarLog('Evita erros E0188, E0312');
  GravarLog('========================================');
  CriarNFSe(tdPrestadorPF, 'Tomador PF');
end;

procedure TfrmDemoRTCompleto.btnTomadorEmiteClick(Sender: TObject);
begin
  GravarLog('========================================');
  GravarLog('CENARIO 4: Tomador emite a DPS');
  GravarLog('Substituicao tributaria / Responsabilidade');
  GravarLog('Valida E0121, E0116, E0312');
  GravarLog('========================================');
  CriarNFSe(tdTomadorEmite, 'Tomador Emite');
end;

procedure TfrmDemoRTCompleto.btnServicoImuneClick(Sender: TObject);
begin
  GravarLog('========================================');
  GravarLog('CENARIO 5: Servico Imune / Isento');
  GravarLog('Educacao, entidades religiosas, associacoes');
  GravarLog('ISS = 0');
  GravarLog('========================================');
  CriarNFSe(tdServicoImune, 'Servico Imune');
end;

procedure TfrmDemoRTCompleto.btnExportacaoClick(Sender: TObject);
begin
  GravarLog('========================================');
  GravarLog('CENARIO 6: Exportacao de Servico (Exterior)');
  GravarLog('Compliance internacional');
  GravarLog('ISS nao devido');
  GravarLog('========================================');
  CriarNFSe(tdExportacao, 'Exportacao');
end;

procedure TfrmDemoRTCompleto.MostrarStatus(const Mensagem: string);
begin
  if not Assigned(frmStatus) then
    frmStatus := TfrmStatus.Create(nil);

  frmStatus.StatusText := Mensagem;
  frmStatus.Show;

  // Manter o status sempre no topo
  if Assigned(frmDemoRTCompleto) then
  begin
    frmStatus.Left := frmDemoRTCompleto.Left + (frmDemoRTCompleto.Width - frmStatus.Width) div 2;
    frmStatus.Top := frmDemoRTCompleto.Top + (frmDemoRTCompleto.Height - frmStatus.Height) div 2;
  end;

  Application.ProcessMessages;
end;

procedure TfrmDemoRTCompleto.OcultarStatus;
begin
  if Assigned(frmStatus) then
  begin
    frmStatus.Hide;
    FreeAndNil(frmStatus);
  end;
end;

end.