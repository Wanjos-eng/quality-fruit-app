import '../../domain/entities/amostra_detalhada.dart';

/// Modelo de dados para AmostraDetalhada (Data Transfer Object)
/// Representa uma coluna da planilha física (A, B, C, D, E, F, G)
class AmostraDetalhadaModel {
  final String id;
  final String fichaId;
  final String letraAmostra;
  final String? data;
  final String? caixaMarca;
  final String? classe;
  final String? area;
  final String? variedade;
  final double? pesoBrutoKg;
  final String? sacolaCumbuca;
  final String? caixaCumbucaAlta;
  final String? aparenciaCalibro0a7;
  final String? corUMD;
  final double? pesoEmbalagem;
  final double? pesoLiquidoKg;
  final double? bagaMm;
  final double? brix;
  final double? brixMedia;
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
  final String criadoEm;
  final String? atualizadoEm;

  const AmostraDetalhadaModel({
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

  /// Converte entidade para modelo
  factory AmostraDetalhadaModel.fromEntity(AmostraDetalhada amostra) {
    return AmostraDetalhadaModel(
      id: amostra.id,
      fichaId: amostra.fichaId,
      letraAmostra: amostra.letraAmostra,
      data: amostra.data?.toIso8601String(),
      caixaMarca: amostra.caixaMarca,
      classe: amostra.classe,
      area: amostra.area,
      variedade: amostra.variedade,
      pesoBrutoKg: amostra.pesoBrutoKg,
      sacolaCumbuca: amostra.sacolaCumbuca,
      caixaCumbucaAlta: amostra.caixaCumbucaAlta,
      aparenciaCalibro0a7: amostra.aparenciaCalibro0a7,
      corUMD: amostra.corUMD,
      pesoEmbalagem: amostra.pesoEmbalagem,
      pesoLiquidoKg: amostra.pesoLiquidoKg,
      bagaMm: amostra.bagaMm,
      brix: amostra.brix,
      brixMedia: amostra.brixMedia,
      teiaAranha: amostra.teiaAranha,
      aranha: amostra.aranha,
      amassada: amostra.amassada,
      aquosaCorBaga: amostra.aquosaCorBaga,
      cachoDuro: amostra.cachoDuro,
      cachoRaloBanguelo: amostra.cachoRaloBanguelo,
      cicatriz: amostra.cicatriz,
      corpoEstranho: amostra.corpoEstranho,
      desgranePercentual: amostra.desgranePercentual,
      moscaFruta: amostra.moscaFruta,
      murcha: amostra.murcha,
      oidio: amostra.oidio,
      podre: amostra.podre,
      queimadoSol: amostra.queimadoSol,
      rachada: amostra.rachada,
      sacarose: amostra.sacarose,
      translucido: amostra.translucido,
      glomerella: amostra.glomerella,
      traca: amostra.traca,
      observacoes: amostra.observacoes,
      criadoEm: amostra.criadoEm.toIso8601String(),
      atualizadoEm: amostra.atualizadoEm?.toIso8601String(),
    );
  }

  /// Converte modelo para entidade
  AmostraDetalhada toEntity() {
    return AmostraDetalhada(
      id: id,
      fichaId: fichaId,
      letraAmostra: letraAmostra,
      data: data != null ? DateTime.parse(data!) : null,
      caixaMarca: caixaMarca,
      classe: classe,
      area: area,
      variedade: variedade,
      pesoBrutoKg: pesoBrutoKg,
      sacolaCumbuca: sacolaCumbuca,
      caixaCumbucaAlta: caixaCumbucaAlta,
      aparenciaCalibro0a7: aparenciaCalibro0a7,
      corUMD: corUMD,
      pesoEmbalagem: pesoEmbalagem,
      pesoLiquidoKg: pesoLiquidoKg,
      bagaMm: bagaMm,
      brix: brix,
      brixMedia: brixMedia,
      teiaAranha: teiaAranha,
      aranha: aranha,
      amassada: amassada,
      aquosaCorBaga: aquosaCorBaga,
      cachoDuro: cachoDuro,
      cachoRaloBanguelo: cachoRaloBanguelo,
      cicatriz: cicatriz,
      corpoEstranho: corpoEstranho,
      desgranePercentual: desgranePercentual,
      moscaFruta: moscaFruta,
      murcha: murcha,
      oidio: oidio,
      podre: podre,
      queimadoSol: queimadoSol,
      rachada: rachada,
      sacarose: sacarose,
      translucido: translucido,
      glomerella: glomerella,
      traca: traca,
      observacoes: observacoes,
      criadoEm: DateTime.parse(criadoEm),
      atualizadoEm: atualizadoEm != null ? DateTime.parse(atualizadoEm!) : null,
    );
  }

  /// Converte para Map do SQLite
  Map<String, dynamic> toSqliteMap() {
    return {
      'id': id,
      'ficha_id': fichaId,
      'letra_amostra': letraAmostra,
      'data': data,
      'caixa_marca': caixaMarca,
      'classe': classe,
      'area': area,
      'variedade': variedade,
      'peso_bruto_kg': pesoBrutoKg,
      'sacola_cumbuca': sacolaCumbuca,
      'caixa_cumbuca_alta': caixaCumbucaAlta,
      'aparencia_calibro_0a7': aparenciaCalibro0a7,
      'cor_umd': corUMD,
      'peso_embalagem': pesoEmbalagem,
      'peso_liquido_kg': pesoLiquidoKg,
      'baga_mm': bagaMm,
      'brix': brix,
      'brix_media': brixMedia,
      'teia_aranha': teiaAranha,
      'aranha': aranha,
      'amassada': amassada,
      'aquosa_cor_baga': aquosaCorBaga,
      'cacho_duro': cachoDuro,
      'cacho_ralo_banguelo': cachoRaloBanguelo,
      'cicatriz': cicatriz,
      'corpo_estranho': corpoEstranho,
      'desgrane_percentual': desgranePercentual,
      'mosca_fruta': moscaFruta,
      'murcha': murcha,
      'oidio': oidio,
      'podre': podre,
      'queimado_sol': queimadoSol,
      'rachada': rachada,
      'sacarose': sacarose,
      'translucido': translucido,
      'glomerella': glomerella,
      'traca': traca,
      'observacoes': observacoes,
      'criado_em': criadoEm,
      'atualizado_em': atualizadoEm,
    };
  }

  /// Cria do Map do SQLite
  factory AmostraDetalhadaModel.fromSqliteMap(Map<String, dynamic> map) {
    return AmostraDetalhadaModel(
      id: map['id'] as String,
      fichaId: map['ficha_id'] as String,
      letraAmostra: map['letra_amostra'] as String,
      data: map['data'] as String?,
      caixaMarca: map['caixa_marca'] as String?,
      classe: map['classe'] as String?,
      area: map['area'] as String?,
      variedade: map['variedade'] as String?,
      pesoBrutoKg: map['peso_bruto_kg'] as double?,
      sacolaCumbuca: map['sacola_cumbuca'] as String?,
      caixaCumbucaAlta: map['caixa_cumbuca_alta'] as String?,
      aparenciaCalibro0a7: map['aparencia_calibro_0a7'] as String?,
      corUMD: map['cor_umd'] as String?,
      pesoEmbalagem: map['peso_embalagem'] as double?,
      pesoLiquidoKg: map['peso_liquido_kg'] as double?,
      bagaMm: map['baga_mm'] as double?,
      brix: map['brix'] as double?,
      brixMedia: map['brix_media'] as double?,
      teiaAranha: map['teia_aranha'] as double?,
      aranha: map['aranha'] as double?,
      amassada: map['amassada'] as double?,
      aquosaCorBaga: map['aquosa_cor_baga'] as double?,
      cachoDuro: map['cacho_duro'] as double?,
      cachoRaloBanguelo: map['cacho_ralo_banguelo'] as double?,
      cicatriz: map['cicatriz'] as double?,
      corpoEstranho: map['corpo_estranho'] as double?,
      desgranePercentual: map['desgrane_percentual'] as double?,
      moscaFruta: map['mosca_fruta'] as double?,
      murcha: map['murcha'] as double?,
      oidio: map['oidio'] as double?,
      podre: map['podre'] as double?,
      queimadoSol: map['queimado_sol'] as double?,
      rachada: map['rachada'] as double?,
      sacarose: map['sacarose'] as double?,
      translucido: map['translucido'] as double?,
      glomerella: map['glomerella'] as double?,
      traca: map['traca'] as double?,
      observacoes: map['observacoes'] as String?,
      criadoEm: map['criado_em'] as String,
      atualizadoEm: map['atualizado_em'] as String?,
    );
  }

  /// Converte JSON para modelo
  factory AmostraDetalhadaModel.fromJson(Map<String, dynamic> json) {
    return AmostraDetalhadaModel(
      id: json['id'],
      fichaId: json['ficha_id'],
      letraAmostra: json['letra_amostra'],
      data: json['data'],
      caixaMarca: json['caixa_marca'],
      classe: json['classe'],
      area: json['area'],
      variedade: json['variedade'],
      pesoBrutoKg: json['peso_bruto_kg']?.toDouble(),
      sacolaCumbuca: json['sacola_cumbuca'],
      caixaCumbucaAlta: json['caixa_cumbuca_alta'],
      aparenciaCalibro0a7: json['aparencia_calibro_0a7'],
      corUMD: json['cor_umd'],
      pesoEmbalagem: json['peso_embalagem']?.toDouble(),
      pesoLiquidoKg: json['peso_liquido_kg']?.toDouble(),
      bagaMm: json['baga_mm']?.toDouble(),
      brix: json['brix']?.toDouble(),
      brixMedia: json['brix_media']?.toDouble(),
      teiaAranha: json['teia_aranha']?.toDouble(),
      aranha: json['aranha']?.toDouble(),
      amassada: json['amassada']?.toDouble(),
      aquosaCorBaga: json['aquosa_cor_baga']?.toDouble(),
      cachoDuro: json['cacho_duro']?.toDouble(),
      cachoRaloBanguelo: json['cacho_ralo_banguelo']?.toDouble(),
      cicatriz: json['cicatriz']?.toDouble(),
      corpoEstranho: json['corpo_estranho']?.toDouble(),
      desgranePercentual: json['desgrane_percentual']?.toDouble(),
      moscaFruta: json['mosca_fruta']?.toDouble(),
      murcha: json['murcha']?.toDouble(),
      oidio: json['oidio']?.toDouble(),
      podre: json['podre']?.toDouble(),
      queimadoSol: json['queimado_sol']?.toDouble(),
      rachada: json['rachada']?.toDouble(),
      sacarose: json['sacarose']?.toDouble(),
      translucido: json['translucido']?.toDouble(),
      glomerella: json['glomerella']?.toDouble(),
      traca: json['traca']?.toDouble(),
      observacoes: json['observacoes'],
      criadoEm: json['criado_em'],
      atualizadoEm: json['atualizado_em'],
    );
  }

  /// Converte modelo para JSON
  Map<String, dynamic> toJson() {
    return toSqliteMap(); // Mesmo formato
  }
}
