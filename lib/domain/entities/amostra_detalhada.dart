/// Entidade que representa uma amostra individual na planilha de controle
/// Corresponde a cada coluna (A, B, C, D, E, F, G) da ficha física
class AmostraDetalhada {
  final String id;
  final String fichaId;
  final String letraAmostra; // A, B, C, D, E, F, G

  // SEÇÃO 1: INFORMAÇÕES GERAIS (preenchidas uma vez por dia)
  final DateTime? data;
  final String? caixaMarca;
  final String? classe;
  final String? area;
  final String? variedade;

  // Campos específicos com opções pré-definidas
  final String? sacolaCumbuca; // C=certa, E=errada
  final String? caixaCumbucaAlta; // S=sim, N=não
  final String? aparenciaCalibro0a7; // 0-7
  final String? embalagemCalibro0a7; // 0-7
  final String? corUMD; // U=uniforme, M=média, D=desuniforme
  final double? pesoEmbalagem; // Peso da embalagem apenas
  final double? bagaMm; // Formato "16-18" (menor-maior calibre)

  // SEÇÃO 2: MEDIDAS VARIÁVEIS (quantidade depende do tipo de amostragem)
  // PESO BRUTO: Múltiplas leituras conforme tipo de amostragem
  final List<double>?
  pesoBrutoLeituras; // Cumbuca 500g: 10 | Cumbuca 250g: 20 | Sacola: 1
  final double? pesoBrutoMedia; // Calculado automaticamente das leituras

  // PESO LÍQUIDO: Uma única medida
  final double? pesoLiquido; // Peso líquido em gramas

  // BRIX: Múltiplas leituras conforme tipo de amostragem (mesmo padrão do peso)
  final List<double>?
  brixLeituras; // Cumbuca 500g: 10 | Cumbuca 250g: 20 | Sacola: 1
  final double? brixMedia; // Calculado automaticamente das leituras

  // Campos antigos (mantidos para compatibilidade)
  final double? pesoBrutoKg;
  final double? pesoLiquidoKg;
  final double? brix;

  // SEÇÃO 3: DEFEITOS E PROBLEMAS (percentuais ou contagens)
  final double? teiaAranha;
  final double? aranha;
  final double? amassada;
  final double? aquosaCorBaga; // Mantido para compatibilidade
  final double?
  corBagaPercentual; // Novo campo: Cor da Baga (%) - múltiplos de 5%
  final double? cachoDuro;
  final double? cachoRaloBanguelo;
  final double? cicatriz;
  final double? corpoEstranho;
  final double? desgranePercentual;
  final double? glomerella;
  final double? lagarta; // NOVO CAMPO ADICIONADO
  final double? moscaFruta;
  final double? murcha;
  final double? oidio;
  final double? podre;
  final double? queimadoSol;
  final double? rachada;
  final double? sacarose;
  final double? translucido;
  final double? traca;

  final String? observacoes;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;

  const AmostraDetalhada({
    required this.id,
    required this.fichaId,
    required this.letraAmostra,
    required this.criadoEm,
    this.data,
    this.caixaMarca,
    this.classe,
    this.area,
    this.variedade,
    // Campos específicos
    this.sacolaCumbuca,
    this.caixaCumbucaAlta,
    this.aparenciaCalibro0a7,
    this.embalagemCalibro0a7,
    this.corUMD,
    this.pesoEmbalagem,
    this.bagaMm,
    // PESO BRUTO: Nova estrutura
    this.pesoBrutoLeituras,
    this.pesoBrutoMedia,
    this.pesoLiquido,
    // BRIX: Nova estrutura
    this.brixLeituras,
    this.brixMedia,
    // Campos antigos (compatibilidade)
    this.pesoBrutoKg,
    this.pesoLiquidoKg,
    this.brix,
    this.teiaAranha,
    this.aranha,
    this.amassada,
    this.aquosaCorBaga,
    this.corBagaPercentual, // Novo campo: Cor da Baga (%)
    this.cachoDuro,
    this.cachoRaloBanguelo,
    this.cicatriz,
    this.corpoEstranho,
    this.desgranePercentual,
    this.glomerella,
    this.lagarta,
    this.moscaFruta,
    this.murcha,
    this.oidio,
    this.podre,
    this.queimadoSol,
    this.rachada,
    this.sacarose,
    this.translucido,
    this.traca,
    this.observacoes,
    this.atualizadoEm,
  });

