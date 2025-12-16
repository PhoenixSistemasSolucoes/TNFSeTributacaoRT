# NFSeTributacaoRT

Biblioteca para implementação da Reforma Tributária para NFS-e (Nota Fiscal de Serviço Eletrônica) com suporte ao sistema IBS/CBS.

## 🎯 Objetivo

Esta biblioteca oferece uma interface fluente e intuitiva para implementação da Reforma Tributária (IBC/CBS) em emissões de NFS-e utilizando o componente ACBrNFSeX.

## 📋 Funcionalidades

### ✨ Características Principais

- **Interface Fluente**: API encadeada para configuração simplificada
- **Suporte Completo**: Implementação integral dos requisitos da Reforma Tributária
- **Cálculos Automáticos**: Processamento automático de alíquotas, bases e valores
- **Validação**: Verificação automática de campos obrigatórios
- **Compatibilidade**: Totalmente integrado com ACBrNFSeX

### 📊 Campos Suportados

#### DPS (Declaração de Prestação de Serviços)
- Finalidade da NFS-e
- Indicador de operação
- Tipo de operação (opcional)
- Tipo de ente governamental (opcional)
- Indicador de destinatário
- Referências a outras NFS-e
- Destinatário completo
- Imóvel (opcional)
- Documentos de reembolso/repasse/ressarcimento
- Tributação completa com CST e informações adicionais

#### NFS-e (Valores Calculados)
- Localidade de incidência
- Alíquotas efetivas (UF, Município, CBS)
- Reduções e benefícios
- Créditos presumidos
- Totalizadores IBS/CBS
- Valores de diferimento

## 🚀 Como Usar

### Instalação

Adicione a unit `NFSeTributacaoRT.pas` ao seu projeto Delphi.

### Exemplo Básico

```delphi
uses
  NFSeTributacaoRT, ACBrNFSeX;

var
  RT: TNFSeTributacaoRT;
  Valores: TRTCValores;
begin
  // Cria instância
  RT := TNFSeTributacaoRT.New(ACBrNFSeX1);

  try
    // Configura informações obrigatórias
    RT.Finalidade(fnfsRegular)
      .IndFinal(False)  // Não é para consumo pessoal
      .CIndOp('12345');  // Código da operação

    // Configura valores para cálculo
    Valores.vServ := 1000;
    Valores.descIncond := 0;
    Valores.vISSQN := 50;

    RT.Valores(Valores)
      .Aliquotas(0.10, 0.05, 0.20)  // 10% UF, 5% Mun, 20% CBS
      .Reducoes(0, 0, 0, 0);        // Sem reduções

    // Calcula e aplica
    RT.CalcularEAplicar(2024);

    // Obtém resultado
    ShowMessageFmt('IBS Total: R$ %.2f', [RT.Resultado.vIBSTot]);

  finally
    RT.Free;
  end;
end;
```

### Exemplo Completo

```delphi
var
  RT: TNFSeTributacaoRT;
  Dest: TRTCDestinatario;
  Imov: TRTCImovel;
  Valores: TRTCValores;
begin
  RT := TNFSeTributacaoRT.New(ACBrNFSeX1);

  try
    // Configurações da operação
    RT.Finalidade(fnfsRegular)
      .IndFinal(False)
      .CIndOp('VENDA_SERV')
      .TpOper(togVenda)
      .TpEnteGov(tcgEstadual, 'Secretaria da Fazenda')
      .IndDest(idTomadorAdquirenteDestinatarioIguais);

    // Configura destinatário
    Dest.CNPJ := '12345678901234';
    Dest.xNome := 'Empresa Cliente Ltda';
    Dest.ender.cMun := 3550308;  // São Paulo
    Dest.ender.xLgr := 'Rua das Flores';
    Dest.ender.nro := '123';
    Dest.ender.xBairro := 'Centro';

    RT.Destinatario(Dest);

    // Configura valores
    Valores.vServ := 5000;
    Valores.descIncond := 100;
    Valores.vISSQN := 150;
    Valores.vPIS := 25;
    Valores.vCOFINS := 115;
    Valores.vLiq := 4900;

    RT.Valores(Valores)
      .Aliquotas(0.12, 0.08, 0.25)  // 12% UF, 8% Mun, 25% CBS
      .Reducoes(0.10, 0.05, 0.15, 0.20)  // Reduções específicas
      .CreditoPresumido(0.05, 0.10); // Créditos presumidos

    // Localidade de incidência
    RT.LocalidadeIncid(3550308, 'São Paulo - SP');

    // Calcula e aplica todos os dados
    RT.CalcularEAplicar(2024);

    // Exibe resultados
    with RT.Resultado do
    begin
      Memo.Lines.Add(Format('Base de Cálculo: R$ %.2f', [vBC]));
      Memo.Lines.Add(Format('IBS UF: R$ %.2f', [vIBSUF]));
      Memo.Lines.Add(Format('IBS Município: R$ %.2f', [vIBSMun]));
      Memo.Lines.Add(Format('CBS: R$ %.2f', [vCBS]));
      Memo.Lines.Add(Format('Total da Nota: R$ %.2f', [vTotNF]));
    end;

  finally
    RT.Free;
  end;
end;
```

## 📚 Referências

### Estrutura de Registros

#### TRTCValores
```delphi
vServ: Currency;        // Valor do serviço
descIncond: Currency;   // Desconto incondicional
vCalcReeRepRes: Currency; // Valor calculado de reembolso/repasse
vISSQN: Currency;       // Valor do ISSQN
vPIS: Currency;         // Valor do PIS
vCOFINS: Currency;      // Valor do COFINS
vLiq: Currency;         // Valor líquido
```

#### TRTCCalculado
```delphi
AnoReferencia: Word;    // Ano de referência para cálculo
vBC: Currency;          // Base de cálculo
pIBSUF: Double;         // Alíquota IBS UF
vIBSUF: Currency;       // Valor IBS UF
pIBSMun: Double;        // Alíquota IBS Município
vIBSMun: Currency;      // Valor IBS Município
pCBS: Double;           // Alíquota CBS
vCBS: Currency;         // Valor CBS
vTotNF: Currency;       // Total da nota
```

## 📝 Notas Importantes

### Regras de Cálculo

- **Até 2026**: A base de cálculo subtrai PIS e COFINS
- **Até 2032**: A base de cálculo não subtrai PIS e COFINS
- **Alíquotas Efetivas**: Calculadas aplicando reduções ao percentual original
- **Diferimento**: Percentual aplicado sobre o valor total do imposto

### Campos Obrigatórios

Para DPS/IBSCBS:
- `finNFSe`: Finalidade da NFS-e
- `indFinal`: Indicador de uso pessoal
- `cIndOp`: Código da operação

## 🤝 Contribuição

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adicionando nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🔗 Links Úteis

- [ACBr - Projeto ACBr](https://projetoacbr.com.br/)
- [Documentação ACBrNFSeX](https://acbr.sourceforge.io/ACBrMonitor/ACBrNFSe.html)
- [Reforma Tributária - Portal do Governo](https://www.gov.br/receitafederal/pt-br/assuntos/reforma-tributaria)

---

**Atenção**: Esta biblioteca está em desenvolvimento contínuo para acompanhar as atualizações da legislação da Reforma Tributária. Mantenha-se sempre atualizado com as últimas versões!