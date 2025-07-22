import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Datasource local para gerenciar o banco de dados SQLite
class LocalDatasource {
  static const _databaseName = 'quality_fruit.db';
  static const _databaseVersion = 4;

  // Tabelas
  static const _tableFichas = 'fichas';
  static const _tableAmostras = 'amostras';
  static const _tableAmostrasDetalhadas = 'amostras_detalhadas';
  static const _tableMedidas = 'medidas';
  static const _tableDefeitos = 'defeitos';

  static Database? _database;

  /// Retorna a instância do banco de dados (Singleton)
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Cria as tabelas do banco de dados
  Future<void> _onCreate(Database db, int version) async {
    // Tabela Fichas
    await db.execute('''
      CREATE TABLE $_tableFichas (
        id TEXT PRIMARY KEY,
        numero_ficha TEXT UNIQUE NOT NULL,
        data_avaliacao TEXT NOT NULL,
        cliente TEXT NOT NULL,
        fazenda TEXT NOT NULL,
        ano INTEGER NOT NULL,
        produto TEXT NOT NULL,
        variedade TEXT NOT NULL,
        origem TEXT NOT NULL,
        lote TEXT NOT NULL,
        peso_total REAL NOT NULL,
        quantidade_amostras INTEGER NOT NULL,
        responsavel_avaliacao TEXT NOT NULL,
        produtor_responsavel TEXT,
        observacoes TEXT,
        observacao_a TEXT,
        observacao_b TEXT,
        observacao_c TEXT,
        observacao_d TEXT,
        observacao_f TEXT,
        observacao_g TEXT,
        criado_em TEXT NOT NULL,
        atualizado_em TEXT
      )
    ''');

    // Tabela Amostras
    await db.execute('''
      CREATE TABLE $_tableAmostras (
        id TEXT PRIMARY KEY,
        ficha_id TEXT NOT NULL,
        numero_amostra INTEGER NOT NULL,
        peso REAL NOT NULL,
        observacoes TEXT,
        criado_em TEXT NOT NULL,
        atualizado_em TEXT,
        FOREIGN KEY (ficha_id) REFERENCES $_tableFichas (id) ON DELETE CASCADE,
        UNIQUE(ficha_id, numero_amostra)
      )
    ''');

    // Tabela Medidas
    await db.execute('''
      CREATE TABLE $_tableMedidas (
        id TEXT PRIMARY KEY,
        amostra_id TEXT NOT NULL,
        tipo TEXT NOT NULL,
        valor REAL NOT NULL,
        observacoes TEXT,
        criado_em TEXT NOT NULL,
        atualizado_em TEXT,
        FOREIGN KEY (amostra_id) REFERENCES $_tableAmostras (id) ON DELETE CASCADE
      )
    ''');

    // Tabela Defeitos
    await db.execute('''
      CREATE TABLE $_tableDefeitos (
        id TEXT PRIMARY KEY,
        amostra_id TEXT NOT NULL,
        tipo TEXT NOT NULL,
        gravidade TEXT NOT NULL,
        descricao TEXT NOT NULL,
        porcentagem_afetada REAL,
        observacoes TEXT,
        criado_em TEXT NOT NULL,
        atualizado_em TEXT,
        FOREIGN KEY (amostra_id) REFERENCES $_tableAmostras (id) ON DELETE CASCADE
      )
    ''');

    // Tabela Amostras Detalhadas (planilha física)
    await db.execute('''
      CREATE TABLE $_tableAmostrasDetalhadas (
        id TEXT PRIMARY KEY,
        ficha_id TEXT NOT NULL,
        letra_amostra TEXT NOT NULL,
        data TEXT,
        caixa_marca TEXT,
        classe TEXT,
        area TEXT,
        variedade TEXT,
        peso_bruto_kg REAL,
        sacola_cumbuca TEXT,
        caixa_cumbuca_alta TEXT,
        aparencia_calibro_0a7 TEXT,
        cor_umd TEXT,
        peso_embalagem REAL,
        peso_liquido_kg REAL,
        baga_mm REAL,
        brix REAL,
        brix_media REAL,
        teia_aranha REAL,
        aranha REAL,
        amassada REAL,
        aquosa_cor_baga REAL,
        cacho_duro REAL,
        cacho_ralo_banguelo REAL,
        cicatriz REAL,
        corpo_estranho REAL,
        desgrane_percentual REAL,
        mosca_fruta REAL,
        murcha REAL,
        oidio REAL,
        podre REAL,
        queimado_sol REAL,
        rachada REAL,
        sacarose REAL,
        translucido REAL,
        glomerella REAL,
        traca REAL,
        observacoes TEXT,
        criado_em TEXT NOT NULL,
        atualizado_em TEXT,
        FOREIGN KEY (ficha_id) REFERENCES $_tableFichas (id) ON DELETE CASCADE,
        UNIQUE(ficha_id, letra_amostra)
      )
    ''');

    // Índices para melhor performance
    await db.execute(
      'CREATE INDEX idx_fichas_cliente ON $_tableFichas (cliente)',
    );
    await db.execute(
      'CREATE INDEX idx_fichas_produto ON $_tableFichas (produto)',
    );
    await db.execute(
      'CREATE INDEX idx_fichas_data ON $_tableFichas (data_avaliacao)',
    );
    await db.execute(
      'CREATE INDEX idx_amostras_ficha ON $_tableAmostras (ficha_id)',
    );
    await db.execute(
      'CREATE INDEX idx_medidas_amostra ON $_tableMedidas (amostra_id)',
    );
    await db.execute('CREATE INDEX idx_medidas_tipo ON $_tableMedidas (tipo)');
    await db.execute(
      'CREATE INDEX idx_defeitos_amostra ON $_tableDefeitos (amostra_id)',
    );
    await db.execute(
      'CREATE INDEX idx_defeitos_tipo ON $_tableDefeitos (tipo)',
    );
  }

