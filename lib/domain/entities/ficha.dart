/// Entidade principal que representa uma Ficha de Avaliação de Qualidade
/// Corresponde ao cabeçalho da planilha de controle física
class Ficha {
  final String id;
  final String numeroFicha;
  final DateTime dataAvaliacao;
  final String cliente;
  // SEÇÃO 1: INFORMAÇÕES GERAIS
  final int ano; // Ano da análise (ex: 2025)
  final String fazenda; // Fazenda (sigla) - ex: "PV", "JP"
  final int semanaAno; // Semana do ano (calculado automaticamente)
  final String inspetor; // Nome do inspetor
  final String tipoAmostragem; // Cumbuca 500g, Cumbuca 250g, Sacola (Caixa)
  final double pesoBrutoKg; // Peso bruto com embalagem em kg

  // Campos antigos mantidos para compatibilidade
  final String produto; // Tipo de fruta
  final String variedade;
  final String origem;
  final String lote;
  final double pesoTotal; // Em kg (será pesoBrutoKg futuramente)
  final int quantidadeAmostras;
  final String responsavelAvaliacao; // Inspetor (será deprecated)
  final String? produtorResponsavel; // Produtor/Responsável da planilha
  final String observacoes;

  // Observações específicas por letra (A, B, C, D, F, G da planilha)
  final String? observacaoA;
  final String? observacaoB;
  final String? observacaoC;
  final String? observacaoD;
  final String? observacaoF;
  final String? observacaoG;

  final DateTime criadoEm;
  final DateTime? atualizadoEm;

  const Ficha({
    required this.id,
    required this.numeroFicha,
    required this.dataAvaliacao,
    required this.cliente,
    // SEÇÃO 1: Campos obrigatórios
    required this.ano,
    required this.fazenda,
    required this.semanaAno,
    required this.inspetor,
    required this.tipoAmostragem,
    required this.pesoBrutoKg,
    // Campos antigos (mantidos para compatibilidade)
    required this.produto,
    required this.variedade,
    required this.origem,
    required this.lote,
    required this.pesoTotal,
    required this.quantidadeAmostras,
    required this.responsavelAvaliacao,
    required this.observacoes,
    required this.criadoEm,
    this.produtorResponsavel,
    this.observacaoA,
    this.observacaoB,
    this.observacaoC,
    this.observacaoD,
    this.observacaoF,
    this.observacaoG,
    this.atualizadoEm,
  });

