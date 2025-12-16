unit NFSeTributacaoRT;

interface

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.Math,
  System.Generics.Collections,
  ACBrNFSeX,
  ACBrNFSeXConversao,
  ACBrNFSeXClass,
  ACBrDFe.Conversao;

type
  { ==============================
    Utilitários de tipos (documento)
    ============================== }
  TRTCDocTipo = (dtDFeNacional, dtDocFiscalOutro, dtDocOutro);

  TRTCFornecedor = record
    Has: Boolean;
    CNPJCPF: string;
    NIF: string;
    cNaoNIF: TNaoNIF;
    xNome: string;
    procedure Clear;
  end;

  TRTCDocReeRepRes = record
    Tipo: TRTCDocTipo;

    // dFeNacional
    tipoChaveDFe: TtipoChaveDFe;     // 1=NFS-e,2=NF-e,3=CT-e,9=Outro
    xTipoChaveDFe: string;       // se tcOutro
    ChaveDFe: string;

    // docFiscalOutro
    cMunDocFiscal: Integer;
    nDocFiscal: string;
    xDocFiscal: string;

    // docOutro
    nDoc: string;
    xDoc: string;

    // fornecedor (opcional)
    fornec: TRTCFornecedor;

    // comuns
    dtEmiDoc: TDate;
    dtCompDoc: TDate;
    tpReeRepRes: TtpReeRepRes;   // 01..04,99
    xTpReeRepRes: string;        // se 99
    vlrReeRepRes: Currency;

    procedure Clear;
  end;

  { ==============================
    Destinatário (DPS)
    ============================== }
  TRTCDestEnderecoNac = record
    cMun: Integer;
    CEP: string;
    procedure Clear;
  end;

  TRTCDestEnderecoExt = record
    cPais: string;
    cEndPost: string;
    xCidade: string;
    xEstProvReg: string;
    procedure Clear;
  end;

  TRTCDestEndereco = record
    IsExterior: Boolean;

    endNac: TRTCDestEnderecoNac;
    endExt: TRTCDestEnderecoExt;

    xLgr: string;
    nro: string;
    xCpl: string;
    xBairro: string;

    procedure Clear;
  end;

  TRTCDestinatario = record
    Has: Boolean;

    // choice: CNPJ/CPF/NIF/cNaoNIF
    CNPJ: string;
    CPF: string;
    NIF: string;
    cNaoNIF: TNaoNIF;

    xNome: string;
    ender: TRTCDestEndereco;
    fone: string;
    email: string;

    procedure Clear;
  end;

  { ==============================
    Imóvel (DPS) - exceto obras
    ============================== }
  TRTCImovelEnderecoExt = record
    cEndPost: string;
    xCidade: string;
    xEstProvReg: string;
    procedure Clear;
  end;

  TRTCImovel = record
    Has: Boolean;

    inscImobFisc: string;
    cCIB: string;

    CEP: string;
    endExt: TRTCImovelEnderecoExt;

    xLgr: string;
    nro: string;
    xCpl: string;
    xBairro: string;

    IsExterior: Boolean;

    procedure Clear;
  end;

  { ==============================
    Valores/Inputs para cálculo (NFS-e)
    Base vBC (NT004):
      vBC = vServ - descIncond - vCalcReeRepRes - vISSQN - vPIS - vCOFINS (até 2026)
      ou vBC = vServ - descIncond - vCalcReeRepRes - vISSQN (até 2032)
    ============================== }
  TRTCValores = record
    vServ: Currency;
    descIncond: Currency;
    vCalcReeRepRes: Currency;
    vISSQN: Currency;
    vPIS: Currency;
    vCOFINS: Currency;

    // para vTotNF
    vLiq: Currency;

    procedure Clear;
  end;

  { ==============================
    Resultado calculado (NFS-e)
    ============================== }
  TRTCCalculado = record
    AnoReferencia: Word;

    vBC: Currency;

    pIBSUF: Double;
    pRedAliqUF: Double;
    pAliqEfetUF: Double;
    vIBSUF: Currency;
    vDifUF: Currency;

    pIBSMun: Double;
    pRedAliqMun: Double;
    pAliqEfetMun: Double;
    vIBSMun: Currency;
    vDifMun: Currency;

    pCBS: Double;
    pRedAliqCBS: Double;
    pAliqEfetCBS: Double;
    vCBS: Currency;
    vDifCBS: Currency;

    pRedutor: Double; // redução compra gov (NFS-e IBSCBS comum)

    // crédito presumido
    pCredPresIBS: Double;
    vCredPresIBS: Currency;

    pCredPresCBS: Double;
    vCredPresCBS: Currency;

    vIBSTot: Currency;
    vTotNF: Currency;
  end;

  { ==============================
    Classe fluente NFSe (ACBrNFSeX)
    ============================== }
  TNFSeTributacaoRT = class
  private
    FACBr: TACBrNFSeX;

    // ===== DPS/IBSCBS (declarado) =====
    FFinNFSe: TfinNFSe;
    FIndFinal: TindFinal;
    FCIndOp: string;

    FTpOper: TtpOperGovNFSe;
    FHasTpOper: Boolean;

    FTpEnteGov: TtpEnteGov;
    FHasTpEnteGov: Boolean;
    FXTpEnteGov: string;

    FIndDest: TindDest;

    FRefsNFSe: TStringList;
    FDest: TRTCDestinatario;
    FImovel: TRTCImovel;

    FCST: TCSTIBSCBS;
    FCClassTrib: string;
    FCredPres: TcCredPres;

    FHasTribRegular: Boolean;
    FCSTReg: TCSTIBSCBS;
    FCClassTribReg: string;

    FHasDif: Boolean;
    FPDifUF: Double;
    FPDifMun: Double;
    FPDifCBS: Double;

    FDocs: TList<TRTCDocReeRepRes>;

    // ===== NFS-e/IBSCBS (calculado) =====
    FLocalidadeIncid: Integer;
    FXLocalidadeIncid: string;
    FXIndOp: string;
    FXCST: string;
    FXCClassTrib: string;

    FCalc: TRTCCalculado;
    FValores: TRTCValores;

    function NFSeIBSCBS_DPS: TIBSCBSDPS; // ACBr usa classes diferentes para DPS/NFS-e
    function NFSeIBSCBS_NFSe: TIBSCBSNfse;

    procedure EnsureNFSe;
    function PercentToFactor(const P: Double): Double; inline;

    function Calc_vBC(const Ano: Word; const V: TRTCValores): Currency;
    procedure Calc_All(const Ano: Word);

    procedure Apply_DPS_IBSCBS(var A: TIBSCBSDPS);
    procedure Apply_DPS_Dest(var A: TIBSCBSDPS);
    procedure Apply_DPS_Imovel(var A: TIBSCBSDPS);
    procedure Apply_DPS_Refs(var A: TIBSCBSDPS);
    procedure Apply_DPS_Docs(var A: TIBSCBSDPS);
    procedure Apply_DPS_Trib(var A: TIBSCBSDPS);

    procedure Apply_NFSE_IBSCBS(var A: TIBSCBSNfse);

  public
    constructor Create(AACBr: TACBrNFSeX);
    destructor Destroy; override;

    class function New(AACBr: TACBrNFSeX): TNFSeTributacaoRT; static;

    { ===== Fluent: DPS/IBSCBS ===== }
    function Finalidade(AFin: TfinNFSe): TNFSeTributacaoRT;
    function IndFinal(AUsoConsumoPessoal: Boolean): TNFSeTributacaoRT;
    function CIndOp(const ACodigo: string): TNFSeTributacaoRT;

    function TpOper(ATp: TtpOperGovNFSe): TNFSeTributacaoRT;     // opcional
    function ClearTpOper: TNFSeTributacaoRT;

    function TpEnteGov(ATp: TtpEnteGov; const AXTpEnteGov: string = ''): TNFSeTributacaoRT; // opcional + xTpEnteGov se "Outro"
    function ClearTpEnteGov: TNFSeTributacaoRT;

    function IndDest(AInd: TindDest): TNFSeTributacaoRT;

    function AddRefNFSe(const AChave: string): TNFSeTributacaoRT;

    function Destinatario(const ADest: TRTCDestinatario): TNFSeTributacaoRT;
    function ClearDestinatario: TNFSeTributacaoRT;

    function Imovel(const AImovel: TRTCImovel): TNFSeTributacaoRT;
    function ClearImovel: TNFSeTributacaoRT;

    function AddDocumentoReeRepRes(const ADoc: TRTCDocReeRepRes): TNFSeTributacaoRT;
    function ClearDocumentosReeRepRes: TNFSeTributacaoRT;

    function Tributacao(const ACST: TCSTIBSCBS; const ACClassTrib: string; const ACredPres: TcCredPres): TNFSeTributacaoRT;
    function TribRegular(const ACSTReg: TCSTIBSCBS; const ACClassTribReg: string): TNFSeTributacaoRT;
    function ClearTribRegular: TNFSeTributacaoRT;

    function Diferimento(const APDifUF, APDifMun, APDifCBS: Double): TNFSeTributacaoRT;
    function ClearDiferimento: TNFSeTributacaoRT;

    { ===== Fluent: NFS-e/IBSCBS (campos gerados/descrições) ===== }
    function LocalidadeIncid(ACodIBGE: Integer; const ANome: string): TNFSeTributacaoRT;
    function Descricoes(const AXIndOp, AXCST, AXCClassTrib: string): TNFSeTributacaoRT;

    { ===== Fluent: inputs cálculo ===== }
    function Valores(const AValores: TRTCValores): TNFSeTributacaoRT;

    function Aliquotas(const APIBSUF, APIBSMun, APCBS: Double): TNFSeTributacaoRT;
    function Reducoes(const APRedAliqUF, APRedAliqMun, APRedAliqCBS, APRedutor: Double): TNFSeTributacaoRT;
    function CreditoPresumido(const APIBS, APCBS: Double): TNFSeTributacaoRT;

    { ===== Executa cálculo + aplica tags ===== }
    function CalcularEAplicar(const AAnoReferencia: Word): TRTCCalculado;

    { ===== Aplica somente DPS ou tudo ===== }
    procedure AplicarSomenteDPS;
    procedure AplicarTudo;

    function Resultado: TRTCCalculado;
  end;

