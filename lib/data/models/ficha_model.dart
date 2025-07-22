import '../../domain/entities/entities.dart';

/// Modelo de dados para Ficha (Data Transfer Object)
/// Responsável pela serialização/deserialização da entidade Ficha
class FichaModel {
  final String id;
  final String numeroFicha;
  final String dataAvaliacao; // ISO 8601 string
  final String cliente;
  final String produto;
  final String variedade;
  final String origem;
  final String lote;
  final double pesoTotal;
  final int quantidadeAmostras;
  final String responsavelAvaliacao;
  final String observacoes;
  final String criadoEm; // ISO 8601 string
  final String? atualizadoEm; // ISO 8601 string

  const FichaModel({
    required this.id,
    required this.numeroFicha,
    required this.dataAvaliacao,
    required this.cliente,
    required this.produto,
    required this.variedade,
    required this.origem,
    required this.lote,
    required this.pesoTotal,
    required this.quantidadeAmostras,
    required this.responsavelAvaliacao,
    required this.observacoes,
    required this.criadoEm,
    this.atualizadoEm,
  });

  /// Converte entidade para modelo
  factory FichaModel.fromEntity(Ficha ficha) {
    return FichaModel(
      id: ficha.id,
      numeroFicha: ficha.numeroFicha,
      dataAvaliacao: ficha.dataAvaliacao.toIso8601String(),
      cliente: ficha.cliente,
      produto: ficha.produto,
      variedade: ficha.variedade,
      origem: ficha.origem,
      lote: ficha.lote,
      pesoTotal: ficha.pesoTotal,
      quantidadeAmostras: ficha.quantidadeAmostras,
      responsavelAvaliacao: ficha.responsavelAvaliacao,
      observacoes: ficha.observacoes,
      criadoEm: ficha.criadoEm.toIso8601String(),
      atualizadoEm: ficha.atualizadoEm?.toIso8601String(),
    );
  }

  /// Converte modelo para entidade
  Ficha toEntity() {
    return Ficha(
      id: id,
      numeroFicha: numeroFicha,
      dataAvaliacao: DateTime.parse(dataAvaliacao),
      cliente: cliente,
      produto: produto,
      variedade: variedade,
      origem: origem,
      lote: lote,
      pesoTotal: pesoTotal,
      quantidadeAmostras: quantidadeAmostras,
      responsavelAvaliacao: responsavelAvaliacao,
      observacoes: observacoes,
      criadoEm: DateTime.parse(criadoEm),
      atualizadoEm: atualizadoEm != null ? DateTime.parse(atualizadoEm!) : null,
    );
  }

  /// Converte de JSON Map
  factory FichaModel.fromJson(Map<String, dynamic> json) {
    return FichaModel(
      id: json['id'] as String,
      numeroFicha: json['numero_ficha'] as String,
      dataAvaliacao: json['data_avaliacao'] as String,
      cliente: json['cliente'] as String,
      produto: json['produto'] as String,
      variedade: json['variedade'] as String,
      origem: json['origem'] as String,
      lote: json['lote'] as String,
      pesoTotal: (json['peso_total'] as num).toDouble(),
      quantidadeAmostras: json['quantidade_amostras'] as int,
      responsavelAvaliacao: json['responsavel_avaliacao'] as String,
      observacoes: json['observacoes'] as String? ?? '',
      criadoEm: json['criado_em'] as String,
      atualizadoEm: json['atualizado_em'] as String?,
    );
  }

  /// Converte para JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_ficha': numeroFicha,
      'data_avaliacao': dataAvaliacao,
      'cliente': cliente,
      'produto': produto,
      'variedade': variedade,
      'origem': origem,
      'lote': lote,
      'peso_total': pesoTotal,
      'quantidade_amostras': quantidadeAmostras,
      'responsavel_avaliacao': responsavelAvaliacao,
      'observacoes': observacoes,
      'criado_em': criadoEm,
      'atualizado_em': atualizadoEm,
    };
  }

  /// Converte para Map do SQLite
  Map<String, dynamic> toSqliteMap() {
    return {
      'id': id,
      'numero_ficha': numeroFicha,
      'data_avaliacao': dataAvaliacao,
      'cliente': cliente,
      'produto': produto,
      'variedade': variedade,
      'origem': origem,
      'lote': lote,
      'peso_total': pesoTotal,
      'quantidade_amostras': quantidadeAmostras,
      'responsavel_avaliacao': responsavelAvaliacao,
      'observacoes': observacoes,
      'criado_em': criadoEm,
      'atualizado_em': atualizadoEm,
    };
  }

  /// Cria do Map do SQLite
  factory FichaModel.fromSqliteMap(Map<String, dynamic> map) {
    return FichaModel(
      id: map['id'] as String,
      numeroFicha: map['numero_ficha'] as String,
      dataAvaliacao: map['data_avaliacao'] as String,
      cliente: map['cliente'] as String,
      produto: map['produto'] as String,
      variedade: map['variedade'] as String,
      origem: map['origem'] as String,
      lote: map['lote'] as String,
      pesoTotal: (map['peso_total'] as num).toDouble(),
      quantidadeAmostras: map['quantidade_amostras'] as int,
      responsavelAvaliacao: map['responsavel_avaliacao'] as String,
      observacoes: map['observacoes'] as String? ?? '',
      criadoEm: map['criado_em'] as String,
      atualizadoEm: map['atualizado_em'] as String?,
    );
  }
}
