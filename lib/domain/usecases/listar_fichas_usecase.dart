import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case para listar fichas com filtros e ordenação
class ListarFichasUseCase {
  final FichaRepository _fichaRepository;

  const ListarFichasUseCase(this._fichaRepository);

  /// Lista fichas recentes
  Future<List<Ficha>> listarRecentes() async {
    return await _fichaRepository.listarRecentes();
  }

  /// Lista fichas por cliente
  Future<List<Ficha>> listarPorCliente(String cliente) async {
    if (cliente.trim().isEmpty) {
      throw Exception('Nome do cliente não pode estar vazio');
    }
    return await _fichaRepository.listarPorCliente(cliente);
  }

  /// Lista fichas por produto
  Future<List<Ficha>> listarPorProduto(String produto) async {
    if (produto.trim().isEmpty) {
      throw Exception('Nome do produto não pode estar vazio');
    }
    return await _fichaRepository.listarPorProduto(produto);
  }

  /// Lista fichas por período
  Future<List<Ficha>> listarPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    // Validação: data início não pode ser maior que data fim
    if (dataInicio.isAfter(dataFim)) {
      throw Exception('Data de início não pode ser posterior à data final');
    }

    // Validação: período não pode ser futuro
    if (dataInicio.isAfter(DateTime.now())) {
      throw Exception('Data de início não pode ser futura');
    }

    return await _fichaRepository.listarPorPeriodo(
      dataInicio: dataInicio,
      dataFim: dataFim,
    );
  }

  /// Lista todas as fichas com paginação
  Future<List<Ficha>> listarTodas({int? limite, int? offset}) async {
    // Validação: limite deve ser positivo
    if (limite != null && limite <= 0) {
      throw Exception('Limite deve ser maior que zero');
    }

    // Validação: offset deve ser não negativo
    if (offset != null && offset < 0) {
      throw Exception('Offset não pode ser negativo');
    }

    return await _fichaRepository.listarTodas(limite: limite, offset: offset);
  }

  /// Busca ficha por ID
  Future<Ficha?> buscarPorId(String id) async {
    if (id.trim().isEmpty) {
      throw Exception('ID não pode estar vazio');
    }
    return await _fichaRepository.buscarPorId(id);
  }

  /// Busca ficha por número
  Future<Ficha?> buscarPorNumero(String numeroFicha) async {
    if (numeroFicha.trim().isEmpty) {
      throw Exception('Número da ficha não pode estar vazio');
    }
    return await _fichaRepository.buscarPorNumero(numeroFicha);
  }
}