implementation

{ ===== record clears ===== }

procedure TRTCFornecedor.Clear;
begin
  Has := False;
  CNPJCPF := '';
  NIF := '';
  cNaoNIF := tnnNaoInformado;
  xNome := '';
end;

procedure TRTCDocReeRepRes.Clear;
begin
  Tipo := dtDFeNacional;

  tipoChaveDFe := tcOutro;
  xTipoChaveDFe := '';
  ChaveDFe := '';

  cMunDocFiscal := 0;
  nDocFiscal := '';
  xDocFiscal := '';

  nDoc := '';
  xDoc := '';

  fornec.Clear;

  dtEmiDoc := 0;
  dtCompDoc := 0;
  tpReeRepRes := trrr99;
  xTpReeRepRes := '';
  vlrReeRepRes := 0;
end;

procedure TRTCDestEnderecoNac.Clear;
begin
  cMun := 0;
  CEP := '';
end;

procedure TRTCDestEnderecoExt.Clear;
begin
  cPais := '';
  cEndPost := '';
  xCidade := '';
  xEstProvReg := '';
end;

procedure TRTCDestEndereco.Clear;
begin
  IsExterior := False;
  endNac.Clear;
  endExt.Clear;
  xLgr := '';
  nro := '';
  xCpl := '';
  xBairro := '';
