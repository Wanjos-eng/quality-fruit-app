import '../../../domain/entities/ficha.dart';

/// Modelo de dados para Ficha com conversão JSON
/// Implementa serialização/deserialização para persistência local
class FichaModel extends Ficha {
  const FichaModel({
    required super.id,
    required super.numeroFicha,
    required super.dataAvaliacao,
    required super.cliente,
    // SEÇÃO 1: Novos campos obrigatórios
    required super.ano,
    required super.fazenda,
    required super.semanaAno,
    required super.inspetor,
    required super.tipoAmostragem,
    required super.pesoBrutoKg,
    // Campos antigos (mantidos para compatibilidade)
    required super.produto,
    required super.variedade,
    required super.origem,
    required super.lote,
    required super.pesoTotal,
    required super.quantidadeAmostras,
    required super.responsavelAvaliacao,
    required super.observacoes,
    required super.criadoEm,
    super.produtorResponsavel,
    super.observacaoA,
    super.observacaoB,
    super.observacaoC,
    super.observacaoD,
    super.observacaoF,
    super.observacaoG,
    super.atualizadoEm,
  });

  /// Factory para criar FichaModel a partir de entidade Ficha
  factory FichaModel.fromEntity(Ficha ficha) {
    return FichaModel(
      id: ficha.id,
      numeroFicha: ficha.numeroFicha,
      dataAvaliacao: ficha.dataAvaliacao,
      cliente: ficha.cliente,
      // SEÇÃO 1: Novos campos
      ano: ficha.ano,
      fazenda: ficha.fazenda,
      semanaAno: ficha.semanaAno,
      inspetor: ficha.inspetor,
      tipoAmostragem: ficha.tipoAmostragem,
      pesoBrutoKg: ficha.pesoBrutoKg,
      // Campos antigos
      produto: ficha.produto,
      variedade: ficha.variedade,
      origem: ficha.origem,
      lote: ficha.lote,
      pesoTotal: ficha.pesoTotal,
      quantidadeAmostras: ficha.quantidadeAmostras,
      responsavelAvaliacao: ficha.responsavelAvaliacao,
      produtorResponsavel: ficha.produtorResponsavel,
      observacoes: ficha.observacoes,
      observacaoA: ficha.observacaoA,
      observacaoB: ficha.observacaoB,
      observacaoC: ficha.observacaoC,
      observacaoD: ficha.observacaoD,
      observacaoF: ficha.observacaoF,
      observacaoG: ficha.observacaoG,
      criadoEm: ficha.criadoEm,
      atualizadoEm: ficha.atualizadoEm,
    );
  }

  /// Factory para criar FichaModel a partir de JSON
  factory FichaModel.fromJson(Map<String, dynamic> json) {
    return FichaModel(
      id: json['id'] as String,
      numeroFicha: json['numeroFicha'] as String,
      dataAvaliacao: DateTime.parse(json['dataAvaliacao'] as String),
      cliente: json['cliente'] as String,
      // SEÇÃO 1: Novos campos
      ano: json['ano'] as int,
      fazenda: json['fazenda'] as String,
      semanaAno: json['semanaAno'] as int,
      inspetor: json['inspetor'] as String,
      tipoAmostragem: json['tipoAmostragem'] as String,
      pesoBrutoKg: (json['pesoBrutoKg'] as num).toDouble(),
      // Campos antigos
      produto: json['produto'] as String,
      variedade: json['variedade'] as String,
      origem: json['origem'] as String,
      lote: json['lote'] as String,
      pesoTotal: (json['pesoTotal'] as num).toDouble(),
      quantidadeAmostras: json['quantidadeAmostras'] as int,
      responsavelAvaliacao: json['responsavelAvaliacao'] as String,
      produtorResponsavel: json['produtorResponsavel'] as String?,
      observacoes: json['observacoes'] as String,
      observacaoA: json['observacaoA'] as String?,
      observacaoB: json['observacaoB'] as String?,
      observacaoC: json['observacaoC'] as String?,
      observacaoD: json['observacaoD'] as String?,
      observacaoF: json['observacaoF'] as String?,
      observacaoG: json['observacaoG'] as String?,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
      atualizadoEm: json['atualizadoEm'] != null
          ? DateTime.parse(json['atualizadoEm'] as String)
          : null,
    );
  }