  /// Cria uma cópia com algumas propriedades alteradas
  AmostraDetalhada copyWith({
    String? id,
    String? fichaId,
    String? letraAmostra,
    // SEÇÃO 2: Campos conforme especificação oficial
    String? caixaMarca,
    String? classe,
    String? area,
    String? variedade,
    // Campos específicos
    String? sacolaCumbuca,
    String? caixaCumbucaAlta,
    String? aparenciaCalibro0a7,
    String? embalagemCalibro0a7,
    String? corUMD,
    double? pesoEmbalagem,
    double? bagaMm,
    // PESO BRUTO: Nova estrutura
    List<double>? pesoBrutoLeituras,
    double? pesoBrutoMedia,
    double? pesoLiquido,
    // BRIX: Nova estrutura
    List<double>? brixLeituras,
    double? brixMedia,
    // DEFEITOS: Conforme especificação
    double? teiaAranha,
    double? aranha,
    double? amassada,
    double? aquosa, // NOVO: Campo separado conforme especificação
    double? corDaBagaPercentual, // RENOMEADO: Cor da Baga (%)
    double? cachoDuro,
    double? cachoRaloBanguelo,
    double? cicatriz,
    double? corpoEstranho,
    double? desgranePercentual,
    double? glomerella,
    double? lagarta,
    double? moscaFruta,
    double? murcha,
    double? oidio,
    double? podre,
    double? queimadoSol,
    double? rachada,
    double? sacarose,
    double? translucido,
    double? traca,
    // Campos de compatibilidade (deprecados)
    DateTime? data,
    double? pesoBrutoKg,
    double? pesoLiquidoKg,
    double? brix,
    double? aquosaCorBaga,
    double? corBagaPercentual,
    String? observacoes,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return AmostraDetalhada(
      id: id ?? this.id,
      fichaId: fichaId ?? this.fichaId,
      letraAmostra: letraAmostra ?? this.letraAmostra,
      criadoEm: criadoEm ?? this.criadoEm,
      // SEÇÃO 2: Campos conforme especificação oficial
      caixaMarca: caixaMarca ?? this.caixaMarca,
      classe: classe ?? this.classe,
      area: area ?? this.area,
      variedade: variedade ?? this.variedade,
      // Campos específicos
      sacolaCumbuca: sacolaCumbuca ?? this.sacolaCumbuca,
      caixaCumbucaAlta: caixaCumbucaAlta ?? this.caixaCumbucaAlta,
      aparenciaCalibro0a7: aparenciaCalibro0a7 ?? this.aparenciaCalibro0a7,
      embalagemCalibro0a7: embalagemCalibro0a7 ?? this.embalagemCalibro0a7,
      corUMD: corUMD ?? this.corUMD,
      pesoEmbalagem: pesoEmbalagem ?? this.pesoEmbalagem,
      bagaMm: bagaMm ?? this.bagaMm,
      // PESO BRUTO: Nova estrutura
      pesoBrutoLeituras: pesoBrutoLeituras ?? this.pesoBrutoLeituras,
      pesoBrutoMedia: pesoBrutoMedia ?? this.pesoBrutoMedia,
      pesoLiquido: pesoLiquido ?? this.pesoLiquido,
      // BRIX: Nova estrutura
      brixLeituras: brixLeituras ?? this.brixLeituras,
      brixMedia: brixMedia ?? this.brixMedia,
      // DEFEITOS: Conforme especificação
      teiaAranha: teiaAranha ?? this.teiaAranha,
      aranha: aranha ?? this.aranha,
      amassada: amassada ?? this.amassada,
      // aquosa: Usar aquosaCorBaga temporariamente
      // corDaBagaPercentual: Usar corBagaPercentual temporariamente
      cachoDuro: cachoDuro ?? this.cachoDuro,
      cachoRaloBanguelo: cachoRaloBanguelo ?? this.cachoRaloBanguelo,
      cicatriz: cicatriz ?? this.cicatriz,
      corpoEstranho: corpoEstranho ?? this.corpoEstranho,
      desgranePercentual: desgranePercentual ?? this.desgranePercentual,
      glomerella: glomerella ?? this.glomerella,
      lagarta: lagarta ?? this.lagarta,
      moscaFruta: moscaFruta ?? this.moscaFruta,
      murcha: murcha ?? this.murcha,
      oidio: oidio ?? this.oidio,
      podre: podre ?? this.podre,
      queimadoSol: queimadoSol ?? this.queimadoSol,
      rachada: rachada ?? this.rachada,
      sacarose: sacarose ?? this.sacarose,
      translucido: translucido ?? this.translucido,
      traca: traca ?? this.traca,
      // Campos de compatibilidade (deprecados)
      data: data ?? this.data,
      pesoBrutoKg: pesoBrutoKg ?? this.pesoBrutoKg,
      pesoLiquidoKg: pesoLiquidoKg ?? this.pesoLiquidoKg,
      brix: brix ?? this.brix,
      aquosaCorBaga: aquosaCorBaga ?? this.aquosaCorBaga,
      corBagaPercentual: corBagaPercentual ?? this.corBagaPercentual,
      observacoes: observacoes ?? this.observacoes,
      atualizadoEm: atualizadoEm ?? DateTime.now(),
    );
  }

  /// Calcula a média automática das leituras de Brix
  double? get brixMediaCalculada {
    if (brixLeituras == null || brixLeituras!.isEmpty) return null;

    final somaTotal = brixLeituras!.fold(0.0, (sum, leitura) => sum + leitura);
    return somaTotal / brixLeituras!.length;
  }

  /// Verifica se as leituras de Brix estão completas (quantidade varia por tipo)
  bool brixLeiturasCompletas(int quantidadeEsperada) {
    return brixLeituras != null && brixLeituras!.length == quantidadeEsperada;
  }

  /// Calcula a média automática das leituras de Peso Bruto
  double? get pesoBrutoMediaCalculada {
    if (pesoBrutoLeituras == null || pesoBrutoLeituras!.isEmpty) return null;

    final somaTotal = pesoBrutoLeituras!.fold(
      0.0,
      (sum, leitura) => sum + leitura,
    );
    return somaTotal / pesoBrutoLeituras!.length;
  }

  /// Verifica se as leituras de peso estão completas (baseado no tipo de amostragem)
  bool pesoBrutoLeiturasCompletas(int quantidadeEsperada) {
    return pesoBrutoLeituras != null &&
        pesoBrutoLeituras!.length == quantidadeEsperada;
  }

  /// Verifica se peso e brix têm a mesma quantidade de leituras (devem ser iguais)
  bool get pesoEBrixConsistentes {
    final tamanhoPeso = pesoBrutoLeituras?.length ?? 0;
    final tamanhoBrix = brixLeituras?.length ?? 0;
    return tamanhoPeso == tamanhoBrix;
  }

  /// Verifica se a amostra tem dados mínimos para salvamento
  bool get temDadosMinimos {
    return letraAmostra.isNotEmpty && fichaId.isNotEmpty;
  }

  /// Calcula o percentual de preenchimento da amostra
  double get percentualPreenchimento {
    final totalCampos = 32; // Total de campos opcionais
    var preenchidos = 0;

    if (data != null) preenchidos++;
    if (caixaMarca?.isNotEmpty == true) preenchidos++;
    if (classe?.isNotEmpty == true) preenchidos++;
    if (area?.isNotEmpty == true) preenchidos++;
    if (variedade?.isNotEmpty == true) preenchidos++;
    if (pesoBrutoKg != null) preenchidos++;
    if (sacolaCumbuca?.isNotEmpty == true) preenchidos++;
    if (caixaCumbucaAlta?.isNotEmpty == true) preenchidos++;
    if (aparenciaCalibro0a7?.isNotEmpty == true) preenchidos++;
    if (embalagemCalibro0a7?.isNotEmpty == true) preenchidos++;
    if (corUMD?.isNotEmpty == true) preenchidos++;
    if (pesoEmbalagem != null) preenchidos++;
    if (pesoBrutoLeituras?.isNotEmpty == true) preenchidos++;
    if (pesoLiquido != null) preenchidos++;
    if (bagaMm != null) preenchidos++;
    if (brixLeituras?.isNotEmpty == true) preenchidos++;
    if (brixMedia != null) preenchidos++;
    if (teiaAranha != null) preenchidos++;
    if (aranha != null) preenchidos++;
    if (amassada != null) preenchidos++;
    if (aquosaCorBaga != null) preenchidos++;
    if (cachoDuro != null) preenchidos++;
    if (cachoRaloBanguelo != null) preenchidos++;
    if (cicatriz != null) preenchidos++;
    if (corpoEstranho != null) preenchidos++;
    if (desgranePercentual != null) preenchidos++;
    if (moscaFruta != null) preenchidos++;
    if (murcha != null) preenchidos++;
    if (oidio != null) preenchidos++;
    if (podre != null) preenchidos++;
    if (queimadoSol != null) preenchidos++;
    if (rachada != null) preenchidos++;
    if (sacarose != null) preenchidos++;
    if (translucido != null) preenchidos++;
    if (glomerella != null) preenchidos++;
    if (lagarta != null) preenchidos++;
    if (traca != null) preenchidos++;

    return (preenchidos / totalCampos) * 100;
  }

  /// Lista de defeitos encontrados
  List<Map<String, dynamic>> get defeitosEncontrados {
    final defeitos = <Map<String, dynamic>>[];

    if (teiaAranha != null && teiaAranha! > 0) {
      defeitos.add({'tipo': 'Teia de Aranha', 'valor': teiaAranha});
    }
    if (aranha != null && aranha! > 0) {
      defeitos.add({'tipo': 'Aranha', 'valor': aranha});
    }
    if (amassada != null && amassada! > 0) {
      defeitos.add({'tipo': 'Amassada', 'valor': amassada});
    }
    if (aquosaCorBaga != null && aquosaCorBaga! > 0) {
      defeitos.add({'tipo': 'Aquosa Cor Baga', 'valor': aquosaCorBaga});
    }
    if (podre != null && podre! > 0) {
      defeitos.add({'tipo': 'Podre', 'valor': podre});
    }
    if (oidio != null && oidio! > 0) {
      defeitos.add({'tipo': 'Oídio', 'valor': oidio});
    }

    return defeitos;
  }

  @override
  String toString() {
    return 'AmostraDetalhada(id: $id, letra: $letraAmostra, ficha: $fichaId, preenchimento: ${percentualPreenchimento.toStringAsFixed(1)}%)';
  }
}

/// Constantes para validação da ficha física
class FichaFisicaConstants {
  // Opções para Sacola/Cumbuca
  static const List<String> opcoesSacolaCumbuca = [
    'C',
    'E',
  ]; // C=certa, E=errada

