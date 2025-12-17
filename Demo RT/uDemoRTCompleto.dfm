object frmDemoRTCompleto: TfrmDemoRTCompleto
  Left = 0
  Top = 0
  Caption = 'Demo TNFSeTributacaoRT'
  ClientHeight = 600
  ClientWidth = 1200
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  StyleName = 'Carbon'
  OnCreate = FormCreate
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 1168
    Height = 177
    Caption = 
      'Cenarios de Emissao NFSe - Padrao Nacional com Reforma Tributari' +
      'a'
    TabOrder = 0
    StyleName = 'Carbon'
    object lblDetalhes: TLabel
      Left = 768
      Top = 47
      Width = 46
      Height = 13
      Caption = 'Detalhes:'
    end
    object btnPrestadorNormal: TButton
      Left = 16
      Top = 24
      Width = 370
      Height = 41
      Caption = '1. Prestador -> Tomador (ME/EPP - ISS normal)'
      TabOrder = 0
      StyleName = 'Carbon'
      OnClick = btnPrestadorNormalClick
    end
    object btnPrestadorISSRetido: TButton
      Left = 16
      Top = 71
      Width = 370
      Height = 41
      Caption = '2. Prestador -> Tomador (ISS Retido)'
      TabOrder = 1
      StyleName = 'Carbon'
      OnClick = btnPrestadorISSRetidoClick
    end
    object btnPrestadorPF: TButton
      Left = 16
      Top = 118
      Width = 370
      Height = 41
      Caption = '3. Prestador -> Pessoa Fisica'
      TabOrder = 2
      StyleName = 'Carbon'
      OnClick = btnPrestadorPFClick
    end
    object btnTomadorEmite: TButton
      Left = 392
      Top = 24
      Width = 370
      Height = 41
      Caption = '4. Tomador emite a DPS'
      TabOrder = 3
      StyleName = 'Carbon'
      OnClick = btnTomadorEmiteClick
    end
    object btnServicoImune: TButton
      Left = 392
      Top = 71
      Width = 370
      Height = 41
      Caption = '5. Servico Imune / Isento'
      TabOrder = 4
      StyleName = 'Carbon'
      OnClick = btnServicoImuneClick
    end
    object btnExportacao: TButton
      Left = 392
      Top = 118
      Width = 370
      Height = 41
      Caption = '6. Exportacao de Servico (Exterior)'
      TabOrder = 5
      StyleName = 'Carbon'
      OnClick = btnExportacaoClick
    end
    object chkAplicarRT: TCheckBox
      Left = 768
      Top = 24
      Width = 185
      Height = 17
      Caption = 'Aplicar Reforma Tributaria'
      Checked = True
      State = cbChecked
      TabOrder = 6
      StyleName = 'Carbon'
    end
    object chkAplicarDiferimento: TCheckBox
      Left = 944
      Top = 24
      Width = 200
      Height = 17
      Caption = 'Aplicar Diferimento IBS/CBS'
      TabOrder = 8
      StyleName = 'Carbon'
    end
    object memoDetalhes: TMemo
      Left = 768
      Top = 66
      Width = 392
      Height = 103
      TabStop = False
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        '')
      ReadOnly = True
      TabOrder = 7
      StyleName = 'Carbon'
    end
  end
  object memoLog: TMemo
    Left = 0
    Top = 191
    Width = 1184
    Height = 401
    Align = alCustom
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    StyleName = 'Carbon'
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.ini'
    Filter = 'Arquivos INI (*.ini)|*.ini|Todos os Arquivos (*.*)|*.*'
    Left = 752
    Top = 456
  end
  object NFSe: TACBrNFSeX
    Configuracoes.Geral.SSLLib = libNone
    Configuracoes.Geral.SSLCryptLib = cryNone
    Configuracoes.Geral.SSLHttpLib = httpNone
    Configuracoes.Geral.SSLXmlSignLib = xsNone
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Geral.CodigoMunicipio = 0
    Configuracoes.Geral.Provedor = proNenhum
    Configuracoes.Geral.Versao = ve100
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.WebServices.UF = 'SP'
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    DANFSE = DANFE
    Left = 744
    Top = 376
  end
  object DANFE: TACBrNFSeXDANFSeRL
    Sistema = 'Projeto ACBr - www.projetoacbr.com.br'
    MargemInferior = 8.000000000000000000
    MargemSuperior = 8.000000000000000000
    MargemEsquerda = 6.000000000000000000
    MargemDireita = 5.100000000000000000
    ExpandeLogoMarcaConfig.Altura = 0
    ExpandeLogoMarcaConfig.Esquerda = 0
    ExpandeLogoMarcaConfig.Topo = 0
    ExpandeLogoMarcaConfig.Largura = 0
    ExpandeLogoMarcaConfig.Dimensionar = False
    ExpandeLogoMarcaConfig.Esticar = True
    CasasDecimais.Formato = tdetInteger
    CasasDecimais.qCom = 2
    CasasDecimais.vUnCom = 2
    CasasDecimais.MaskqCom = ',0.00'
    CasasDecimais.MaskvUnCom = ',0.00'
    CasasDecimais.Aliquota = 2
    CasasDecimais.MaskAliquota = ',0.00'
    ACBrNFSe = NFSe
    Cancelada = False
    TamanhoFonte = 6
    FormatarNumeroDocumentoNFSe = True
    Provedor = proNenhum
    Producao = snSim
    Left = 792
    Top = 376
  end
end