  /// Cria uma cópia com algumas propriedades alteradas
  Ficha copyWith({
    String? id,
    String? numeroFicha,
    DateTime? dataAvaliacao,
    String? cliente,
    // SEÇÃO 1: Novos campos
    int? ano,
    String? fazenda,
    int? semanaAno,
    String? inspetor,
    String? tipoAmostragem,
    double? pesoBrutoKg,
    // Campos antigos
    String? produto,
    String? variedade,
    String? origem,
    String? lote,
    double? pesoTotal,
    int? quantidadeAmostras,
    String? responsavelAvaliacao,
    String? produtorResponsavel,
    String? observacoes,
    String? observacaoA,
    String? observacaoB,
    String? observacaoC,
    String? observacaoD,
    String? observacaoF,
    String? observacaoG,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Ficha(
      id: id ?? this.id,
      numeroFicha: numeroFicha ?? this.numeroFicha,
      dataAvaliacao: dataAvaliacao ?? this.dataAvaliacao,
      cliente: cliente ?? this.cliente,
      // SEÇÃO 1: Novos campos
      ano: ano ?? this.ano,
      fazenda: fazenda ?? this.fazenda,
      semanaAno: semanaAno ?? this.semanaAno,
      inspetor: inspetor ?? this.inspetor,
      tipoAmostragem: tipoAmostragem ?? this.tipoAmostragem,
      pesoBrutoKg: pesoBrutoKg ?? this.pesoBrutoKg,
      // Campos antigos
      produto: produto ?? this.produto,
      variedade: variedade ?? this.variedade,
      origem: origem ?? this.origem,
      lote: lote ?? this.lote,
      pesoTotal: pesoTotal ?? this.pesoTotal,
      quantidadeAmostras: quantidadeAmostras ?? this.quantidadeAmostras,
      responsavelAvaliacao: responsavelAvaliacao ?? this.responsavelAvaliacao,
      produtorResponsavel: produtorResponsavel ?? this.produtorResponsavel,
      observacoes: observacoes ?? this.observacoes,
      observacaoA: observacaoA ?? this.observacaoA,
      observacaoB: observacaoB ?? this.observacaoB,
      observacaoC: observacaoC ?? this.observacaoC,
      observacaoD: observacaoD ?? this.observacaoD,
      observacaoF: observacaoF ?? this.observacaoF,
      observacaoG: observacaoG ?? this.observacaoG,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? DateTime.now(),
    );
  }

  /// Verifica se a ficha tem dados mínimos para salvamento
  /// Seguindo a regra: permite salvar mesmo com dados incompletos
  bool get temDadosMinimos {
    // Apenas campos absolutamente essenciais
    return numeroFicha.isNotEmpty && fazenda.isNotEmpty;
  }

  /// Calcula percentual de preenchimento da ficha
  double get percentualPreenchimento {
    final totalCampos = 19; // Total de campos importantes
    var preenchidos = 0;

    if (numeroFicha.isNotEmpty) preenchidos++;
    if (cliente.isNotEmpty) preenchidos++;
    if (fazenda.isNotEmpty) preenchidos++;
    if (produto.isNotEmpty) preenchidos++;
    if (variedade.isNotEmpty) preenchidos++;
    if (origem.isNotEmpty) preenchidos++;
    if (lote.isNotEmpty) preenchidos++;
    if (pesoTotal > 0) preenchidos++;
    if (quantidadeAmostras > 0) preenchidos++;
    if (responsavelAvaliacao.isNotEmpty) preenchidos++;
    if (produtorResponsavel?.isNotEmpty == true) preenchidos++;
    if (observacoes.isNotEmpty) preenchidos++;
    if (observacaoA?.isNotEmpty == true) preenchidos++;
    if (observacaoB?.isNotEmpty == true) preenchidos++;
    if (observacaoC?.isNotEmpty == true) preenchidos++;
    if (observacaoD?.isNotEmpty == true) preenchidos++;
    if (observacaoF?.isNotEmpty == true) preenchidos++;
    if (observacaoG?.isNotEmpty == true) preenchidos++;
    if (ano > 0) preenchidos++;

    return (preenchidos / totalCampos) * 100;
  }

  /// Lista de observações não vazias
  Map<String, String> get observacoesPreenchidas {
    final obs = <String, String>{};

    if (observacaoA?.isNotEmpty == true) obs['A'] = observacaoA!;
    if (observacaoB?.isNotEmpty == true) obs['B'] = observacaoB!;
    if (observacaoC?.isNotEmpty == true) obs['C'] = observacaoC!;
    if (observacaoD?.isNotEmpty == true) obs['D'] = observacaoD!;
    if (observacaoF?.isNotEmpty == true) obs['F'] = observacaoF!;
    if (observacaoG?.isNotEmpty == true) obs['G'] = observacaoG!;

    return obs;
  }

  /// Lista de campos vazios importantes (para avisos)
  List<String> get camposVaziosImportantes {
    final campos = <String>[];

    if (cliente.isEmpty) campos.add('Cliente');
    if (produto.isEmpty) campos.add('Produto');
    if (responsavelAvaliacao.isEmpty) campos.add('Responsável pela Avaliação');
    if (variedade.isEmpty) campos.add('Variedade');
    if (origem.isEmpty) campos.add('Origem');
    if (ano <= 0) campos.add('Ano');

    return campos;
  }

  /// Gera avisos de campos importantes não preenchidos
  List<String> get avisosCamposFaltantes {
    final avisos = <String>[];
    final camposVazios = camposVaziosImportantes;

    if (camposVazios.isNotEmpty) {
      avisos.add(
        'Campos importantes não preenchidos: ${camposVazios.join(', ')}',
      );
    }

    if (quantidadeAmostras == 0) {
      avisos.add('Quantidade de amostras não foi definida');
    }

    if (pesoTotal <= 0) {
      avisos.add('Peso total não foi informado');
    }

    return avisos;
  }

  @override
  String toString() {
    return 'Ficha(id: $id, numeroFicha: $numeroFicha, produto: $produto, cliente: $cliente, fazenda: $fazenda, ano: $ano)';
  }

  /// Calcula a semana do ano com base na data de avaliação
  static int calcularSemanaAno(DateTime data) {
    final primeiroJaneiro = DateTime(data.year, 1, 1);
    final diferencaDias = data.difference(primeiroJaneiro).inDays;
    return (diferencaDias / 7).ceil();
  }
}

/// Constantes para os tipos de amostragem da Ficha de Qualidade
class TiposAmostragem {
  static const String cumbuca500g = 'Cumbuca 500g';
  static const String cumbuca250g = 'Cumbuca 250g';
  static const String sacola = 'Sacola (Caixa)';

  static const List<String> opcoes = [cumbuca500g, cumbuca250g, sacola];

  /// Retorna a quantidade de amostras baseada no tipo
  static int quantidadeAmostrasPorTipo(String tipo) {
    switch (tipo) {
      case cumbuca500g:
        return 10; // A até J
      case cumbuca250g:
        return 20; // A até T
      case sacola:
        return 7; // A até G (padrão, pode ser editável)
      default:
        return 7;
    }
  }

  /// Retorna as letras das amostras baseada no tipo
  static List<String> letrasAmostrasPorTipo(String tipo) {
    const letras = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
    ];

    final quantidade = quantidadeAmostrasPorTipo(tipo);
    return letras.take(quantidade).toList();
  }
}

/// Constantes para as fazendas (siglas)
class FazendasSiglas {
  static const String purraVerde = 'PV';
  static const String joaoPaulo = 'JP';

  static const List<String> opcoes = [purraVerde, joaoPaulo];
}
