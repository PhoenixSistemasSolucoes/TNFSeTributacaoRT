# Demo TNFSeTributacaoRT com Reforma Tributária

Este demo demonstra a implementação completa da **TNFSeTributacaoRT**, classe desenvolvida para lidar com a nova Reforma Tributária brasileira no contexto de NFSe (Nota Fiscal de Serviço Eletrônica).

## Sobre a Classe TNFSeTributacaoRT

A `TNFSeTributacaoRT` é uma classe especializada que implementa as regras da **Reforma Tributária (Emenda Constitucional 132/2023)** para emissão de NFSe, incluindo:

- **IBS (Imposto sobre Bens e Serviços)**
- **CBS (Contribuição sobre Bens e Serviços)**
- **Sistema de Crédito Acumulado**
- **Diferimento e Partilhamento de Impostos**

### Principais Funcionalidades:

1. **Cálculo Automático**: Calcula automaticamente os valores de IBS e CBS conforme as regras da reforma
2. **Diferimento**: Suporte a diferimento de impostos com configurações flexíveis
3. **Créditos**: Gerenciamento de créditos acumulados
4. **Compatibilidade**: Integrada com o ACBr NFSeX

## Funcionalidades do Demo

### 1. Cenários de Emissão

O demo implementa **6 cenários principais** que cobrem as principais situações de emissão:

#### Cenários Disponíveis:

1. **Prestador → Tomador (ME/EPP - ISS normal)**
   - Emissão padrão com regime Simples Nacional
   - ISS não retido
   - Prestador ME/EPP

2. **Prestador → Tomador (ISS Retido)**
   - Retenção de ISS pelo tomador
   - Diferenças no cálculo dos impostos

3. **Prestador → Pessoa Física**
   - Tomador pessoa física
   - CPF: 123.456.789-01

4. **Tomador emite a DPS**
   - Inversão da responsabilidade de emissão
   - tpEmit: teTomador

5. **Serviço Imune/Isento**
   - Serviços com imunidade tributária
   - CST diferenciados

6. **Exportação de Serviço**
   - Serviços para o exterior
   - Tratamento especial

### 2. Controle da Reforma Tributária

#### Checkbox "Aplicar Reforma Tributária"
- **Ativado**: Aplica todos os cálculos da reforma tributária
- **Desativado**: Emite NFSe no modelo tradicional

#### Checkbox "Aplicar Diferimento IBS/CBS"
- **Ativado**: Aplica diferimento com parâmetros (0.1, 0, 0.9)
- **Desativado**: Não aplica diferimento (evita erro de validação)

### 3. Dados Instanciados

O demo utiliza uma arquitetura orientada a objetos com classes para armazenamento de dados:

#### TDadosPrestador
- CNPJ: 12345678901234 (fictício)
- Inscrição Municipal: IM001234
- Endereço completo em Belo Horizonte/MG

#### TDadosTomador
- CNPJ: 98765432109876 (fictício)
- Endereço em São Paulo/SP
- Suporte para PF e PJ

#### TDadosServico
- Item Lista Serviço: 080201
- Valor: R$ 1.000,00
- Discriminação: "SERVIÇOS DE CONSULTORIA EM TI"

### 4. Numeração Automática

- **Nota inicial**: 3
- **Incremento automático**: Cada nova NFSe incrementa o número
- **Controle global**: Mantém sequência durante toda a sessão

### 5. Status Modal (Frm_Status)

Formulário modal em tela cheia para feedback durante o processamento:
- Fundo semi-transparente (AlphaBlend: 200)
- Texto centralizado branco
- Design moderno e minimalista

## Como Compilar

### Pré-requisitos:
- Delphi 13 (Florence) ou superior
- ACBr Framework
- FortesReport (para DANFSe)
- Componente TNFSeTributacaoRT

### Via Script:
```batch
build_demo.bat
```

### Via Linha de Comando:
```bat
dcc32 -B -U"ACBr\Lib\Delphi\LibD37\Win32;Delphi\lib\win32\release;Fortesreport\Binary\LibD37;TNFSeTributacaoRT" DemoRTCompleto.dpr
```

## Arquivos do Projeto

- **DemoRTCompleto.dpr**: Projeto principal
- **uDemoRTCompleto.pas**: Unit principal com a lógica do demo
- **uDemoRTCompleto.dfm**: Formulário visual
- **Frm_Status.pas/.dfm**: Formulário de status modal
- **DemoRTCompleto.ini**: Configurações do sistema

## Configuração

O demo lê automaticamente as configurações do arquivo INI localizado em:
```
C:\Program Files (x86)\Embarcadero\Componentes\TNFSeTributacaoRT\Demo\ACBrNFSeX_Exemplo.ini
```

## Como Usar

1. **Execute o DemoRTCompleto.exe**
2. **Selecione um cenário** clicando no botão correspondente
3. **Configure as opções**:
   - Marque "Aplicar Reforma Tributária" para usar a nova classe
   - Marque "Aplicar Diferimento" apenas se necessário
4. **Acompanhe os detalhes** no painel à direita
5. **Visualize o log** de operações na área inferior

## Observações Importantes

- **Dados de Teste**: Todos os CNPJs e dados são fictícios para uso em ambiente de desenvolvimento
- **Ambiente**: Configurado inicialmente para Homologação
- **Provedor**: Utiliza Padrão Nacional (proPadraoNacional)
- **Compatibilidade**: Testado com Delphi 13

## Erros Conhecidos e Soluções

1. **"Grupo de diferimento não deve ser informado"**
   - Solução: Desmarcar "Aplicar Diferimento IBS/CBS"

2. **"CNPJ não possui estabelecimento no município"**
   - Solução: Usar CNPJs válidos/cadastrados no município

3. **"Prestador igual ao Tomador"**
   - Solução: Garantir CNPJs diferentes

## Contribuição

Este demo serve como referência para implementação da Reforma Tributária em sistemas de NFSe. Sinta-se à vontade para adaptar e estender conforme suas necessidades específicas.