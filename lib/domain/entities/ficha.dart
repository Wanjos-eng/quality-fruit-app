/// Entidade principal que representa uma Ficha de Avaliação de Qualidade
/// Contém informações gerais sobre a avaliação de frutas
class Ficha {
  final String id;
  final String numeroFicha;
  final DateTime dataAvaliacao;
  final String cliente;
  final String produto; // Tipo de fruta
  final String variedade;
  final String origem;
  final String lote;
  final double pesoTotal; // Em kg
  final int quantidadeAmostras;
  final String responsavelAvaliacao;
  final String observacoes;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;

  const Ficha({
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
    this.observacoes = '',
    required this.criadoEm,
    this.atualizadoEm,
  });

  /// Cria uma cópia da ficha com novos valores opcionais
  Ficha copyWith({
    String? id,
    String? numeroFicha,
    DateTime? dataAvaliacao,
    String? cliente,
    String? produto,
    String? variedade,
    String? origem,
    String? lote,
    double? pesoTotal,
    int? quantidadeAmostras,
    String? responsavelAvaliacao,
    String? observacoes,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Ficha(
      id: id ?? this.id,
      numeroFicha: numeroFicha ?? this.numeroFicha,
      dataAvaliacao: dataAvaliacao ?? this.dataAvaliacao,
      cliente: cliente ?? this.cliente,
      produto: produto ?? this.produto,
      variedade: variedade ?? this.variedade,
      origem: origem ?? this.origem,
      lote: lote ?? this.lote,
      pesoTotal: pesoTotal ?? this.pesoTotal,
      quantidadeAmostras: quantidadeAmostras ?? this.quantidadeAmostras,
      responsavelAvaliacao: responsavelAvaliacao ?? this.responsavelAvaliacao,
      observacoes: observacoes ?? this.observacoes,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ficha && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Ficha(id: $id, numeroFicha: $numeroFicha, produto: $produto, cliente: $cliente)';
  }
}