end;

procedure TRTCDestinatario.Clear;
begin
  Has := False;
  CNPJ := '';
  CPF := '';
  NIF := '';
  cNaoNIF := tnnNaoInformado;
  xNome := '';
  ender.Clear;
  fone := '';
  email := '';
end;

procedure TRTCImovelEnderecoExt.Clear;
begin
  cEndPost := '';
  xCidade := '';
  xEstProvReg := '';
end;

procedure TRTCImovel.Clear;
begin
  Has := False;
  inscImobFisc := '';
  cCIB := '';
  CEP := '';
  endExt.Clear;
  xLgr := '';
  nro := '';
  xCpl := '';
  xBairro := '';
  IsExterior := False;
end;

procedure TRTCValores.Clear;
begin
  vServ := 0;
  descIncond := 0;
  vCalcReeRepRes := 0;
  vISSQN := 0;
  vPIS := 0;
  vCOFINS := 0;
  vLiq := 0;
end;

{ ===== TNFSeTributacaoRT ===== }

constructor TNFSeTributacaoRT.Create(AACBr: TACBrNFSeX);
begin
  inherited Create;

  FACBr := AACBr;

  FFinNFSe := fnfsRegular;
  FIndFinal := ifNao;
  FCIndOp := '';

  FTpOper := TtpOperGovNFSe.togNenhum;
  FHasTpOper := False;

  FTpEnteGov := tcgNenhum;
  FHasTpEnteGov := False;
  FXTpEnteGov := '';

  FIndDest := idTomadorAdquirenteDestinatarioIguais;

  FRefsNFSe := TStringList.Create;
  FRefsNFSe.Duplicates := dupIgnore;
  FRefsNFSe.Sorted := False;

  FDest.Clear;
  FImovel.Clear;

  FCST := cst000;
  FCClassTrib := '';
  FCredPres := cpNenhum;

  FHasTribRegular := False;
  FCSTReg := cstNenhum;
  FCClassTribReg := '';

  FHasDif := False;
  FPDifUF := 0;
  FPDifMun := 0;
  FPDifCBS := 0;

  FDocs := TList<TRTCDocReeRepRes>.Create;

  FLocalidadeIncid := 0;
  FXLocalidadeIncid := '';
  FXIndOp := '';
  FXCST := '';
  FXCClassTrib := '';

  FValores.Clear;
  FillChar(FCalc, SizeOf(FCalc), 0);
end;

destructor TNFSeTributacaoRT.Destroy;
begin
  FDocs.Free;
  FRefsNFSe.Free;
  inherited Destroy;
