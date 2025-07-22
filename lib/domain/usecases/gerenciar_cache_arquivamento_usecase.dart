import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../../data/datasources/cache_service.dart';
import '../../data/datasources/sincronizacao_service.dart';

/// Resultado da operação de salvamento
class ResultadoSalvamento {
  final bool sucesso;
  final String? erro;
  final Ficha? ficha;
  final String? caminhoArquivo;

  const ResultadoSalvamento({
    required this.sucesso,
    this.erro,
    this.ficha,
    this.caminhoArquivo,
  });
}

/// Opções para recuperação de rascunho
enum AcaoRascunho {
  recuperar,    // Recupera o rascunho
  ignorar,      // Ignora e limpa o rascunho
  manter,       // Mantém o rascunho para depois
}

/// Use case para gerenciar cache, rascunhos e arquivamento
class GerenciarCacheArquivamentoUseCase {
  final FichaRepository _fichaRepository;
  final AmostraRepository _amostraRepository;
  final MedidaRepository _medidaRepository;
  final DefeitoRepository _defeitoRepository;
  final CacheService _cacheService;
  final SincronizacaoService _sincronizacaoService;

  const GerenciarCacheArquivamentoUseCase(
    this._fichaRepository,
    this._amostraRepository,
    this._medidaRepository,
    this._defeitoRepository,
    this._cacheService,
    this._sincronizacaoService,
  );

  /// Verifica se existe rascunho e retorna informações
  Future<Map<String, dynamic>?> verificarRascunho() async {
    if (!await _cacheService.existeRascunhoFicha()) return null;

    final ficha = await _cacheService.recuperarRascunhoFicha();
    final dataRascunho = await _cacheService.obterDataUltimoRascunho();
    final especialista = await _cacheService.obterEspecialista();

    if (ficha == null) return null;

    return {
      'ficha': ficha,
      'data_rascunho': dataRascunho,
      'especialista': especialista,
      'tempo_decorrido': dataRascunho != null 
          ? DateTime.now().difference(dataRascunho).inMinutes
          : null,
    };
  }

  /// Processa ação do usuário sobre o rascunho
  Future<Ficha?> processarAcaoRascunho(AcaoRascunho acao) async {
    switch (acao) {
      case AcaoRascunho.recuperar:
        return await _cacheService.recuperarRascunhoFicha();
      
      case AcaoRascunho.ignorar:
        await _cacheService.limparTodosRascunhos();
        return null;
      
      case AcaoRascunho.manter:
        return null; // Não faz nada, mantém o rascunho
    }
  }

  /// Salva rascunho automaticamente durante preenchimento
  Future<void> salvarRascunhoAutomatico(Ficha ficha) async {
    await _cacheService.salvarRascunhoFicha(ficha);
  }

  /// Salva rascunho de amostras
  Future<void> salvarRascunhoAmostras(String fichaId, List<Amostra> amostras) async {
    await _cacheService.salvarRascunhoAmostras(fichaId, amostras);
  }

  /// Salva ficha finalizando o processo
  Future<ResultadoSalvamento> finalizarSalvamento({
    required Ficha ficha,
    required List<Amostra> amostras,
    required List<Medida> medidas,
    required List<Defeito> defeitos,
    required String especialista,
    bool salvarArquivo = true,
  }) async {
    try {
      // 1. Salva no banco local
      final fichaSalva = await _fichaRepository.salvar(ficha);
      
      // 2. Salva amostras
      for (final amostra in amostras) {
        await _amostraRepository.salvar(amostra.copyWith(fichaId: fichaSalva.id));
      }

      // 3. Salva medidas
      for (final medida in medidas) {
        await _medidaRepository.salvar(medida);
      }

      // 4. Salva defeitos
      for (final defeito in defeitos) {
        await _defeitoRepository.salvar(defeito);
      }

      // 5. Salva arquivo local organizado (se solicitado)
      String? caminhoArquivo;
      if (salvarArquivo) {
        final arquivo = await _sincronizacaoService.salvarDadosCompletos(
          ficha: fichaSalva,
          amostras: amostras,
          medidas: medidas,
          defeitos: defeitos,
          especialista: especialista,
        );
        caminhoArquivo = arquivo.path;
      }

      // 6. Limpa rascunhos após salvamento bem-sucedido
      await _cacheService.limparRascunhoFicha();
      await _cacheService.limparRascunhoAmostras(fichaSalva.id);

      return ResultadoSalvamento(
        sucesso: true,
        ficha: fichaSalva,
        caminhoArquivo: caminhoArquivo,
      );

    } catch (e) {
      return ResultadoSalvamento(
        sucesso: false,
        erro: 'Erro ao salvar: ${e.toString()}',
      );
    }
  }

