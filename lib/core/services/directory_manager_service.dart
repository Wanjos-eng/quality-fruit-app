import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Serviço para gerenciar diretórios e estrutura de arquivos do app
class DirectoryManagerService {
  static const String _appFolderName = 'QualityFruitApp';
  static const String _fichasFolderName = 'fichas';
  static const String _pdfsFolderName = 'pdfs';
  static const String _backupFolderName = 'backups';
  static const String _exportsFolderName = 'exports';

  /// Obtém o diretório raiz do aplicativo
  Future<Directory> get appDirectory async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final appDir = Directory(path.join(documentsDir.path, _appFolderName));

    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }

    return appDir;
  }

  /// Obtém o diretório para salvar fichas
  Future<Directory> get fichasDirectory async {
    final appDir = await appDirectory;
    final fichasDir = Directory(path.join(appDir.path, _fichasFolderName));

    if (!await fichasDir.exists()) {
      await fichasDir.create(recursive: true);
    }

    return fichasDir;
  }

  /// Obtém o diretório para salvar PDFs
  Future<Directory> get pdfsDirectory async {
    final appDir = await appDirectory;
    final pdfsDir = Directory(path.join(appDir.path, _pdfsFolderName));

    if (!await pdfsDir.exists()) {
      await pdfsDir.create(recursive: true);
    }

    return pdfsDir;
  }

  /// Obtém o diretório para backups
  Future<Directory> get backupsDirectory async {
    final appDir = await appDirectory;
    final backupsDir = Directory(path.join(appDir.path, _backupFolderName));

    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }

    return backupsDir;
  }

  /// Obtém o diretório para exports
  Future<Directory> get exportsDirectory async {
    final appDir = await appDirectory;
    final exportsDir = Directory(path.join(appDir.path, _exportsFolderName));

    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }

    return exportsDir;
  }

  /// Inicializa toda a estrutura de diretórios
  Future<void> initializeDirectoryStructure() async {
    await Future.wait([
      appDirectory,
      fichasDirectory,
      pdfsDirectory,
      backupsDirectory,
      exportsDirectory,
    ]);
  }

  /// Obtém o caminho do banco de dados
  Future<String> get databasePath async {
    final appDir = await appDirectory;
    return path.join(appDir.path, 'quality_fruit.db');
  }

  /// Lista todos os arquivos PDF salvos
  Future<List<File>> listPdfFiles() async {
    final pdfsDir = await pdfsDirectory;
    final files = pdfsDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.pdf'))
        .toList();

    // Ordena por data de modificação (mais recentes primeiro)
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return files;
  }

  /// Lista todos os arquivos de backup
  Future<List<File>> listBackupFiles() async {
    final backupsDir = await backupsDirectory;
    final files = backupsDir
        .listSync()
        .whereType<File>()
        .where(
          (file) => file.path.endsWith('.db') || file.path.endsWith('.json'),
        )
        .toList();

    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return files;
  }

  /// Cria um arquivo de backup do banco de dados
  Future<File> createDatabaseBackup() async {
    final dbPath = await databasePath;
    final dbFile = File(dbPath);

    if (!await dbFile.exists()) {
      throw Exception('Banco de dados não encontrado');
    }

    final backupsDir = await backupsDirectory;
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupPath = path.join(backupsDir.path, 'backup_$timestamp.db');

    return await dbFile.copy(backupPath);
  }

  /// Calcula o tamanho total dos arquivos do app
  Future<int> getTotalAppSize() async {
    final appDir = await appDirectory;
    int totalSize = 0;

    await for (final entity in appDir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }

    return totalSize;
  }

  /// Limpa arquivos antigos (mais de 30 dias)
  Future<void> cleanOldFiles() async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

    // Limpa backups antigos
    final backupsDir = await backupsDirectory;
    await for (final entity in backupsDir.list()) {
      if (entity is File) {
        final lastModified = await entity.lastModified();
        if (lastModified.isBefore(cutoffDate)) {
          await entity.delete();
        }
      }
    }
  }

  /// Obtém informações sobre o espaço usado
  Future<Map<String, dynamic>> getStorageInfo() async {
    final appDir = await appDirectory;
    final pdfsDir = await pdfsDirectory;
    final backupsDir = await backupsDirectory;

    int totalSize = 0;
    int pdfsSize = 0;
    int backupsSize = 0;
    int dbSize = 0;

    // Tamanho do banco de dados
    final dbPath = await databasePath;
    final dbFile = File(dbPath);
    if (await dbFile.exists()) {
      dbSize = await dbFile.length();
    }

    // Tamanho dos PDFs
    await for (final entity in pdfsDir.list()) {
      if (entity is File) {
        pdfsSize += await entity.length();
      }
    }

    // Tamanho dos backups
    await for (final entity in backupsDir.list()) {
      if (entity is File) {
        backupsSize += await entity.length();
      }
    }

    totalSize = dbSize + pdfsSize + backupsSize;

    return {
      'totalSize': totalSize,
      'databaseSize': dbSize,
      'pdfsSize': pdfsSize,
      'backupsSize': backupsSize,
      'appPath': appDir.path,
    };
  }
}