end;

class function TNFSeTributacaoRT.New(AACBr: TACBrNFSeX): TNFSeTributacaoRT;
begin
  Result := TNFSeTributacaoRT.Create(AACBr);
end;

procedure TNFSeTributacaoRT.EnsureNFSe;
begin
  if (FACBr = nil) then
    raise Exception.Create('ACBrNFSeX não informado.');

  if (FACBr.NotasFiscais.Count = 0) then
    raise Exception.Create('ACBrNFSeX sem NFSe em NotasFiscais.');

  if (FACBr.NotasFiscais.Items[0].NFSe = nil) then
    raise Exception.Create('NFSe não instanciada em NotasFiscais.Items[0].');
end;

function TNFSeTributacaoRT.NFSeIBSCBS_DPS: TIBSCBSDPS;
begin
  EnsureNFSe;
  Result := FACBr.NotasFiscais.Items[0].NFSe.IBSCBS; // no ACBr, o grupo fica aqui no objeto NFSe
end;

function TNFSeTributacaoRT.NFSeIBSCBS_NFSe: TIBSCBSNFSe;
begin
  EnsureNFSe;
  Result := FACBr.NotasFiscais.Items[0].NFSe.infNFSe.IBSCBS; // classe NFSe com valores calculados
end;

function TNFSeTributacaoRT.PercentToFactor(const P: Double): Double;
begin
  // P em fração (ex.: 0.10 = 10%). Mantém compatível com seu exemplo (0.1, 0.9 etc).
  Result := 1 - P;
end;

function TNFSeTributacaoRT.Calc_vBC(const Ano: Word; const V: TRTCValores): Currency;
begin
  // NT004 define duas janelas:
  // até 2026: subtrai PIS/COFINS
  // até 2032: sem PIS/COFINS
  // fonte: campo vBC no IBSCBS da NFS-e. :contentReference[oaicite:9]{index=9}

  if (Ano <= 2026) then
    Result := V.vServ - V.descIncond - V.vCalcReeRepRes - V.vISSQN - V.vPIS - V.vCOFINS
  else
    Result := V.vServ - V.descIncond - V.vCalcReeRepRes - V.vISSQN;

  if (Result < 0) then
    Result := 0;
end;

procedure TNFSeTributacaoRT.Calc_All(const Ano: Word);
var
  pEfUF, pEfMun, pEfCBS: Double;
begin
  FillChar(FCalc, SizeOf(FCalc), 0);
  FCalc.AnoReferencia := Ano;

  // Base
  FCalc.vBC := Calc_vBC(Ano, FValores);

  // Aliquotas efetivas:
  // pAliqEfet* = p* x (1 - pRedAliq*) x (1 - pRedutor) :contentReference[oaicite:10]{index=10}
  FCalc.pIBSUF := FCalc.pIBSUF; // j� setado por Aliquotas()
  FCalc.pIBSMun := FCalc.pIBSMun;
  FCalc.pCBS := FCalc.pCBS;

  FCalc.pRedAliqUF := FCalc.pRedAliqUF;
  FCalc.pRedAliqMun := FCalc.pRedAliqMun;
  FCalc.pRedAliqCBS := FCalc.pRedAliqCBS;

  pEfUF  := FCalc.pIBSUF  * PercentToFactor(FCalc.pRedAliqUF)  * PercentToFactor(FCalc.pRedutor);
  pEfMun := FCalc.pIBSMun * PercentToFactor(FCalc.pRedAliqMun) * PercentToFactor(FCalc.pRedutor);
  pEfCBS := FCalc.pCBS    * PercentToFactor(FCalc.pRedAliqCBS) * PercentToFactor(FCalc.pRedutor);

  FCalc.pAliqEfetUF  := pEfUF;
  FCalc.pAliqEfetMun := pEfMun;
  FCalc.pAliqEfetCBS := pEfCBS;

  // Valores brutos (IBS/CBS por fora)
  FCalc.vIBSUF  := FCalc.vBC * FCalc.pAliqEfetUF;
  FCalc.vIBSMun := FCalc.vBC * FCalc.pAliqEfetMun;
  FCalc.vIBSTot := FCalc.vIBSUF + FCalc.vIBSMun;

  FCalc.vCBS := FCalc.vBC * FCalc.pAliqEfetCBS;

  // Diferimentos (totCIBS/gIBS/gIBSUFTot/vDifUF etc) :contentReference[oaicite:11]{index=11}
  if FHasDif then
  begin
    FCalc.vDifUF  := FCalc.vIBSUF  * FPDifUF;
    FCalc.vDifMun := FCalc.vIBSMun * FPDifMun;
    FCalc.vDifCBS := FCalc.vCBS    * FPDifCBS;
  end;

  // Crédito Presumido (totCIBS/gIBS/gIBSCredPres e gCBS/gCBSCredPres) :contentReference[oaicite:12]{index=12}
  FCalc.vCredPresIBS := FCalc.vBC * FCalc.pCredPresIBS;
  FCalc.vCredPresCBS := FCalc.vBC * FCalc.pCredPresCBS;

  // vTotNF (2026 vs 2027+) :contentReference[oaicite:13]{index=13}
  if (Ano <= 2026) then
    FCalc.vTotNF := FValores.vLiq
  else
    FCalc.vTotNF := FValores.vLiq + FCalc.vCBS + FCalc.vIBSTot;
