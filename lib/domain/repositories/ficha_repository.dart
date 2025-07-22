import '../entities/entities.dart';

/// Interface para operações de persistência de Fichas
/// Define o contrato que deve ser implementado pela camada de dados
abstract class FichaRepository {
  /// Salva uma nova ficha ou atualiza uma existente
  Future<Ficha> salvar(Ficha ficha);

  /// Busca uma ficha pelo ID
  Future<Ficha?> buscarPorId(String id);

  /// Busca uma ficha pelo número
  Future<Ficha?> buscarPorNumero(String numeroFicha);

  /// Lista todas as fichas com paginação opcional
  Future<List<Ficha>> listarTodas({int? limite, int? offset});

  /// Lista fichas por cliente
  Future<List<Ficha>> listarPorCliente(String cliente);

  /// Lista fichas por produto
  Future<List<Ficha>> listarPorProduto(String produto);

  /// Lista fichas por período
  Future<List<Ficha>> listarPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  });

  /// Lista fichas recentes (últimas 10)
  Future<List<Ficha>> listarRecentes();

  /// Exclui uma ficha pelo ID
  Future<bool> excluir(String id);

  /// Conta o total de fichas
  Future<int> contarTotal();

  /// Verifica se existe uma ficha com o número especificado
  Future<bool> existeNumero(String numeroFicha);
}
