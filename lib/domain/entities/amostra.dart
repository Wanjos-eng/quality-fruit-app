/// Entidade que representa uma Amostra individual de fruta
/// Cada amostra é avaliada dentro de uma Ficha
class Amostra {
  final String id;
  final String fichaId; // Referência à ficha pai
  final int numeroAmostra;
  final double peso; // Em gramas
  final String observacoes;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;

  const Amostra({
    required this.id,
    required this.fichaId,
    required this.numeroAmostra,
    required this.peso,
    this.observacoes = '',
    required this.criadoEm,
    this.atualizadoEm,
  });

  /// Cria uma cópia da amostra com novos valores opcionais
  Amostra copyWith({
    String? id,
    String? fichaId,
    int? numeroAmostra,
    double? peso,
    String? observacoes,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Amostra(
      id: id ?? this.id,
      fichaId: fichaId ?? this.fichaId,
      numeroAmostra: numeroAmostra ?? this.numeroAmostra,
      peso: peso ?? this.peso,
      observacoes: observacoes ?? this.observacoes,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Amostra && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Amostra(id: $id, numeroAmostra: $numeroAmostra, peso: ${peso}g)';
  }
}
