import 'package:flutter/foundation.dart';
import '../services/directory_manager_service.dart';
import '../../data/datasources/local_datasource.dart';

/// Serviço de inicialização da aplicação
/// Responsável por configurar diretórios, banco de dados e estruturas iniciais
class AppInitializationService {
  static final AppInitializationService _instance =
      AppInitializationService._internal();

  factory AppInitializationService() => _instance;

  AppInitializationService._internal();

  /// Inicializa toda a estrutura da aplicação
  Future<void> initialize() async {
    try {
      // Inicializa a estrutura de diretórios
      await _initializeDirectories();

      // Inicializa o banco de dados
      await _initializeDatabase();

      // Limpa arquivos antigos se necessário
      await _cleanupOldFiles();
    } catch (e) {
      debugPrint('Erro durante inicialização: $e');
      rethrow;
    }
  }

  /// Inicializa todos os diretórios necessários
  Future<void> _initializeDirectories() async {
    final directoryManager = DirectoryManagerService();
    await directoryManager.initializeDirectoryStructure();
    debugPrint('✅ Estrutura de diretórios inicializada');
  }

  /// Inicializa o banco de dados
  Future<void> _initializeDatabase() async {
    final datasource = LocalDatasource();
    // Apenas acessa o database para forçar sua criação
    await datasource.database;
    debugPrint('✅ Banco de dados inicializado');
  }

  /// Limpa arquivos antigos se necessário
  Future<void> _cleanupOldFiles() async {
    try {
      final directoryManager = DirectoryManagerService();
      await directoryManager.cleanOldFiles();
      debugPrint('✅ Limpeza de arquivos antigos concluída');
    } catch (e) {
      // Não é crítico se a limpeza falhar
      debugPrint('⚠️ Aviso: Falha na limpeza de arquivos antigos: $e');
    }
  }

  /// Obtém informações sobre o estado da aplicação
  Future<Map<String, dynamic>> getAppStatus() async {
    final directoryManager = DirectoryManagerService();
    final storageInfo = await directoryManager.getStorageInfo();

    final datasource = LocalDatasource();
    final db = await datasource.database;
    final isDbOpen = db.isOpen;

    return {
      'databaseOpen': isDbOpen,
      'storageInfo': storageInfo,
      'version': '1.0.0',
      'initialized': true,
    };
  }

  /// Cria um backup completo dos dados
  Future<String> createBackup() async {
    final directoryManager = DirectoryManagerService();
    final backupFile = await directoryManager.createDatabaseBackup();
    return backupFile.path;
  }

  /// Obtém o caminho dos diretórios principais
  Future<Map<String, String>> getDirectoryPaths() async {
    final directoryManager = DirectoryManagerService();

    final appDir = await directoryManager.appDirectory;
    final fichasDir = await directoryManager.fichasDirectory;
    final pdfsDir = await directoryManager.pdfsDirectory;
    final backupsDir = await directoryManager.backupsDirectory;
    final exportsDir = await directoryManager.exportsDirectory;

    return {
      'app': appDir.path,
      'fichas': fichasDir.path,
      'pdfs': pdfsDir.path,
      'backups': backupsDir.path,
      'exports': exportsDir.path,
    };
  }

  /// Verifica se a aplicação foi inicializada corretamente
  Future<bool> isInitialized() async {
    try {
      final directoryManager = DirectoryManagerService();
      final appDir = await directoryManager.appDirectory;

      final datasource = LocalDatasource();
      final db = await datasource.database;

      return await appDir.exists() && db.isOpen;
    } catch (e) {
      return false;
    }
  }
}