  /// Executa arquivamento mensal automático
  Future<Map<String, dynamic>> executarArquivamentoMensal({
    required String especialista,
    int? ano,
    int? mes,
  }) async {
    final dataArquivamento = DateTime.now();
    final anoArquivo = ano ?? dataArquivamento.year;
    final mesArquivo = mes ?? dataArquivamento.month;

    try {
      // Move arquivos do especialista para arquivo geral
      final arquivosMovidos = await _sincronizacaoService.arquivarArquivosMes(
        especialista: especialista,
        ano: anoArquivo,
        mes: mesArquivo,
      );

      // Gera relatório pós-arquivamento
      final relatorio = await _sincronizacaoService.gerarRelatorioArquivos(
        ano: anoArquivo,
        mes: mesArquivo,
      );

      return {
        'sucesso': true,
        'arquivos_movidos': arquivosMovidos.length,
        'especialista': especialista,
        'periodo': '$mesArquivo/$anoArquivo',
        'relatorio': relatorio,
      };

    } catch (e) {
      return {
        'sucesso': false,
        'erro': e.toString(),
        'especialista': especialista,
        'periodo': '$mesArquivo/$anoArquivo',
      };
    }
  }

  /// Obtém estatísticas do sistema de arquivos
  Future<Map<String, dynamic>> obterEstatisticasSistema() async {
    final agora = DateTime.now();
    
    // Estatísticas do cache
    final estatisticasCache = await _cacheService.obterEstatisticasCache();
    
    // Relatório do mês atual
    final relatorioAtual = await _sincronizacaoService.gerarRelatorioArquivos(
      ano: agora.year,
      mes: agora.month,
    );
    
    // Relatório do mês anterior
    final mesAnterior = agora.month == 1 ? 12 : agora.month - 1;
    final anoAnterior = agora.month == 1 ? agora.year - 1 : agora.year;
    final relatorioAnterior = await _sincronizacaoService.gerarRelatorioArquivos(
      ano: anoAnterior,
      mes: mesAnterior,
    );

    return {
      'cache': estatisticasCache,
      'mes_atual': relatorioAtual,
      'mes_anterior': relatorioAnterior,
      'data_consulta': agora.toIso8601String(),
    };
  }

  /// Limpa dados antigos do sistema
  Future<Map<String, dynamic>> limparDadosAntigos() async {
    try {
      // Limpa arquivos antigos (mais de 6 meses)
      final arquivosRemovidos = await _sincronizacaoService.limparArquivosAntigos();
      
      // Limpa rascunhos órfãos do cache
      await _cacheService.limparTodosRascunhos();

      return {
        'sucesso': true,
        'arquivos_removidos': arquivosRemovidos,
        'cache_limpo': true,
      };

    } catch (e) {
      return {
        'sucesso': false,
        'erro': e.toString(),
      };
    }
  }

  /// Define especialista atual
  Future<void> definirEspecialista(String nomeEspecialista) async {
    await _cacheService.definirEspecialista(nomeEspecialista);
  }

  /// Obtém especialista atual
  Future<String?> obterEspecialistaAtual() async {
    return await _cacheService.obterEspecialista();
  }
}