end;

{ ===== Fluent setters ===== }

function TNFSeTributacaoRT.Finalidade(AFin: TfinNFSe): TNFSeTributacaoRT;
begin
  FFinNFSe := AFin;
  Result := Self;
end;

function TNFSeTributacaoRT.IndFinal(AUsoConsumoPessoal: Boolean): TNFSeTributacaoRT;
begin
  if (AUsoConsumoPessoal) then
    FIndFinal := ifSim
  else
    FIndFinal := ifNao;
  Result := Self;
end;

function TNFSeTributacaoRT.CIndOp(const ACodigo: string): TNFSeTributacaoRT;
begin
  FCIndOp := Trim(ACodigo);
  Result := Self;
end;

function TNFSeTributacaoRT.TpOper(ATp: TtpOperGovNFSe): TNFSeTributacaoRT;
begin
  FTpOper := ATp;
  FHasTpOper := True;
  Result := Self;
end;

function TNFSeTributacaoRT.ClearTpOper: TNFSeTributacaoRT;
begin
  FTpOper := TtpOperGovNFSe.togNenhum;
  FHasTpOper := False;
  Result := Self;
end;

function TNFSeTributacaoRT.TpEnteGov(ATp: TtpEnteGov; const AXTpEnteGov: string): TNFSeTributacaoRT;
begin
  FTpEnteGov := ATp;
  FXTpEnteGov := Trim(AXTpEnteGov);
  FHasTpEnteGov := True;
  Result := Self;
end;

function TNFSeTributacaoRT.ClearTpEnteGov: TNFSeTributacaoRT;
begin
  FTpEnteGov := tcgNenhum;
  FXTpEnteGov := '';
  FHasTpEnteGov := False;
  Result := Self;
end;

function TNFSeTributacaoRT.IndDest(AInd: TindDest): TNFSeTributacaoRT;
begin
  FIndDest := AInd;
  Result := Self;
end;

function TNFSeTributacaoRT.AddRefNFSe(const AChave: string): TNFSeTributacaoRT;
var
  S: string;
begin
  S := Trim(AChave);
  if (S <> '') then
    FRefsNFSe.Add(S);
  Result := Self;
end;

function TNFSeTributacaoRT.Destinatario(const ADest: TRTCDestinatario): TNFSeTributacaoRT;
begin
  FDest := ADest;
  FDest.Has := True;
  Result := Self;
end;

function TNFSeTributacaoRT.ClearDestinatario: TNFSeTributacaoRT;
begin
  FDest.Clear;
  Result := Self;
end;

function TNFSeTributacaoRT.Imovel(const AImovel: TRTCImovel): TNFSeTributacaoRT;
begin
  FImovel := AImovel;
  FImovel.Has := True;
  Result := Self;
end;

function TNFSeTributacaoRT.ClearImovel: TNFSeTributacaoRT;
begin
  FImovel.Clear;
  Result := Self;
end;

function TNFSeTributacaoRT.AddDocumentoReeRepRes(const ADoc: TRTCDocReeRepRes): TNFSeTributacaoRT;
begin
  FDocs.Add(ADoc);
  Result := Self;
end;

function TNFSeTributacaoRT.ClearDocumentosReeRepRes: TNFSeTributacaoRT;
begin
  FDocs.Clear;
  Result := Self;
end;

function TNFSeTributacaoRT.Tributacao(const ACST: TCSTIBSCBS; const ACClassTrib: string; const ACredPres: TcCredPres): TNFSeTributacaoRT;
begin
  FCST := ACST;
  FCClassTrib := Trim(ACClassTrib);
  FCredPres := ACredPres;
  Result := Self;
end;

function TNFSeTributacaoRT.TribRegular(const ACSTReg: TCSTIBSCBS; const ACClassTribReg: string): TNFSeTributacaoRT;
begin
  FHasTribRegular := True;
  FCSTReg := ACSTReg;
  FCClassTribReg := Trim(ACClassTribReg);
  Result := Self;
end;

