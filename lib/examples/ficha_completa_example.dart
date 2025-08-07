import 'package:quality_fruit_app/domain/entities/ficha.dart';
import 'package:quality_fruit_app/domain/entities/amostra_detalhada.dart';

/// Exemplo completo de uma Ficha com todos os novos campos da especificação
/// SEÇÃO 1: INFORMAÇÕES GERAIS, SEÇÃO 2: TABELA DE AMOSTRAS E DEFEITOS, SEÇÃO 3: OBSERVAÇÕES FINAIS
class FichaCompletaExample {
  /// Exemplo de Ficha com todos os campos da SEÇÃO 1 preenchidos
  static Ficha criarFichaExemplo() {
    final agora = DateTime.now();

    return Ficha(
      id: 'ficha_exemplo_completa',
      numeroFicha: 'QF-2024-001',
      dataAvaliacao: agora,
      cliente: 'Pura Fruta Exportação',
      // SEÇÃO 1: INFORMAÇÕES GERAIS - Novos campos obrigatórios
      ano: agora.year,
      fazenda: 'Fazenda São Miguel',
      semanaAno: _obterSemanaDoAno(agora), // Calculado automaticamente
      inspetor: 'João Silva Santos', // Responsável pela inspeção
      tipoAmostragem: TiposAmostragem
          .cumbuca500g, // Tipo de amostragem conforme especificação
      pesoBrutoKg: 25.750, // Peso bruto total em quilogramas
      // Campos originais
      produto: 'Uvas',
      variedade: 'Thompson Seedless',
      origem: 'Vale do São Francisco - BA',
      lote: 'VSF-2024-012',
      pesoTotal: 24.500, // Peso líquido após descontar embalagens
      quantidadeAmostras: 10, // 10 amostras para cumbuca 500g
      responsavelAvaliacao: 'Maria Fernanda Costa', // Analista da qualidade
      produtorResponsavel: 'Antônio João Ferreira',
      observacoes:
          'Lote especial para exportação. Frutos com excelente aparência e coloração uniforme.',
      // SEÇÃO 3: OBSERVAÇÕES FINAIS - Observações específicas por amostra
      observacaoA: 'Cachos bem formados, bagas de tamanho uniforme',
      observacaoB: 'Boa aderência das bagas, sem sinais de desgrane',
      observacaoC: 'Coloração adequada, brix dentro do padrão esperado',
      observacaoD: 'Sem defeitos visuais significativos',
      observacaoF: 'Embalagem adequada, peso conforme especificação',
      observacaoG: 'Qualidade geral excelente para exportação',
      criadoEm: agora,
    );
  }

  /// Exemplo de AmostraDetalhada com todos os novos campos da SEÇÃO 2
  static AmostraDetalhada criarAmostraExemplo() {
    final agora = DateTime.now();

    return AmostraDetalhada(
      id: 'amostra_exemplo_a',
      fichaId: 'ficha_exemplo_completa',
      letraAmostra: 'A',
      data: agora,
      caixaMarca: 'PREMIUM EXPORT',
      classe: 'Classe I',
      area: 'Setor Norte - Quadra 15',
      variedade: 'Thompson Seedless', // Usando string em vez da constante
      pesoBrutoKg: 2.575, // Peso bruto da amostra individual
      sacolaCumbuca: 'C', // C=certa, E=errada
      caixaCumbucaAlta: 'S', // S=sim, N=não
      aparenciaCalibro0a7: '6', // Escala 0-7, sendo 7 o melhor
      corUMD: 'U', // U=uniforme, M=média, D=desuniforme
      pesoEmbalagem: 0.075, // Peso da embalagem em kg
      pesoLiquidoKg: 2.500, // Peso líquido da amostra
      bagaMm: 18.5, // Calibre médio das bagas em mm
      // SEÇÃO 2: BRIX - Nova estrutura conforme especificação
      brixLeituras: [
        // 10 leituras manuais de Brix para cálculo da média
        21.2, 21.5, 21.1, 21.3, 21.4,
        21.0, 21.6, 21.2, 21.3, 21.1,
      ],
      // brixMedia será calculado automaticamente pela entidade (21.27)

      // Cor da Baga (%) - múltiplos de 5%
      corBagaPercentual: 85.0, // 85% das bagas com coloração adequada
      // DEFEITOS E PROBLEMAS (percentuais ou contagens)
      teiaAranha: 0.0, // Sem presença de teia de aranha
      aranha: 0.0, // Sem presença de aranhas
      amassada: 2.5, // 2.5% de bagas amassadas
      cachoDuro: 0.0, // Sem cachos duros
      cachoRaloBanguelo: 1.0, // 1% de cachos ralos/banguelos
      cicatriz: 0.5, // 0.5% com cicatrizes
      corpoEstranho: 0.0, // Sem corpos estranhos
      desgranePercentual: 3.0, // 3% de desgrane natural
      moscaFruta: 0.0, // Sem moscas da fruta
      murcha: 0.0, // Sem bagas murchas
      oidio: 0.0, // Sem oídio
      podre: 0.0, // Sem podridão
      queimadoSol: 1.0, // 1% com queimadura solar leve
      rachada: 0.5, // 0.5% de bagas rachadas
      sacarose: 19.8, // Nível de sacarose
      translucido: 0.0, // Sem bagas translúcidas
      glomerella: 0.0, // Sem glomerella
      traca: 0.0, // Sem traça

      observacoes:
          'Amostra A - Excelente qualidade geral. Brix adequado para exportação. Defeitos mínimos dentro dos padrões aceitáveis.',
      criadoEm: agora,
    );
  }

  /// Calcula a semana do ano para uma data específica
  static int _obterSemanaDoAno(DateTime data) {
    final inicioAno = DateTime(data.year, 1, 1);
    final diferencaDias = data.difference(inicioAno).inDays;
    return ((diferencaDias + inicioAno.weekday) / 7).ceil();
  }

  /// Exemplo de uso completo
  static void exemploUsoCompleto() {
    // Criar ficha de exemplo
    final ficha = criarFichaExemplo();
    print('=== FICHA DE QUALIDADE - EXEMPLO COMPLETO ===');
    print('Número: ${ficha.numeroFicha}');
    print('Cliente: ${ficha.cliente}');
    print('Fazenda: ${ficha.fazenda}');
    print('Semana/Ano: ${ficha.semanaAno}');
    print('Inspetor: ${ficha.inspetor}');
    print('Tipo de Amostragem: ${ficha.tipoAmostragem}');
    print('Peso Bruto: ${ficha.pesoBrutoKg} kg');
    print('Quantidade de Amostras: ${ficha.quantidadeAmostras}');

    // Criar amostra de exemplo
    final amostra = criarAmostraExemplo();
    print('\n=== AMOSTRA DETALHADA - EXEMPLO ===');
    print('Letra: ${amostra.letraAmostra}');
    print('Variedade: ${amostra.variedade}');
    print('Peso Líquido: ${amostra.pesoLiquidoKg} kg');
    print('Calibre: ${amostra.bagaMm} mm');
    print('Leituras Brix: ${amostra.brixLeituras}');
    print(
      'Brix Média: ${amostra.brixMedia?.toStringAsFixed(2) ?? "N/A"} °Brix',
    );
    print('Cor da Baga: ${amostra.corBagaPercentual}%');
    print('Desgrane: ${amostra.desgranePercentual}%');
    print('Observações: ${amostra.observacoes}');
  }
}
