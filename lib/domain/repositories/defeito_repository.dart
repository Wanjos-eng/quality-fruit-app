import '../entities/entities.dart';

/// Interface para operações de persistência de Defeitos
abstract class DefeitoRepository {
  /// Salva um novo defeito ou atualiza um existente
  Future<Defeito> salvar(Defeito defeito);

  /// Busca um defeito pelo ID
  Future<Defeito?> buscarPorId(String id);

  /// Lista todos os defeitos de uma amostra
  Future<List<Defeito>> listarPorAmostra(String amostraId);

  /// Lista defeitos por tipo em uma amostra
  Future<List<Defeito>> listarPorTipo({
    required String amostraId,
    required TipoDefeito tipo,
  });

  /// Lista defeitos por gravidade em uma amostra
  Future<List<Defeito>> listarPorGravidade({
    required String amostraId,
    required GravidadeDefeito gravidade,
  });

  /// Lista defeitos críticos de uma amostra
  Future<List<Defeito>> listarCriticos(String amostraId);

  /// Lista todos os defeitos de uma ficha (todas as amostras)
  Future<List<Defeito>> listarPorFicha(String fichaId);

  /// Lista defeitos críticos de uma ficha
  Future<List<Defeito>> listarCriticosPorFicha(String fichaId);

  /// Calcula o impacto total dos defeitos em uma amostra
  Future<double> calcularImpactoTotal(String amostraId);

  /// Calcula o impacto médio dos defeitos em uma ficha
  Future<double> calcularImpactoMedio(String fichaId);

  /// Conta defeitos por tipo em uma amostra
  Future<int> contarPorTipo({
    required String amostraId,
    required TipoDefeito tipo,
  });

  /// Conta defeitos críticos em uma ficha
  Future<int> contarCriticos(String fichaId);

  /// Lista tipos de defeitos mais frequentes
  Future<Map<TipoDefeito, int>> obterEstatisticasTipos(String fichaId);

  /// Lista gravidades mais frequentes
  Future<Map<GravidadeDefeito, int>> obterEstatisticasGravidades(
    String fichaId,
  );

  /// Exclui um defeito pelo ID
  Future<bool> excluir(String id);

  /// Exclui todos os defeitos de uma amostra
  Future<bool> excluirPorAmostra(String amostraId);

  /// Verifica se existe defeito do tipo na amostra
  Future<bool> existeTipo({
    required String amostraId,
    required TipoDefeito tipo,
  });
}
