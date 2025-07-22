/// Entidade que representa uma amostra individual na planilha de controle
/// Corresponde a cada coluna (A, B, C, D, E, F, G) da ficha física
class AmostraDetalhada {
  final String id;
  final String fichaId;
  final String letraAmostra; // A, B, C, D, E, F, G
  final DateTime? data;
  final String? caixaMarca;
  final String? classe;
  final String? area;
  final String? variedade;
  final double? pesoBrutoKg;

  // Campos específicos com opções pré-definidas
  final String? sacolaCumbuca; // C=certa, E=errada
  final String? caixaCumbucaAlta; // S=sim, N=não
  final String? aparenciaCalibro0a7; // 0-7
  final String? corUMD; // U=uniforme, M=média, D=desuniforme
  final double? pesoEmbalagem;
  final double? pesoLiquidoKg;
  final double? bagaMm;
  final double? brix;
  final double? brixMedia;

  // Defeitos e problemas (percentuais ou contagens)
  final double? teiaAranha;
  final double? aranha;
  final double? amassada;
  final double? aquosaCorBaga;
  final double? cachoDuro;
  final double? cachoRaloBanguelo;
  final double? cicatriz;
  final double? corpoEstranho;
  final double? desgranePercentual;
  final double? moscaFruta;
  final double? murcha;
  final double? oidio;
  final double? podre;
  final double? queimadoSol;
  final double? rachada;
  final double? sacarose;
  final double? translucido;
  final double? glomerella;
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
    this.pesoBrutoKg,
    this.sacolaCumbuca,
    this.caixaCumbucaAlta,
    this.aparenciaCalibro0a7,
    this.corUMD,
    this.pesoEmbalagem,
    this.pesoLiquidoKg,
    this.bagaMm,
    this.brix,
    this.brixMedia,
    this.teiaAranha,
    this.aranha,
    this.amassada,
    this.aquosaCorBaga,
    this.cachoDuro,
    this.cachoRaloBanguelo,
    this.cicatriz,
    this.corpoEstranho,
    this.desgranePercentual,
    this.moscaFruta,
    this.murcha,
    this.oidio,
    this.podre,
    this.queimadoSol,
    this.rachada,
    this.sacarose,
    this.translucido,
    this.glomerella,
    this.traca,
    this.observacoes,
    this.atualizadoEm,
  });

  /// Cria uma cópia com algumas propriedades alteradas
  AmostraDetalhada copyWith({
    String? id,
    String? fichaId,
    String? letraAmostra,
    DateTime? data,
    String? caixaMarca,
    String? classe,
    String? area,
    String? variedade,
    double? pesoBrutoKg,
    String? sacolaCumbuca,
    String? caixaCumbucaAlta,
    String? aparenciaCalibro0a7,
    String? corUMD,
    double? pesoEmbalagem,
    double? pesoLiquidoKg,
    double? bagaMm,
    double? brix,
    double? brixMedia,
    double? teiaAranha,
    double? aranha,
    double? amassada,
    double? aquosaCorBaga,
    double? cachoDuro,
    double? cachoRaloBanguelo,
    double? cicatriz,
    double? corpoEstranho,
    double? desgranePercentual,
    double? moscaFruta,
    double? murcha,
    double? oidio,
    double? podre,
    double? queimadoSol,
    double? rachada,
    double? sacarose,
    double? translucido,
    double? glomerella,
    double? traca,
    String? observacoes,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return AmostraDetalhada(
      id: id ?? this.id,
      fichaId: fichaId ?? this.fichaId,
      letraAmostra: letraAmostra ?? this.letraAmostra,
      data: data ?? this.data,
      caixaMarca: caixaMarca ?? this.caixaMarca,
      classe: classe ?? this.classe,
      area: area ?? this.area,
      variedade: variedade ?? this.variedade,
      pesoBrutoKg: pesoBrutoKg ?? this.pesoBrutoKg,
      sacolaCumbuca: sacolaCumbuca ?? this.sacolaCumbuca,
      caixaCumbucaAlta: caixaCumbucaAlta ?? this.caixaCumbucaAlta,
      aparenciaCalibro0a7: aparenciaCalibro0a7 ?? this.aparenciaCalibro0a7,
      corUMD: corUMD ?? this.corUMD,
      pesoEmbalagem: pesoEmbalagem ?? this.pesoEmbalagem,
      pesoLiquidoKg: pesoLiquidoKg ?? this.pesoLiquidoKg,
      bagaMm: bagaMm ?? this.bagaMm,
      brix: brix ?? this.brix,
      brixMedia: brixMedia ?? this.brixMedia,
      teiaAranha: teiaAranha ?? this.teiaAranha,
      aranha: aranha ?? this.aranha,
      amassada: amassada ?? this.amassada,
      aquosaCorBaga: aquosaCorBaga ?? this.aquosaCorBaga,
      cachoDuro: cachoDuro ?? this.cachoDuro,
      cachoRaloBanguelo: cachoRaloBanguelo ?? this.cachoRaloBanguelo,
      cicatriz: cicatriz ?? this.cicatriz,
      corpoEstranho: corpoEstranho ?? this.corpoEstranho,
      desgranePercentual: desgranePercentual ?? this.desgranePercentual,
      moscaFruta: moscaFruta ?? this.moscaFruta,
      murcha: murcha ?? this.murcha,
      oidio: oidio ?? this.oidio,
      podre: podre ?? this.podre,
      queimadoSol: queimadoSol ?? this.queimadoSol,
      rachada: rachada ?? this.rachada,
      sacarose: sacarose ?? this.sacarose,
      translucido: translucido ?? this.translucido,
      glomerella: glomerella ?? this.glomerella,
      traca: traca ?? this.traca,
      observacoes: observacoes ?? this.observacoes,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? DateTime.now(),
    );
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
    if (corUMD?.isNotEmpty == true) preenchidos++;
    if (pesoEmbalagem != null) preenchidos++;
    if (pesoLiquidoKg != null) preenchidos++;
    if (bagaMm != null) preenchidos++;
    if (brix != null) preenchidos++;
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
