import '../../domain/entities/entities.dart';

/// Modelo de dados para Defeito
class DefeitoModel {
  final String id;
  final String amostraId;
  final String tipo; // Enum convertido para string
  final String gravidade; // Enum convertido para string
  final String descricao;
  final double? porcentagemAfetada;
  final String? observacoes;
  final String criadoEm;
  final String? atualizadoEm;

  const DefeitoModel({
    required this.id,
    required this.amostraId,
    required this.tipo,
    required this.gravidade,
    required this.descricao,
    this.porcentagemAfetada,
    this.observacoes,
    required this.criadoEm,
    this.atualizadoEm,
  });

  /// Converte entidade para modelo
  factory DefeitoModel.fromEntity(Defeito defeito) {
    return DefeitoModel(
      id: defeito.id,
      amostraId: defeito.amostraId,
      tipo: defeito.tipo.name,
      gravidade: defeito.gravidade.name,
      descricao: defeito.descricao,
      porcentagemAfetada: defeito.porcentagemAfetada,
      observacoes: defeito.observacoes,
      criadoEm: defeito.criadoEm.toIso8601String(),
      atualizadoEm: defeito.atualizadoEm?.toIso8601String(),
    );
  }

  /// Converte modelo para entidade
  Defeito toEntity() {
    return Defeito(
      id: id,
      amostraId: amostraId,
      tipo: TipoDefeito.values.firstWhere((e) => e.name == tipo),
      gravidade: GravidadeDefeito.values.firstWhere((e) => e.name == gravidade),
      descricao: descricao,
      porcentagemAfetada: porcentagemAfetada,
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
      'gravidade': gravidade,
      'descricao': descricao,
      'porcentagem_afetada': porcentagemAfetada,
      'observacoes': observacoes,
      'criado_em': criadoEm,
      'atualizado_em': atualizadoEm,
    };
  }

  /// Cria do Map do SQLite
  factory DefeitoModel.fromSqliteMap(Map<String, dynamic> map) {
    return DefeitoModel(
      id: map['id'] as String,
      amostraId: map['amostra_id'] as String,
      tipo: map['tipo'] as String,
      gravidade: map['gravidade'] as String,
      descricao: map['descricao'] as String,
      porcentagemAfetada: map['porcentagem_afetada'] as double?,
      observacoes: map['observacoes'] as String?,
      criadoEm: map['criado_em'] as String,
      atualizadoEm: map['atualizado_em'] as String?,
    );
  }
}
