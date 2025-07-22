import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case para gerenciar amostras (CRUD completo)
class GerenciarAmostrasUseCase {
  final AmostraRepository _amostraRepository;
  final FichaRepository _fichaRepository;

  const GerenciarAmostrasUseCase(
    this._amostraRepository,
    this._fichaRepository,
  );

  /// Adiciona uma nova amostra à ficha
  Future<Amostra> adicionarAmostra(Amostra amostra) async {
    // Validação: ficha deve existir
    final ficha = await _fichaRepository.buscarPorId(amostra.fichaId);
    if (ficha == null) {
      throw Exception('Ficha não encontrada: ${amostra.fichaId}');
    }

    // Validação: número da amostra deve ser único na ficha
    if (await _amostraRepository.existeNumero(
      fichaId: amostra.fichaId,
      numeroAmostra: amostra.numeroAmostra,
    )) {
      throw Exception(
        'Número da amostra já existe na ficha: ${amostra.numeroAmostra}',
      );
    }

    // Validação: peso deve ser positivo
    if (amostra.peso <= 0) {
      throw Exception('Peso da amostra deve ser maior que zero');
    }

    // Validação: número da amostra deve ser positivo
    if (amostra.numeroAmostra <= 0) {
      throw Exception('Número da amostra deve ser maior que zero');
    }

    return await _amostraRepository.salvar(amostra);
  }

  /// Atualiza uma amostra existente
  Future<Amostra> atualizarAmostra(Amostra amostra) async {
    // Validação: amostra deve existir
    final amostraExistente = await _amostraRepository.buscarPorId(amostra.id);
    if (amostraExistente == null) {
      throw Exception('Amostra não encontrada: ${amostra.id}');
    }

    // Validação: peso deve ser positivo
    if (amostra.peso <= 0) {
      throw Exception('Peso da amostra deve ser maior que zero');
    }

    // Validação: se mudou o número, verificar se é único
    if (amostraExistente.numeroAmostra != amostra.numeroAmostra) {
      if (await _amostraRepository.existeNumero(
        fichaId: amostra.fichaId,
        numeroAmostra: amostra.numeroAmostra,
      )) {
        throw Exception(
          'Número da amostra já existe na ficha: ${amostra.numeroAmostra}',
        );
      }
    }

    final amostraAtualizada = amostra.copyWith(atualizadoEm: DateTime.now());

    return await _amostraRepository.salvar(amostraAtualizada);
  }

  /// Lista amostras de uma ficha
  Future<List<Amostra>> listarAmostras(String fichaId) async {
    if (fichaId.trim().isEmpty) {
      throw Exception('ID da ficha não pode estar vazio');
    }
    return await _amostraRepository.listarPorFicha(fichaId);
  }

  /// Remove uma amostra
  Future<bool> removerAmostra(String amostraId) async {
    if (amostraId.trim().isEmpty) {
      throw Exception('ID da amostra não pode estar vazio');
    }

    // Validação: amostra deve existir
    final amostra = await _amostraRepository.buscarPorId(amostraId);
    if (amostra == null) {
      throw Exception('Amostra não encontrada: $amostraId');
    }

    return await _amostraRepository.excluir(amostraId);
  }

  /// Busca amostra por ID
  Future<Amostra?> buscarAmostra(String amostraId) async {
    if (amostraId.trim().isEmpty) {
      throw Exception('ID da amostra não pode estar vazio');
    }
    return await _amostraRepository.buscarPorId(amostraId);
  }

  /// Calcula estatísticas das amostras de uma ficha
  Future<Map<String, dynamic>> calcularEstatisticas(String fichaId) async {
    final amostras = await _amostraRepository.listarPorFicha(fichaId);

    if (amostras.isEmpty) {
      return {
        'total': 0,
        'pesoTotal': 0.0,
        'pesoMedio': 0.0,
        'pesoMinimo': 0.0,
        'pesoMaximo': 0.0,
      };
    }

    final pesos = amostras.map((a) => a.peso).toList();
    final pesoTotal = pesos.reduce((a, b) => a + b);
    final pesoMedio = pesoTotal / amostras.length;
    final pesoMinimo = pesos.reduce((a, b) => a < b ? a : b);
    final pesoMaximo = pesos.reduce((a, b) => a > b ? a : b);

    return {
      'total': amostras.length,
      'pesoTotal': pesoTotal,
      'pesoMedio': pesoMedio,
      'pesoMinimo': pesoMinimo,
      'pesoMaximo': pesoMaximo,
    };
  }
}
