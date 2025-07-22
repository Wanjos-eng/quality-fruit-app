import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';

/// Estrutura para organização de arquivos por especialista e período
class EstruturaPasta {
  final String especialista;
  final int ano;
  final int mes;
  final String nomePasta;

  const EstruturaPasta({
    required this.especialista,
    required this.ano,
    required this.mes,
    required this.nomePasta,
  });

  /// Gera o caminho da pasta do especialista para o mês atual
  String get caminhoEspecialista => '$especialista/$ano/${_nomeDoMes(mes)}';
  
  /// Gera o caminho da pasta geral (arquivo)
  String get caminhoGeral => 'Arquivo_Geral/$ano/${_nomeDoMes(mes)}';

  String _nomeDoMes(int mes) {
    const meses = [
      '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return meses[mes];
  }
}

/// Serviço para gerenciar sincronização com Google Drive
/// Organiza arquivos por especialista e faz arquivamento automático
class SincronizacaoService {
  static const String _pastaRoot = 'QualityFruit_Dados';
  
  /// Salva ficha localmente com estrutura organizada
  Future<File> salvarFichaLocal(Ficha ficha, String especialista) async {
    final estrutura = EstruturaPasta(
      especialista: especialista,
      ano: ficha.dataAvaliacao.year,
      mes: ficha.dataAvaliacao.month,
      nomePasta: _pastaRoot,
    );

    // Cria diretório local se não existir
    final directory = await _criarDiretorioLocal(estrutura.caminhoEspecialista);
    
    // Nome do arquivo: FICHA_20250722_001.json
    final nomeArquivo = 'FICHA_${_formatarData(ficha.dataAvaliacao)}_${ficha.numeroFicha}.json';
    final file = File('${directory.path}/$nomeArquivo');

    // Converte ficha para JSON
    final fichaModel = FichaModel.fromEntity(ficha);
    final json = jsonEncode({
      'ficha': fichaModel.toJson(),
      'metadados': {
        'especialista': especialista,
        'versao_app': '1.0.0',
        'data_criacao': DateTime.now().toIso8601String(),
        'dispositivo': Platform.operatingSystem,
      }
    });

    // Salva arquivo
    await file.writeAsString(json);
    return file;
  }

  /// Salva dados completos (ficha + amostras + medidas + defeitos)
  Future<File> salvarDadosCompletos({
    required Ficha ficha,
    required List<Amostra> amostras,
    required List<Medida> medidas,
    required List<Defeito> defeitos,
    required String especialista,
  }) async {
    final estrutura = EstruturaPasta(
      especialista: especialista,
      ano: ficha.dataAvaliacao.year,
      mes: ficha.dataAvaliacao.month,
      nomePasta: _pastaRoot,
    );

    final directory = await _criarDiretorioLocal(estrutura.caminhoEspecialista);
    final nomeArquivo = 'COMPLETO_${_formatarData(ficha.dataAvaliacao)}_${ficha.numeroFicha}.json';
    final file = File('${directory.path}/$nomeArquivo');

    // Estrutura completa dos dados
    final dadosCompletos = {
      'ficha': FichaModel.fromEntity(ficha).toJson(),
      'amostras': amostras.map((a) => AmostraModel.fromEntity(a).toSqliteMap()).toList(),
      'medidas': medidas.map((m) => MedidaModel.fromEntity(m).toSqliteMap()).toList(),
      'defeitos': defeitos.map((d) => DefeitoModel.fromEntity(d).toSqliteMap()).toList(),
      'metadados': {
        'especialista': especialista,
        'total_amostras': amostras.length,
        'total_medidas': medidas.length,
        'total_defeitos': defeitos.length,
        'versao_app': '1.0.0',
        'data_criacao': DateTime.now().toIso8601String(),
        'dispositivo': Platform.operatingSystem,
      }
    };

    await file.writeAsString(jsonEncode(dadosCompletos));
    return file;
  }

  /// Lista arquivos do especialista para um período
  Future<List<File>> listarArquivosEspecialista({
    required String especialista,
    required int ano,
    required int mes,
  }) async {
    final estrutura = EstruturaPasta(
      especialista: especialista,
      ano: ano,
      mes: mes,
      nomePasta: _pastaRoot,
    );

    final directory = await _obterDiretorioLocal(estrutura.caminhoEspecialista);
    if (!await directory.exists()) return [];

    final files = await directory.list().where((entity) => entity is File).cast<File>().toList();
    return files;
  }

