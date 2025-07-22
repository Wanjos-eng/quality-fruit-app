/// Enum que define os tipos de medidas de qualidade disponíveis
enum TipoMedida {
  brix('Brix', '°Bx'),
  acidez('Acidez', '%'),
  ph('pH', ''),
  firmeza('Firmeza', 'N'),
  coloracao('Coloração', ''),
  tamanho('Tamanho', 'mm'),
  peso('Peso', 'g'),
  umidade('Umidade', '%'),
  temperatura('Temperatura', '°C');

  const TipoMedida(this.nome, this.unidade);

  final String nome;
  final String unidade;
}

/// Entidade que representa uma Medida de qualidade específica
/// Cada medida pertence a uma amostra e tem um tipo específico
class Medida {
  final String id;
  final String amostraId; // Referência à amostra pai
  final TipoMedida tipo;
  final double valor;
  final String? observacoes;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;

  const Medida({
    required this.id,
    required this.amostraId,
    required this.tipo,
    required this.valor,
    this.observacoes,
    required this.criadoEm,
    this.atualizadoEm,
  });

  /// Retorna o valor formatado com a unidade
  String get valorFormatado {
    if (tipo.unidade.isEmpty) {
      return valor.toStringAsFixed(2);
    }
    return '${valor.toStringAsFixed(2)} ${tipo.unidade}';
  }

  /// Verifica se a medida está dentro dos parâmetros ideais
  bool get dentroParametros {
    switch (tipo) {
      case TipoMedida.brix:
        return valor >= 12.0 && valor <= 18.0;
      case TipoMedida.acidez:
        return valor >= 0.3 && valor <= 0.8;
      case TipoMedida.ph:
        return valor >= 3.0 && valor <= 4.5;
      case TipoMedida.firmeza:
        return valor >= 50.0 && valor <= 80.0;
      default:
        return true; // Para outros tipos, considera sempre dentro do parâmetro
    }
  }

  /// Cria uma cópia da medida com novos valores opcionais
  Medida copyWith({
    String? id,
    String? amostraId,
    TipoMedida? tipo,
    double? valor,
    String? observacoes,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Medida(
      id: id ?? this.id,
      amostraId: amostraId ?? this.amostraId,
      tipo: tipo ?? this.tipo,
      valor: valor ?? this.valor,
      observacoes: observacoes ?? this.observacoes,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Medida && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Medida(id: $id, tipo: ${tipo.nome}, valor: $valorFormatado)';
  }
}