function TNFSeTributacaoRT.ClearTribRegular: TNFSeTributacaoRT;
begin
  FHasTribRegular := False;
  FCSTReg := cstNenhum;
  FCClassTribReg := '';
  Result := Self;
end;

function TNFSeTributacaoRT.Diferimento(const APDifUF, APDifMun, APDifCBS: Double): TNFSeTributacaoRT;
begin
  FHasDif := True;
  FPDifUF := APDifUF;
  FPDifMun := APDifMun;
  FPDifCBS := APDifCBS;
  Result := Self;
end;

function TNFSeTributacaoRT.ClearDiferimento: TNFSeTributacaoRT;
begin
  FHasDif := False;
  FPDifUF := 0;
  FPDifMun := 0;
  FPDifCBS := 0;
  Result := Self;
end;

function TNFSeTributacaoRT.LocalidadeIncid(ACodIBGE: Integer; const ANome: string): TNFSeTributacaoRT;
begin
  FLocalidadeIncid := ACodIBGE;
  FXLocalidadeIncid := Trim(ANome);
  Result := Self;
end;

function TNFSeTributacaoRT.Descricoes(const AXIndOp, AXCST, AXCClassTrib: string): TNFSeTributacaoRT;
begin
  FXIndOp := Trim(AXIndOp);
  FXCST := Trim(AXCST);
  FXCClassTrib := Trim(AXCClassTrib);
  Result := Self;
end;

function TNFSeTributacaoRT.Valores(const AValores: TRTCValores): TNFSeTributacaoRT;
begin
  FValores := AValores;
  Result := Self;
end;

function TNFSeTributacaoRT.Aliquotas(const APIBSUF, APIBSMun, APCBS: Double): TNFSeTributacaoRT;
begin
  FCalc.pIBSUF := APIBSUF;
  FCalc.pIBSMun := APIBSMun;
  FCalc.pCBS := APCBS;
  Result := Self;
end;

function TNFSeTributacaoRT.Reducoes(const APRedAliqUF, APRedAliqMun, APRedAliqCBS, APRedutor: Double): TNFSeTributacaoRT;
begin
  FCalc.pRedAliqUF := APRedAliqUF;
  FCalc.pRedAliqMun := APRedAliqMun;
  FCalc.pRedAliqCBS := APRedAliqCBS;
  FCalc.pRedutor := APRedutor;
  Result := Self;
end;

function TNFSeTributacaoRT.CreditoPresumido(const APIBS, APCBS: Double): TNFSeTributacaoRT;
begin
  FCalc.pCredPresIBS := APIBS;
  FCalc.pCredPresCBS := APCBS;
  Result := Self;
end;

function TNFSeTributacaoRT.Resultado: TRTCCalculado;
begin
  Result := FCalc;
end;

{ ===== Apply DPS ===== }

procedure TNFSeTributacaoRT.Apply_DPS_Refs(var A: TIBSCBSDPS);
var
  I: Integer;
begin
  if (FRefsNFSe.Count = 0) then Exit;

  for I := 0 to FRefsNFSe.Count - 1 do
  begin
    with A.gRefNFSe.New do
    begin
      refNFSe := FRefsNFSe[I];
    end;
  end;
end;

procedure TNFSeTributacaoRT.Apply_DPS_Dest(var A: TIBSCBSDPS);
begin
  if not FDest.Has then Exit;

  // Choice CNPJ/CPF/NIF/cNaoNIF (NT004)
  if (FDest.CNPJ <> '') then
    A.dest.CNPJCPF := FDest.CNPJ
  else if (FDest.CPF <> '') then
    A.dest.CNPJCPF := FDest.CPF
  else if (FDest.NIF <> '') then
    A.dest.NIF := FDest.NIF
  else
    A.dest.cNaoNIF := FDest.cNaoNIF;

  A.dest.xNome := FDest.xNome;
  A.dest.fone := FDest.fone;
  A.dest.email := FDest.email;
end;

procedure TNFSeTributacaoRT.Apply_DPS_Imovel(var A: TIBSCBSDPS);
begin
  if not FImovel.Has then Exit;

  // imovel (NT004)
  A.imovel.inscImobFisc := FImovel.inscImobFisc;
  A.imovel.cCIB := FImovel.cCIB;

  if FImovel.IsExterior then
  begin
    A.imovel.ender.endExt.cEndPost := FImovel.endExt.cEndPost;
    A.imovel.ender.endExt.xCidade := FImovel.endExt.xCidade;
    A.imovel.ender.endExt.xEstProvReg := FImovel.endExt.xEstProvReg;
  end
  else
  begin
    A.imovel.ender.CEP := FImovel.CEP;
  end;

  A.imovel.ender.xLgr := FImovel.xLgr;
  A.imovel.ender.nro := FImovel.nro;
  A.imovel.ender.xCpl := FImovel.xCpl;
  A.imovel.ender.xBairro := FImovel.xBairro;