  /// Move arquivos do especialista para arquivo geral (final do mês)
  Future<List<File>> arquivarArquivosMes({
    required String especialista,
    required int ano,
    required int mes,
  }) async {
    final estruturaOrigem = EstruturaPasta(
      especialista: especialista,
      ano: ano,
      mes: mes,
      nomePasta: _pastaRoot,
    );

    final estruturaDestino = EstruturaPasta(
      especialista: 'Arquivo_Geral',
      ano: ano,
      mes: mes,
      nomePasta: _pastaRoot,
    );

    // Lista arquivos da pasta do especialista
    final arquivosOrigem = await listarArquivosEspecialista(
      especialista: especialista,
      ano: ano,
      mes: mes,
    );

    if (arquivosOrigem.isEmpty) return [];

    // Cria diretório de destino
    final diretorioDestino = await _criarDiretorioLocal(estruturaDestino.caminhoGeral);
    
    List<File> arquivosMovidos = [];

    for (final arquivo in arquivosOrigem) {
      // Nome do arquivo com prefixo do especialista
      final nomeOriginal = arquivo.path.split('/').last;
      final novoNome = '${especialista}_$nomeOriginal';
      final novoArquivo = File('${diretorioDestino.path}/$novoNome');

      // Copia arquivo
      await arquivo.copy(novoArquivo.path);
      arquivosMovidos.add(novoArquivo);

      // Remove arquivo original
      await arquivo.delete();
    }

    return arquivosMovidos;
  }

  /// Gera relatório de arquivos por período
  Future<Map<String, dynamic>> gerarRelatorioArquivos({
    required int ano,
    required int mes,
  }) async {
    final baseDir = await getApplicationDocumentsDirectory();
    final rootPath = '${baseDir.path}/$_pastaRoot';
    final rootDir = Directory(rootPath);

    if (!await rootDir.exists()) {
      return {
        'especialistas': {},
        'arquivo_geral': 0,
        'total_arquivos': 0,
      };
    }

    Map<String, int> especialistas = {};
    int arquivoGeral = 0;

    // Varre diretórios de especialistas
    await for (final entity in rootDir.list()) {
      if (entity is Directory) {
        final nome = entity.path.split('/').last;
        
        if (nome == 'Arquivo_Geral') {
          // Conta arquivos do arquivo geral
          final anoDir = Directory('${entity.path}/$ano');
          if (await anoDir.exists()) {
            final mesDir = Directory('${anoDir.path}/${_nomeDoMes(mes)}');
            if (await mesDir.exists()) {
              arquivoGeral = await mesDir.list().where((e) => e is File).length;
            }
          }
        } else {
          // Conta arquivos do especialista
          final anoDir = Directory('${entity.path}/$ano');
          if (await anoDir.exists()) {
            final mesDir = Directory('${anoDir.path}/${_nomeDoMes(mes)}');
            if (await mesDir.exists()) {
              especialistas[nome] = await mesDir.list().where((e) => e is File).length;
            }
          }
        }
      }
    }

    final totalArquivos = especialistas.values.fold(0, (sum, count) => sum + count) + arquivoGeral;

    return {
      'especialistas': especialistas,
      'arquivo_geral': arquivoGeral,
      'total_arquivos': totalArquivos,
      'ano': ano,
      'mes': mes,
    };
  }

  /// Cria diretório local se não existir
  Future<Directory> _criarDiretorioLocal(String caminho) async {
    final baseDir = await getApplicationDocumentsDirectory();
    final directory = Directory('${baseDir.path}/$_pastaRoot/$caminho');
    
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    return directory;
  }

  /// Obtém diretório local
  Future<Directory> _obterDiretorioLocal(String caminho) async {
    final baseDir = await getApplicationDocumentsDirectory();
    return Directory('${baseDir.path}/$_pastaRoot/$caminho');
  }

  /// Formata data para nome de arquivo
  String _formatarData(DateTime data) {
    return '${data.year}${data.month.toString().padLeft(2, '0')}${data.day.toString().padLeft(2, '0')}';
  }

  /// Nome do mês por extenso
  String _nomeDoMes(int mes) {
    const meses = [
      '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return meses[mes];
  }

  /// Limpa arquivos antigos (mais de 6 meses)
  Future<int> limparArquivosAntigos() async {
    final dataLimite = DateTime.now().subtract(const Duration(days: 180));
    final baseDir = await getApplicationDocumentsDirectory();
    final rootDir = Directory('${baseDir.path}/$_pastaRoot');
    
    if (!await rootDir.exists()) return 0;

    int arquivosRemovidos = 0;
    
    await for (final entity in rootDir.list(recursive: true)) {
      if (entity is File) {
        final stat = await entity.stat();
        if (stat.modified.isBefore(dataLimite)) {
          await entity.delete();
          arquivosRemovidos++;
        }
      }
    }

    return arquivosRemovidos;
  }
}
