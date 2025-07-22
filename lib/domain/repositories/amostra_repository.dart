import '../entities/entities.dart';

/// Interface para operações de persistência de Amostras
abstract class AmostraRepository {
  /// Salva uma nova amostra ou atualiza uma existente
  Future<Amostra> salvar(Amostra amostra);

  /// Busca uma amostra pelo ID
  Future<Amostra?> buscarPorId(String id);

  /// Lista todas as amostras de uma ficha
  Future<List<Amostra>> listarPorFicha(String fichaId);

  /// Busca amostra por número dentro de uma ficha
  Future<Amostra?> buscarPorNumero({
    required String fichaId,
    required int numeroAmostra,
  });

  /// Lista amostras com filtro de peso
  Future<List<Amostra>> listarPorPeso({
    required String fichaId,
    double? pesoMinimo,
    double? pesoMaximo,
  });

  /// Exclui uma amostra pelo ID
  Future<bool> excluir(String id);

  /// Exclui todas as amostras de uma ficha
  Future<bool> excluirPorFicha(String fichaId);

  /// Conta o total de amostras de uma ficha
  Future<int> contarPorFicha(String fichaId);

  /// Calcula o peso total das amostras de uma ficha
  Future<double> calcularPesoTotal(String fichaId);

  /// Verifica se existe amostra com o número na ficha
  Future<bool> existeNumero({
    required String fichaId,
    required int numeroAmostra,
  });
}