end;

procedure TNFSeTributacaoRT.Apply_DPS_Docs(var A: TIBSCBSDPS);
var
  D: TRTCDocReeRepRes;
begin
  if (FDocs.Count = 0) then Exit;

  for D in FDocs do
  begin
    with A.valores.gReeRepRes.documentos.New do
    begin
      case D.Tipo of
        dtDFeNacional:
          begin
            dFeNacional.tipoChaveDFe := D.tipoChaveDFe;
            dFeNacional.xtipoChaveDFe := D.xTipoChaveDFe;
            dFeNacional.ChaveDFe := D.ChaveDFe;
          end;

        dtDocFiscalOutro:
          begin
            docFiscalOutro.cMunDocFiscal := D.cMunDocFiscal;
            docFiscalOutro.nDocFiscal := D.nDocFiscal;
            docFiscalOutro.xDocFiscal := D.xDocFiscal;
          end;

        dtDocOutro:
          begin
            docOutro.nDoc := D.nDoc;
            docOutro.xDoc := D.xDoc;
          end;
      end;

      if D.fornec.Has then
      begin
        // Verifica se é CNPJ ou CPF baseado no tamanho
        if Length(D.fornec.CNPJCPF) = 14 then
          fornec.CNPJCPF := D.fornec.CNPJCPF
        else if Length(D.fornec.CNPJCPF) = 11 then
          fornec.CNPJCPF := D.fornec.CNPJCPF;
        fornec.NIF := D.fornec.NIF;
        fornec.cNaoNIF := D.fornec.cNaoNIF;
        fornec.xNome := D.fornec.xNome;
      end;

      dtEmiDoc := D.dtEmiDoc;
      dtCompDoc := D.dtCompDoc;
      tpReeRepRes := D.tpReeRepRes;
      xTpReeRepRes := D.xTpReeRepRes;
      vlrReeRepRes := D.vlrReeRepRes;
    end;
  end;
end;

procedure TNFSeTributacaoRT.Apply_DPS_Trib(var A: TIBSCBSDPS);
begin
  // gIBSCBS (DPS)
  A.valores.trib.gIBSCBS.CST := FCST;
  A.valores.trib.gIBSCBS.cClassTrib := FCClassTrib;
  A.valores.trib.gIBSCBS.cCredPres := FCredPres;

  if FHasTribRegular then
  begin
    A.valores.trib.gIBSCBS.gTribRegular.CSTReg := FCSTReg;
    A.valores.trib.gIBSCBS.gTribRegular.cClassTribReg := FCClassTribReg;
  end;

  if FHasDif then
  begin
    A.valores.trib.gIBSCBS.gDif.pDifUF := FPDifUF;
    A.valores.trib.gIBSCBS.gDif.pDifMun := FPDifMun;
    A.valores.trib.gIBSCBS.gDif.pDifCBS := FPDifCBS;
  end;
end;

procedure TNFSeTributacaoRT.Apply_DPS_IBSCBS(var A: TIBSCBSDPS);
begin
  // Campos principais DPS/IBSCBS :contentReference[oaicite:18]{index=18}
  A.finNFSe := FFinNFSe;
  A.indFinal := FIndFinal;
  A.cIndOp := FCIndOp;

  if FHasTpOper then
    A.tpOper := FTpOper;

  if FHasTpEnteGov then
  begin
    A.tpEnteGov := FTpEnteGov;
    // A.xTpEnteGov := FXTpEnteGov; // campo não existe em TIBSCBSDPS
  end;

  A.indDest := FIndDest;

  Apply_DPS_Refs(A);
  Apply_DPS_Dest(A);
  Apply_DPS_Imovel(A);
  Apply_DPS_Docs(A);
  Apply_DPS_Trib(A);
end;

{ ===== Apply NFS-e (calculado) ===== }