  /// Atualiza o esquema do banco de dados
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migração da versão 1 para 2: adicionar coluna fazenda
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN fazenda TEXT NOT NULL DEFAULT ""',
      );
    }

    // Migração da versão 2 para 3: adicionar novos campos da planilha física
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN ano INTEGER NOT NULL DEFAULT ${DateTime.now().year}',
      );
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN produtor_responsavel TEXT',
      );
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN observacao_a TEXT',
      );
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN observacao_b TEXT',
      );
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN observacao_c TEXT',
      );
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN observacao_d TEXT',
      );
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN observacao_f TEXT',
      );
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN observacao_g TEXT',
      );
    }

    // Migração da versão 3 para 4: adicionar tabela de amostras detalhadas
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE $_tableAmostrasDetalhadas (
          id TEXT PRIMARY KEY,
          ficha_id TEXT NOT NULL,
          letra_amostra TEXT NOT NULL,
          data TEXT,
          caixa_marca TEXT,
          classe TEXT,
          area TEXT,
          variedade TEXT,
          peso_bruto_kg REAL,
          sacola_cumbuca TEXT,
          caixa_cumbuca_alta TEXT,
          aparencia_calibro_0a7 TEXT,
          cor_umd TEXT,
          peso_embalagem REAL,
          peso_liquido_kg REAL,
          baga_mm REAL,
          brix REAL,
          brix_media REAL,
          teia_aranha REAL,
          aranha REAL,
          amassada REAL,
          aquosa_cor_baga REAL,
          cacho_duro REAL,
          cacho_ralo_banguelo REAL,
          cicatriz REAL,
          corpo_estranho REAL,
          desgrane_percentual REAL,
          mosca_fruta REAL,
          murcha REAL,
          oidio REAL,
          podre REAL,
          queimado_sol REAL,
          rachada REAL,
          sacarose REAL,
          translucido REAL,
          glomerella REAL,
          traca REAL,
          observacoes TEXT,
          criado_em TEXT NOT NULL,
          atualizado_em TEXT,
          FOREIGN KEY (ficha_id) REFERENCES $_tableFichas (id) ON DELETE CASCADE,
          UNIQUE(ficha_id, letra_amostra)
        )
      ''');

      await db.execute(
        'CREATE INDEX idx_amostras_detalhadas_ficha ON $_tableAmostrasDetalhadas (ficha_id)',
      );
      await db.execute(
        'CREATE INDEX idx_amostras_detalhadas_letra ON $_tableAmostrasDetalhadas (letra_amostra)',
      );
    }
  }

  /// Fecha a conexão com o banco de dados
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Limpa todos os dados do banco (apenas para desenvolvimento/testes)
  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(_tableDefeitos);
      await txn.delete(_tableMedidas);
      await txn.delete(_tableAmostras);
      await txn.delete(_tableFichas);
    });
  }

  // === OPERAÇÕES GENÉRICAS ===

  /// Insere um registro em uma tabela
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  /// Atualiza registros em uma tabela
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  /// Deleta registros de uma tabela
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// Consulta registros de uma tabela
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Executa uma consulta SQL raw
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  /// Executa um comando SQL raw
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawDelete(sql, arguments);
  }

  /// Executa uma transação
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction(action);
  }

  // === GETTERS PARA NOMES DAS TABELAS ===

  String get tableFichas => _tableFichas;
  String get tableAmostras => _tableAmostras;
  String get tableAmostrasDetalhadas => _tableAmostrasDetalhadas;
  String get tableMedidas => _tableMedidas;
  String get tableDefeitos => _tableDefeitos;
}
