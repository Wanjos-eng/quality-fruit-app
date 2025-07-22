/// Enum que define os tipos de defeitos possíveis
enum TipoDefeito {
  manchas('Manchas'),
  rachadura('Rachadura'),
  amassado('Amassado'),
  podridao('Podridão'),
  picada('Picada de Inseto'),
  deformacao('Deformação'),
  corte('Corte/Ferimento'),
  murcha('Murcha'),
  queimadura('Queimadura Solar'),
  outros('Outros');

  const TipoDefeito(this.nome);

  final String nome;
}

/// Enum que define a gravidade do defeito
enum GravidadeDefeito {
  leve('Leve', 1),
  moderado('Moderado', 2),
  grave('Grave', 3),
  severo('Severo', 4);

  const GravidadeDefeito(this.nome, this.peso);

  final String nome;
  final int peso;
}

/// Entidade que representa um Defeito encontrado em uma amostra
class Defeito {
  final String id;
  final String amostraId; // Referência à amostra pai
  final TipoDefeito tipo;
  final GravidadeDefeito gravidade;
  final String descricao;
  final double? porcentagemAfetada; // % da amostra afetada (0-100)
  final String? observacoes;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;

  const Defeito({
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

  /// Calcula o impacto do defeito na qualidade (0-100)
  double get impactoQualidade {
    final baseImpact = gravidade.peso * 5.0; // Base de 5, 10, 15, 20
    final percentageFactor = (porcentagemAfetada ?? 10.0) / 100.0;
    return (baseImpact * percentageFactor).clamp(0.0, 20.0);
  }

  /// Verifica se é um defeito crítico (impacto > 15)
  bool get isCritico => impactoQualidade > 15.0;

  /// Retorna a cor associada à gravidade do defeito
  String get corGravidade {
    switch (gravidade) {
      case GravidadeDefeito.leve:
        return '#FFC107'; // Amarelo
      case GravidadeDefeito.moderado:
        return '#FF9800'; // Laranja
      case GravidadeDefeito.grave:
        return '#F44336'; // Vermelho
      case GravidadeDefeito.severo:
        return '#9C27B0'; // Roxo
    }
  }

  /// Cria uma cópia do defeito com novos valores opcionais
  Defeito copyWith({
    String? id,
    String? amostraId,
    TipoDefeito? tipo,
    GravidadeDefeito? gravidade,
    String? descricao,
    double? porcentagemAfetada,
    String? observacoes,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Defeito(
      id: id ?? this.id,
      amostraId: amostraId ?? this.amostraId,
      tipo: tipo ?? this.tipo,
      gravidade: gravidade ?? this.gravidade,
      descricao: descricao ?? this.descricao,
      porcentagemAfetada: porcentagemAfetada ?? this.porcentagemAfetada,
      observacoes: observacoes ?? this.observacoes,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Defeito && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Defeito(id: $id, tipo: ${tipo.nome}, gravidade: ${gravidade.nome})';
  }
}