  /// Converte FichaModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroFicha': numeroFicha,
      'dataAvaliacao': dataAvaliacao.toIso8601String(),
      'cliente': cliente,
      // SEÇÃO 1: Novos campos
      'ano': ano,
      'fazenda': fazenda,
      'semanaAno': semanaAno,
      'inspetor': inspetor,
      'tipoAmostragem': tipoAmostragem,
      'pesoBrutoKg': pesoBrutoKg,
      // Campos antigos
      'produto': produto,
      'variedade': variedade,
      'origem': origem,
      'lote': lote,
      'pesoTotal': pesoTotal,
      'quantidadeAmostras': quantidadeAmostras,
      'responsavelAvaliacao': responsavelAvaliacao,
      'produtorResponsavel': produtorResponsavel,
      'observacoes': observacoes,
      'observacaoA': observacaoA,
      'observacaoB': observacaoB,
      'observacaoC': observacaoC,
      'observacaoD': observacaoD,
      'observacaoF': observacaoF,
      'observacaoG': observacaoG,
      'criadoEm': criadoEm.toIso8601String(),
      'atualizadoEm': atualizadoEm?.toIso8601String(),
    };
  }

  /// Converte para entidade do domínio
  Ficha toEntity() {
    return Ficha(
      id: id,
      numeroFicha: numeroFicha,
      dataAvaliacao: dataAvaliacao,
      cliente: cliente,
      // SEÇÃO 1: Novos campos
      ano: ano,
      fazenda: fazenda,
      semanaAno: semanaAno,
      inspetor: inspetor,
      tipoAmostragem: tipoAmostragem,
      pesoBrutoKg: pesoBrutoKg,
      // Campos antigos
      produto: produto,
      variedade: variedade,
      origem: origem,
      lote: lote,
      pesoTotal: pesoTotal,
      quantidadeAmostras: quantidadeAmostras,
      responsavelAvaliacao: responsavelAvaliacao,
      produtorResponsavel: produtorResponsavel,
      observacoes: observacoes,
      observacaoA: observacaoA,
      observacaoB: observacaoB,
      observacaoC: observacaoC,
      observacaoD: observacaoD,
      observacaoF: observacaoF,
      observacaoG: observacaoG,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm,
    );
  }

  /// Converte para mapa SQLite (para persistência local)
  Map<String, dynamic> toSqliteMap() {
    return {
      'id': id,
      'numeroFicha': numeroFicha,
      'dataAvaliacao': dataAvaliacao.millisecondsSinceEpoch,
      'cliente': cliente,
      // SEÇÃO 1: Novos campos
      'ano': ano,
      'fazenda': fazenda,
      'semanaAno': semanaAno,
      'inspetor': inspetor,
      'tipoAmostragem': tipoAmostragem,
      'pesoBrutoKg': pesoBrutoKg,
      // Campos antigos
      'produto': produto,
      'variedade': variedade,
      'origem': origem,
      'lote': lote,
      'pesoTotal': pesoTotal,
      'quantidadeAmostras': quantidadeAmostras,
      'responsavelAvaliacao': responsavelAvaliacao,
      'produtorResponsavel': produtorResponsavel,
      'observacoes': observacoes,
      'observacaoA': observacaoA,
      'observacaoB': observacaoB,
      'observacaoC': observacaoC,
      'observacaoD': observacaoD,
      'observacaoF': observacaoF,
      'observacaoG': observacaoG,
      'criadoEm': criadoEm.millisecondsSinceEpoch,
      'atualizadoEm': atualizadoEm?.millisecondsSinceEpoch,
    };
  }

  /// Factory para criar FichaModel a partir de mapa SQLite
  factory FichaModel.fromSqliteMap(Map<String, dynamic> map) {
    return FichaModel(
      id: map['id'] as String,
      numeroFicha: map['numeroFicha'] as String,
      dataAvaliacao: DateTime.fromMillisecondsSinceEpoch(
        map['dataAvaliacao'] as int,
      ),
      cliente: map['cliente'] as String,
      // SEÇÃO 1: Novos campos
      ano: map['ano'] as int,
      fazenda: map['fazenda'] as String,
      semanaAno: map['semanaAno'] as int,
      inspetor: map['inspetor'] as String,
      tipoAmostragem: map['tipoAmostragem'] as String,
      pesoBrutoKg: (map['pesoBrutoKg'] as num).toDouble(),
      // Campos antigos
      produto: map['produto'] as String,
      variedade: map['variedade'] as String,
      origem: map['origem'] as String,
      lote: map['lote'] as String,
      pesoTotal: (map['pesoTotal'] as num).toDouble(),
      quantidadeAmostras: map['quantidadeAmostras'] as int,
      responsavelAvaliacao: map['responsavelAvaliacao'] as String,
      produtorResponsavel: map['produtorResponsavel'] as String?,
      observacoes: map['observacoes'] as String,
      observacaoA: map['observacaoA'] as String?,
      observacaoB: map['observacaoB'] as String?,
      observacaoC: map['observacaoC'] as String?,
      observacaoD: map['observacaoD'] as String?,
      observacaoF: map['observacaoF'] as String?,
      observacaoG: map['observacaoG'] as String?,
      criadoEm: DateTime.fromMillisecondsSinceEpoch(map['criadoEm'] as int),
      atualizadoEm: map['atualizadoEm'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['atualizadoEm'] as int)
          : null,
    );
  }

  /// Cria uma cópia com alguns valores alterados
  @override
  FichaModel copyWith({
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
    return FichaModel(
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
}
