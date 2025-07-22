import '../../domain/entities/entities.dart';

/// Modelo de dados para Medida
class MedidaModel {
  final String id;
  final String amostraId;
  final String tipo; // Enum convertido para string
  final double valor;
  final String? observacoes;
  final String criadoEm;
  final String? atualizadoEm;

  const MedidaModel({
    required this.id,
    required this.amostraId,
    required this.tipo,
    required this.valor,
    this.observacoes,
    required this.criadoEm,
    this.atualizadoEm,
  });

  /// Converte entidade para modelo
  factory MedidaModel.fromEntity(Medida medida) {
    return MedidaModel(
      id: medida.id,
      amostraId: medida.amostraId,
      tipo: medida.tipo.name,
      valor: medida.valor,
      observacoes: medida.observacoes,
      criadoEm: medida.criadoEm.toIso8601String(),
      atualizadoEm: medida.atualizadoEm?.toIso8601String(),
    );
  }

  /// Converte modelo para entidade
  Medida toEntity() {
    return Medida(
      id: id,
      amostraId: amostraId,
      tipo: TipoMedida.values.firstWhere((e) => e.name == tipo),
      valor: valor,
      observacoes: observacoes,
      criadoEm: DateTime.parse(criadoEm),
      atualizadoEm: atualizadoEm != null ? DateTime.parse(atualizadoEm!) : null,
    );
  }

  /// Converte para Map do SQLite
  Map<String, dynamic> toSqliteMap() {
    return {
      'id': id,
      'amostra_id': amostraId,
      'tipo': tipo,
      'valor': valor,
      'observacoes': observacoes,
      'criado_em': criadoEm,
      'atualizado_em': atualizadoEm,
    };
  }

  /// Cria do Map do SQLite
  factory MedidaModel.fromSqliteMap(Map<String, dynamic> map) {
    return MedidaModel(
      id: map['id'] as String,
      amostraId: map['amostra_id'] as String,
      tipo: map['tipo'] as String,
      valor: (map['valor'] as num).toDouble(),
      observacoes: map['observacoes'] as String?,
      criadoEm: map['criado_em'] as String,
      atualizadoEm: map['atualizado_em'] as String?,
    );
  }
}
