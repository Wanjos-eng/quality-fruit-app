import '../entities/entities.dart';

/// Interface para operações de persistência de Medidas
abstract class MedidaRepository {
  /// Salva uma nova medida ou atualiza uma existente
  Future<Medida> salvar(Medida medida);

  /// Busca uma medida pelo ID
  Future<Medida?> buscarPorId(String id);

  /// Lista todas as medidas de uma amostra
  Future<List<Medida>> listarPorAmostra(String amostraId);

  /// Lista medidas por tipo em uma amostra
  Future<List<Medida>> listarPorTipo({
    required String amostraId,
    required TipoMedida tipo,
  });

  /// Lista medidas por tipo em uma ficha (todas as amostras)
  Future<List<Medida>> listarPorTipoNaFicha({
    required String fichaId,
    required TipoMedida tipo,
  });

  /// Lista medidas fora dos parâmetros ideais
  Future<List<Medida>> listarForaParametros(String amostraId);

  /// Busca medida específica por amostra e tipo
  Future<Medida?> buscarPorAmostraETipo({
    required String amostraId,
    required TipoMedida tipo,
  });

  /// Calcula média de um tipo de medida para uma ficha
  Future<double?> calcularMedia({
    required String fichaId,
    required TipoMedida tipo,
  });

  /// Calcula valor mínimo de um tipo de medida
  Future<double?> calcularMinimo({
    required String fichaId,
    required TipoMedida tipo,
  });

  /// Calcula valor máximo de um tipo de medida
  Future<double?> calcularMaximo({
    required String fichaId,
    required TipoMedida tipo,
  });

  /// Exclui uma medida pelo ID
  Future<bool> excluir(String id);

  /// Exclui todas as medidas de uma amostra
  Future<bool> excluirPorAmostra(String amostraId);

  /// Conta medidas por tipo em uma amostra
  Future<int> contarPorTipo({
    required String amostraId,
    required TipoMedida tipo,
  });

  /// Verifica se existe medida do tipo na amostra
  Future<bool> existeTipo({
    required String amostraId,
    required TipoMedida tipo,
  });
}