procedure TNFSeTributacaoRT.Apply_NFSE_IBSCBS(var A: TIBSCBSNfse);
begin
  // Campos comuns da NFS-e (gerados) :contentReference[oaicite:20]{index=20}
  if (FLocalidadeIncid > 0) then
    A.cLocalidadeIncid := FLocalidadeIncid;

  if (FXLocalidadeIncid <> '') then
    A.xLocalidadeIncid := FXLocalidadeIncid;

  // Campos não existentes em TIBSCBSNfse - removidos
  // if (FXIndOp <> '') then
  //   A.xIndOp := FXIndOp;

  // if (FXCST <> '') then
  //   A.xCST := FXCST;

  // if (FXCClassTrib <> '') then
  //   A.xCClassTrib := FXCClassTrib;

  A.pRedutor := FCalc.pRedutor;

  // Valores brutos (NFS-e) :contentReference[oaicite:21]{index=21}
  A.valores.vBC := FCalc.vBC;
  A.valores.vCalcReeRepRes := FValores.vCalcReeRepRes;

  // UF
  A.valores.uf.pIBSUF := FCalc.pIBSUF;
  A.valores.uf.pRedAliqUF := FCalc.pRedAliqUF;
  A.valores.uf.pAliqEfetUF := FCalc.pAliqEfetUF;

  // Município
  A.valores.mun.pIBSMun := FCalc.pIBSMun;
  A.valores.mun.pRedAliqMun := FCalc.pRedAliqMun;
  A.valores.mun.pAliqEfetMun := FCalc.pAliqEfetMun;

  // Federal (CBS)
  A.valores.fed.pCBS := FCalc.pCBS;
  A.valores.fed.pRedAliqCBS := FCalc.pRedAliqCBS;
  A.valores.fed.pAliqEfetCBS := FCalc.pAliqEfetCBS;

  // Totalizadores (NFS-e) :contentReference[oaicite:22]{index=22}
  A.totCIBS.vTotNF := FCalc.vTotNF;

  // gTribRegular (valores efetivos regulares) é aqui usamos as efetivas calculadas
  with A.totCIBS.gTribRegular do
  begin
    pAliqEfeRegIBSUF := FCalc.pAliqEfetUF;
    vTribRegIBSUF := FCalc.vBC * pAliqEfeRegIBSUF;

    pAliqEfeRegIBSMun := FCalc.pAliqEfetMun;
    vTribRegIBSMun := FCalc.vBC * pAliqEfeRegIBSMun;

    pAliqEfeRegCBS := FCalc.pAliqEfetCBS;
    vTribRegCBS := FCalc.vBC * pAliqEfeRegCBS;
  end;

  // gIBS
  A.totCIBS.gIBS.vIBSTot := FCalc.vIBSTot;

  // crédito presumido IBS
  if (FCalc.pCredPresIBS > 0) then
  begin
    A.totCIBS.gIBS.gIBSCredPres.pCredPresIBS := FCalc.pCredPresIBS;
    A.totCIBS.gIBS.gIBSCredPres.vCredPresIBS := FCalc.vCredPresIBS;
  end;

  // IBS UF Tot
  A.totCIBS.gIBS.gIBSUFTot.vDifUF := FCalc.vDifUF;
  A.totCIBS.gIBS.gIBSUFTot.vIBSUF := FCalc.vIBSUF;

  // IBS Mun Tot
  A.totCIBS.gIBS.gIBSMunTot.vDifMun := FCalc.vDifMun;
  A.totCIBS.gIBS.gIBSMunTot.vIBSMun := FCalc.vIBSMun;

  // gCBS
  A.totCIBS.gCBS.vDifCBS := FCalc.vDifCBS;
  A.totCIBS.gCBS.vCBS := FCalc.vCBS;

  // crédito presumido CBS
  if (FCalc.pCredPresCBS > 0) then
  begin
    A.totCIBS.gCBS.gCBSCredPres.pCredPresCBS := FCalc.pCredPresCBS;
    A.totCIBS.gCBS.gCBSCredPres.vCredPresCBS := FCalc.vCredPresCBS;
  end;

  // gTribCompraGov (se você quiser popular, pode derivar das mesmas alíquotas/valores)
  // Mantido para você optar quando/como aplicar (depende do cenário de compra gov).
end;

{ ===== Públicos ===== }

procedure TNFSeTributacaoRT.AplicarSomenteDPS;
var
  A: TIBSCBSDPS;
begin
  A := NFSeIBSCBS_DPS;
  Apply_DPS_IBSCBS(A);
  FACBr.NotasFiscais.Items[0].NFSe.IBSCBS := A;
end;

procedure TNFSeTributacaoRT.AplicarTudo;
var
  A: TIBSCBSNfse;
begin
  // Primeiro aplica os dados do DPS
  AplicarSomenteDPS;

  // Depois aplica os dados calculados na NFS-e
  A := NFSeIBSCBS_NFSe;
  Apply_NFSE_IBSCBS(A);
  FACBr.NotasFiscais.Items[0].NFSe.infNFSe.IBSCBS := A;
end;

function TNFSeTributacaoRT.CalcularEAplicar(const AAnoReferencia: Word): TRTCCalculado;
begin
  // Valida mínimo DPS obrigatório (finNFSe, indFinal, cIndOp são 1-1 na NT004)
  if (Trim(FCIndOp) = '') then
    raise Exception.Create('cIndOp é obrigatório (DPS/IBSCBS).');

  // calcula
  Calc_All(AAnoReferencia);

  // aplica
  AplicarTudo;

  Result := FCalc;
end;

end.