  // Opções para Caixa/Cumbuca Alta
  static const List<String> opcoesCaixaCumbucaAlta = ['S', 'N']; // S=sim, N=não

  // Opções para Cor UMD
  static const List<String> opcoesCorUMD = [
    'U',
    'M',
    'D',
  ]; // U=uniforme, M=média, D=desuniforme

  // Range para Aparência/Calibre
  static const int minCalibre = 0;
  static const int maxCalibre = 7;

  // SEÇÃO 2: Variedades de uva (conforme especificação)
  static const List<String> variedadesUva = [
    'ARRA15',
    'AUTUMNCRISP',
    'CRIMSON',
    'BRS ISIS',
    'BRS VITÓRIA',
    'BRS MELODIA',
    'KRISSY',
    'MELANIE',
    'MELODY',
    'MOSCATO',
    'NUBIA',
    'RED GLOBE',
    'SUGAR CRISP',
    'SUGRAONE',
    'SWEET GLOBE',
    'TIMCO',
    'TIMPSON',
    'Outros', // Opção para campo livre
  ];

  // Opções para Classe
  static const List<String> opcoesClasse = ['Clamshell', 'Open', 'Sacola'];

  // Opções para Cor da Baga em percentual (múltiplos de 5%)
  static const List<double> opcoesCorBagaPercentual = [
    0.0,
    5.0,
    10.0,
    15.0,
    20.0,
    25.0,
    30.0,
    35.0,
    40.0,
    45.0,
    50.0,
    55.0,
    60.0,
    65.0,
    70.0,
    75.0,
    80.0,
    85.0,
    90.0,
    95.0,
    100.0,
  ];

  // Letras das amostras
  static const List<String> letrasAmostras = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
  ];

  // Defeitos principais
  static const List<String> defeitosPrincipais = [
    'Teia de Aranha',
    'Aranha',
    'Amassada',
    'Aquosa Cor Baga',
    'Cacho duro',
    'Cacho ralo / banguelo',
    'Cicatriz',
    'Corpo estranho',
    'Desgrane',
    'Mosca da fruta',
    'Murcha',
    'Oídio',
    'Podre',
    'Queimado sol',
    'Rachada',
    'Sacarose',
    'Translúcido',
    'Glomerella',
    'Traça',
  ];
}
