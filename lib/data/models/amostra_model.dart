import '../../domain/entities/entities.dart';

/// Modelo de dados para Amostra
class AmostraModel {
  final String id;
  final String fichaId;
  final int numeroAmostra;
  final double peso;
  final String observacoes;
  final String criadoEm;
  final String? atualizadoEm;

  const AmostraModel({
    required this.id,
    required this.fichaId,
    required this.numeroAmostra,
    required this.peso,
    required this.observacoes,
    required this.criadoEm,
    this.atualizadoEm,
  });

  /// Converte entidade para modelo
  factory AmostraModel.fromEntity(Amostra amostra) {
    return AmostraModel(
      id: amostra.id,
      fichaId: amostra.fichaId,
      numeroAmostra: amostra.numeroAmostra,
      peso: amostra.peso,
      observacoes: amostra.observacoes,
      criadoEm: amostra.criadoEm.toIso8601String(),
      atualizadoEm: amostra.atualizadoEm?.toIso8601String(),
    );
  }

  /// Converte modelo para entidade
  Amostra toEntity() {
    return Amostra(
      id: id,
      fichaId: fichaId,
      numeroAmostra: numeroAmostra,
      peso: peso,
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
      'numero_amostra': numeroAmostra,
      'peso': peso,
      'observacoes': observacoes,
      'criado_em': criadoEm,
      'atualizado_em': atualizadoEm,
    };
  }

  /// Cria do Map do SQLite
  factory AmostraModel.fromSqliteMap(Map<String, dynamic> map) {
    return AmostraModel(
      id: map['id'] as String,
      fichaId: map['ficha_id'] as String,
      numeroAmostra: map['numero_amostra'] as int,
      peso: (map['peso'] as num).toDouble(),
      observacoes: map['observacoes'] as String? ?? '',
      criadoEm: map['criado_em'] as String,
      atualizadoEm: map['atualizado_em'] as String?,
    );
  }
}
