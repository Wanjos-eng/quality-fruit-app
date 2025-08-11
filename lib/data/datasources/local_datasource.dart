import 'package:sqflite/sqflite.dart';
import '../../core/services/directory_manager_service.dart';
import '../../domain/entities/entities.dart';

/// Datasource local para gerenciar o banco de dados SQLite
class LocalDatasource {
  static const _databaseVersion =
      7; // Incrementado para adicionar novos campos SEÇÃO 2

  // Tabelas
  static const _tableFichas = 'fichas';
  static const _tableAmostras = 'amostras';
  static const _tableAmostrasDetalhadas = 'amostras_detalhadas';
  static const _tableMedidas = 'medidas';
  static const _tableDefeitos = 'defeitos';

  static Database? _database;

  /// Método para resetar completamente a base de dados (útil durante desenvolvimento)
  Future<void> resetDatabase() async {
    await _database?.close();
    _database = null;

    final directoryManager = DirectoryManagerService();
    final dbPath = await directoryManager.databasePath;
    await deleteDatabase(dbPath);
  }

  /// Retorna a instância do banco de dados (Singleton)
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    // Usa o DirectoryManagerService para obter o caminho correto
    final directoryManager = DirectoryManagerService();
    final dbPath = await directoryManager.databasePath;

    return await openDatabase(
      dbPath,
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
        numeroFicha TEXT UNIQUE NOT NULL,
        dataAvaliacao INTEGER NOT NULL,
        cliente TEXT NOT NULL,
        fazenda TEXT NOT NULL,
        ano INTEGER NOT NULL,
        produto TEXT NOT NULL,
        variedade TEXT NOT NULL,
        origem TEXT NOT NULL,
        lote TEXT NOT NULL,
        pesoTotal REAL NOT NULL,
        quantidadeAmostras INTEGER NOT NULL,
        responsavelAvaliacao TEXT NOT NULL,
        produtorResponsavel TEXT,
        semanaAno INTEGER, -- Novo campo: Semana/Ano (calculado automaticamente)
        inspetor TEXT, -- Novo campo: Inspetor
        tipoAmostragem TEXT, -- Novo campo: Tipo de Amostragem
        pesoBrutoKg REAL, -- Novo campo: Peso Bruto (Kg)
        observacoes TEXT,
        observacaoA TEXT,
        observacaoB TEXT,
        observacaoC TEXT,
        observacaoD TEXT,
        observacaoF TEXT,
        observacaoG TEXT,
        criadoEm INTEGER NOT NULL,
        atualizadoEm INTEGER
      )
    ''');

    // Tabela Amostras
    await db.execute('''
      CREATE TABLE $_tableAmostras (
        id TEXT PRIMARY KEY,
        fichaId TEXT NOT NULL,
        numeroAmostra INTEGER NOT NULL,
        peso REAL NOT NULL,
        observacoes TEXT,
        criadoEm TEXT NOT NULL,
        atualizadoEm TEXT,
        FOREIGN KEY (fichaId) REFERENCES $_tableFichas (id) ON DELETE CASCADE,
        UNIQUE(fichaId, numeroAmostra)
      )
    ''');

    // Tabela Medidas
    await db.execute('''
      CREATE TABLE $_tableMedidas (
        id TEXT PRIMARY KEY,
        amostraId TEXT NOT NULL,
        tipo TEXT NOT NULL,
        valor REAL NOT NULL,
        observacoes TEXT,
        criadoEm TEXT NOT NULL,
        atualizadoEm TEXT,
        FOREIGN KEY (amostraId) REFERENCES $_tableAmostras (id) ON DELETE CASCADE
      )
    ''');

    // Tabela Defeitos
    await db.execute('''
      CREATE TABLE $_tableDefeitos (
        id TEXT PRIMARY KEY,
        amostraId TEXT NOT NULL,
        tipo TEXT NOT NULL,
        gravidade TEXT NOT NULL,
        descricao TEXT NOT NULL,
        porcentagemAfetada REAL,
        observacoes TEXT,
        criadoEm TEXT NOT NULL,
        atualizadoEm TEXT,
        FOREIGN KEY (amostraId) REFERENCES $_tableAmostras (id) ON DELETE CASCADE
      )
    ''');

    // Tabela Amostras Detalhadas (planilha física)
    await db.execute('''
      CREATE TABLE $_tableAmostrasDetalhadas (
        id TEXT PRIMARY KEY,
        fichaId TEXT NOT NULL,
        letraAmostra TEXT NOT NULL,
        data TEXT,
        caixaMarca TEXT,
        classe TEXT,
        area TEXT,
        variedade TEXT,
        pesoBrutoKg REAL,
        sacolaCumbuca TEXT,
        caixaCumbucaAlta TEXT,
        aparenciaCalibre0a7 TEXT,
        corUmd TEXT,
        pesoEmbalagem REAL,
        pesoLiquidoKg REAL,
        bagaMm REAL,
        brix_leituras TEXT, -- Armazena como string separada por vírgulas
        brix REAL,
        brixMedia REAL,
        cor_baga_percentual REAL, -- Novo campo: Cor da Baga (%)
        teiaAranha REAL,
        aranha REAL,
        amassada REAL,
        aquosaCorBaga REAL,
        cachoDuro REAL,
        cachoRaloBanguelo REAL,
        cicatriz REAL,
        corpoEstranho REAL,
        desgranePercentual REAL,
        moscaFruta REAL,
        murcha REAL,
        oidio REAL,
        podre REAL,
        queimadoSol REAL,
        rachada REAL,
        sacarose REAL,
        translucido REAL,
        glomerella REAL,
        traca REAL,
        observacoes TEXT,
        criadoEm TEXT NOT NULL,
        atualizadoEm TEXT,
        FOREIGN KEY (fichaId) REFERENCES $_tableFichas (id) ON DELETE CASCADE,
        UNIQUE(fichaId, letraAmostra)
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
      'CREATE INDEX idx_fichas_data ON $_tableFichas (dataAvaliacao)',
    );
    await db.execute(
      'CREATE INDEX idx_amostras_ficha ON $_tableAmostras (fichaId)',
    );
    await db.execute(
      'CREATE INDEX idx_medidas_amostra ON $_tableMedidas (amostraId)',
    );
    await db.execute('CREATE INDEX idx_medidas_tipo ON $_tableMedidas (tipo)');
    await db.execute(
      'CREATE INDEX idx_defeitos_amostra ON $_tableDefeitos (amostraId)',
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
        'CREATE INDEX idx_amostras_detalhadas_ficha ON $_tableAmostrasDetalhadas (fichaId)',
      );
      await db.execute(
        'CREATE INDEX idx_amostras_detalhadas_letra ON $_tableAmostrasDetalhadas (letraAmostra)',
      );
    }

    // Migração da versão 4 para 5: corrigir nomes das colunas para camelCase
    if (oldVersion < 5) {
      // Recriar tabela fichas com nomes corretos das colunas
      await db.execute('DROP TABLE IF EXISTS ${_tableFichas}_backup');

      // Criar tabela backup (se existir dados)
      try {
        await db.execute('''
          CREATE TABLE ${_tableFichas}_backup AS 
          SELECT * FROM $_tableFichas
        ''');
      } catch (e) {
        // Tabela pode não existir ainda
      }

      // Remover tabela original
      await db.execute('DROP TABLE IF EXISTS $_tableFichas');

      // Recriar tabela com schema correto (camelCase para compatibilidade com modelo)
      await db.execute('''
        CREATE TABLE $_tableFichas (
          id TEXT PRIMARY KEY,
          numeroFicha TEXT UNIQUE NOT NULL,
          dataAvaliacao INTEGER NOT NULL,
          cliente TEXT NOT NULL,
          fazenda TEXT NOT NULL,
          ano INTEGER NOT NULL,
          produto TEXT NOT NULL,
          variedade TEXT NOT NULL,
          origem TEXT NOT NULL,
          lote TEXT NOT NULL,
          pesoTotal REAL NOT NULL,
          quantidadeAmostras INTEGER NOT NULL,
          responsavelAvaliacao TEXT NOT NULL,
          produtorResponsavel TEXT,
          observacoes TEXT,
          observacaoA TEXT,
          observacaoB TEXT,
          observacaoC TEXT,
          observacaoD TEXT,
          observacaoF TEXT,
          observacaoG TEXT,
          criadoEm INTEGER NOT NULL,
          atualizadoEm INTEGER
        )
      ''');

      // Remover tabela backup
      await db.execute('DROP TABLE IF EXISTS ${_tableFichas}_backup');
    }

    // Migração da versão 5 para 6: recriar todas as tabelas com camelCase consistente
    if (oldVersion < 6) {
      // Fazer backup de todas as tabelas
      await db.execute(
        'DROP TABLE IF EXISTS ${_tableAmostrasDetalhadas}_backup',
      );
      await db.execute('DROP TABLE IF EXISTS ${_tableDefeitos}_backup');
      await db.execute('DROP TABLE IF EXISTS ${_tableMedidas}_backup');
      await db.execute('DROP TABLE IF EXISTS ${_tableAmostras}_backup');

      // Backup das tabelas existentes (se existirem)
      try {
        await db.execute(
          'CREATE TABLE ${_tableAmostrasDetalhadas}_backup AS SELECT * FROM $_tableAmostrasDetalhadas',
        );
        await db.execute(
          'CREATE TABLE ${_tableDefeitos}_backup AS SELECT * FROM $_tableDefeitos',
        );
        await db.execute(
          'CREATE TABLE ${_tableMedidas}_backup AS SELECT * FROM $_tableMedidas',
        );
        await db.execute(
          'CREATE TABLE ${_tableAmostras}_backup AS SELECT * FROM $_tableAmostras',
        );
      } catch (e) {
        // Tabelas podem não existir ainda
      }

      // Remover tabelas antigas
      await db.execute('DROP TABLE IF EXISTS $_tableDefeitos');
      await db.execute('DROP TABLE IF EXISTS $_tableMedidas');
      await db.execute('DROP TABLE IF EXISTS $_tableAmostras');
      await db.execute('DROP TABLE IF EXISTS $_tableAmostrasDetalhadas');

      // Recriar todas as tabelas com camelCase correto (chamando _onCreate)
      await _onCreate(db, 6);

      // Remover backups
      await db.execute(
        'DROP TABLE IF EXISTS ${_tableAmostrasDetalhadas}_backup',
      );
      await db.execute('DROP TABLE IF EXISTS ${_tableDefeitos}_backup');
      await db.execute('DROP TABLE IF EXISTS ${_tableMedidas}_backup');
      await db.execute('DROP TABLE IF EXISTS ${_tableAmostras}_backup');
    }

    // Migração da versão 6 para 7: adicionar novos campos SEÇÃO 1 e SEÇÃO 2
    if (oldVersion < 7) {
      // SEÇÃO 1: Adicionar novos campos na tabela fichas
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN semanaAno INTEGER',
      );
      await db.execute('ALTER TABLE $_tableFichas ADD COLUMN inspetor TEXT');
      await db.execute(
        'ALTER TABLE $_tableFichas ADD COLUMN tipoAmostragem TEXT',
      );
      await db.execute('ALTER TABLE $_tableFichas ADD COLUMN pesoBrutoKg REAL');

      // SEÇÃO 2: Adicionar novos campos na tabela amostras_detalhadas
      await db.execute(
        'ALTER TABLE $_tableAmostrasDetalhadas ADD COLUMN brix_leituras TEXT',
      );
      await db.execute(
        'ALTER TABLE $_tableAmostrasDetalhadas ADD COLUMN cor_baga_percentual REAL',
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

  // === MÉTODOS CRUD PARA AMOSTRAS DETALHADAS ===

  /// Salva uma amostra detalhada no banco
  Future<void> salvarAmostraDetalhada(AmostraDetalhada amostra) async {
    final db = await database;

    // Converte as listas para JSON strings
    final pesoBrutoLeiturasJson = amostra.pesoBrutoLeituras?.join(',');
    final brixLeiturasJson = amostra.brixLeituras?.join(',');

    await db.insert(_tableAmostrasDetalhadas, {
      'id': amostra.id,
      'fichaId': amostra.fichaId,
      'letraAmostra': amostra.letraAmostra,
      'data': amostra.data?.toIso8601String(),
      'caixaMarca': amostra.caixaMarca,
      'classe': amostra.classe,
      'area': amostra.area,
      'variedade': amostra.variedade,
      'sacolaCumbuca': amostra.sacolaCumbuca,
      'caixaCumbucaAlta': amostra.caixaCumbucaAlta,
      'aparenciaCalibro0a7': amostra.aparenciaCalibro0a7,
      'embalagemCalibro0a7': amostra.embalagemCalibro0a7,
      'corUMD': amostra.corUMD,
      'pesoEmbalagem': amostra.pesoEmbalagem,
      'bagaMm': amostra.bagaMm,
      'peso_bruto_leituras': pesoBrutoLeiturasJson,
      'peso_bruto_media': amostra.pesoBrutoMedia,
      'peso_liquido': amostra.pesoLiquido,
      'brix_leituras': brixLeiturasJson,
      'brix_media': amostra.brixMedia,
      'pesoBrutoKg': amostra.pesoBrutoKg,
      'pesoLiquidoKg': amostra.pesoLiquidoKg,
      'brix': amostra.brix,
      'teiaAranha': amostra.teiaAranha,
      'aranha': amostra.aranha,
      'amassada': amostra.amassada,
      'aquosaCorBaga': amostra.aquosaCorBaga,
      'cor_baga_percentual': amostra.corBagaPercentual,
      'cachoDuro': amostra.cachoDuro,
      'cachoRaloBanguelo': amostra.cachoRaloBanguelo,
      'cicatriz': amostra.cicatriz,
      'corpoEstranho': amostra.corpoEstranho,
      'desgranePercentual': amostra.desgranePercentual,
      'glomerella': amostra.glomerella,
      'lagarta': amostra.lagarta,
      'moscaFruta': amostra.moscaFruta,
      'murcha': amostra.murcha,
      'oidio': amostra.oidio,
      'podre': amostra.podre,
      'queimadoSol': amostra.queimadoSol,
      'rachada': amostra.rachada,
      'sacarose': amostra.sacarose,
      'translucido': amostra.translucido,
      'traca': amostra.traca,
      'observacoes': amostra.observacoes,
      'criadoEm': amostra.criadoEm.toIso8601String(),
      'atualizadoEm': amostra.atualizadoEm?.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Busca todas as amostras detalhadas de uma ficha
  Future<List<AmostraDetalhada>> buscarAmostrasDetalhadasPorFicha(
    String fichaId,
  ) async {
    final db = await database;

    final maps = await db.query(
      _tableAmostrasDetalhadas,
      where: 'fichaId = ?',
      whereArgs: [fichaId],
      orderBy: 'letraAmostra ASC',
    );

    return maps.map((map) => _mapToAmostraDetalhada(map)).toList();
  }

  /// Busca uma amostra detalhada específica
  Future<AmostraDetalhada?> buscarAmostraDetalhada(String id) async {
    final db = await database;

    final maps = await db.query(
      _tableAmostrasDetalhadas,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return _mapToAmostraDetalhada(maps.first);
    }
    return null;
  }

  /// Atualiza uma amostra detalhada
  Future<void> atualizarAmostraDetalhada(AmostraDetalhada amostra) async {
    final db = await database;

    final pesoBrutoLeiturasJson = amostra.pesoBrutoLeituras?.join(',');
    final brixLeiturasJson = amostra.brixLeituras?.join(',');

    await db.update(
      _tableAmostrasDetalhadas,
      {
        'data': amostra.data?.toIso8601String(),
        'caixaMarca': amostra.caixaMarca,
        'classe': amostra.classe,
        'area': amostra.area,
        'variedade': amostra.variedade,
        'sacolaCumbuca': amostra.sacolaCumbuca,
        'caixaCumbucaAlta': amostra.caixaCumbucaAlta,
        'aparenciaCalibro0a7': amostra.aparenciaCalibro0a7,
        'embalagemCalibro0a7': amostra.embalagemCalibro0a7,
        'corUMD': amostra.corUMD,
        'pesoEmbalagem': amostra.pesoEmbalagem,
        'bagaMm': amostra.bagaMm,
        'peso_bruto_leituras': pesoBrutoLeiturasJson,
        'peso_bruto_media': amostra.pesoBrutoMedia,
        'peso_liquido': amostra.pesoLiquido,
        'brix_leituras': brixLeiturasJson,
        'brix_media': amostra.brixMedia,
        'pesoBrutoKg': amostra.pesoBrutoKg,
        'pesoLiquidoKg': amostra.pesoLiquidoKg,
        'brix': amostra.brix,
        'teiaAranha': amostra.teiaAranha,
        'aranha': amostra.aranha,
        'amassada': amostra.amassada,
        'aquosaCorBaga': amostra.aquosaCorBaga,
        'cor_baga_percentual': amostra.corBagaPercentual,
        'cachoDuro': amostra.cachoDuro,
        'cachoRaloBanguelo': amostra.cachoRaloBanguelo,
        'cicatriz': amostra.cicatriz,
        'corpoEstranho': amostra.corpoEstranho,
        'desgranePercentual': amostra.desgranePercentual,
        'glomerella': amostra.glomerella,
        'lagarta': amostra.lagarta,
        'moscaFruta': amostra.moscaFruta,
        'murcha': amostra.murcha,
        'oidio': amostra.oidio,
        'podre': amostra.podre,
        'queimadoSol': amostra.queimadoSol,
        'rachada': amostra.rachada,
        'sacarose': amostra.sacarose,
        'translucido': amostra.translucido,
        'traca': amostra.traca,
        'observacoes': amostra.observacoes,
        'atualizadoEm': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [amostra.id],
    );
  }

  /// Exclui uma amostra detalhada
  Future<void> excluirAmostraDetalhada(String id) async {
    final db = await database;
    await db.delete(_tableAmostrasDetalhadas, where: 'id = ?', whereArgs: [id]);
  }

  /// Lista todas as amostras detalhadas
  Future<List<AmostraDetalhada>> listarTodasAmostrasDetalhadas() async {
    final db = await database;

    final maps = await db.query(
      _tableAmostrasDetalhadas,
      orderBy: 'fichaId ASC, letraAmostra ASC',
    );

    return maps.map((map) => _mapToAmostraDetalhada(map)).toList();
  }

  /// Converte um Map do banco para AmostraDetalhada
  AmostraDetalhada _mapToAmostraDetalhada(Map<String, dynamic> map) {
    // Converte strings de volta para listas
    List<double>? pesoBrutoLeituras;
    if (map['peso_bruto_leituras'] != null) {
      pesoBrutoLeituras = (map['peso_bruto_leituras'] as String)
          .split(',')
          .map((e) => double.tryParse(e.trim()) ?? 0.0)
          .toList();
    }

    List<double>? brixLeituras;
    if (map['brix_leituras'] != null) {
      brixLeituras = (map['brix_leituras'] as String)
          .split(',')
          .map((e) => double.tryParse(e.trim()) ?? 0.0)
          .toList();
    }

    return AmostraDetalhada(
      id: map['id'] as String,
      fichaId: map['fichaId'] as String,
      letraAmostra: map['letraAmostra'] as String,
      criadoEm: DateTime.parse(map['criadoEm'] as String),
      data: map['data'] != null ? DateTime.parse(map['data'] as String) : null,
      caixaMarca: map['caixaMarca'] as String?,
      classe: map['classe'] as String?,
      area: map['area'] as String?,
      variedade: map['variedade'] as String?,
      sacolaCumbuca: map['sacolaCumbuca'] as String?,
      caixaCumbucaAlta: map['caixaCumbucaAlta'] as String?,
      aparenciaCalibro0a7: map['aparenciaCalibro0a7'] as String?,
      embalagemCalibro0a7: map['embalagemCalibro0a7'] as String?,
      corUMD: map['corUMD'] as String?,
      pesoEmbalagem: map['pesoEmbalagem'] as double?,
      bagaMm: map['bagaMm'] as double?,
      pesoBrutoLeituras: pesoBrutoLeituras,
      pesoBrutoMedia: map['peso_bruto_media'] as double?,
      pesoLiquido: map['peso_liquido'] as double?,
      brixLeituras: brixLeituras,
      brixMedia: map['brix_media'] as double?,
      pesoBrutoKg: map['pesoBrutoKg'] as double?,
      pesoLiquidoKg: map['pesoLiquidoKg'] as double?,
      brix: map['brix'] as double?,
      teiaAranha: map['teiaAranha'] as double?,
      aranha: map['aranha'] as double?,
      amassada: map['amassada'] as double?,
      aquosaCorBaga: map['aquosaCorBaga'] as double?,
      corBagaPercentual: map['cor_baga_percentual'] as double?,
      cachoDuro: map['cachoDuro'] as double?,
      cachoRaloBanguelo: map['cachoRaloBanguelo'] as double?,
      cicatriz: map['cicatriz'] as double?,
      corpoEstranho: map['corpoEstranho'] as double?,
      desgranePercentual: map['desgranePercentual'] as double?,
      glomerella: map['glomerella'] as double?,
      lagarta: map['lagarta'] as double?,
      moscaFruta: map['moscaFruta'] as double?,
      murcha: map['murcha'] as double?,
      oidio: map['oidio'] as double?,
      podre: map['podre'] as double?,
      queimadoSol: map['queimadoSol'] as double?,
      rachada: map['rachada'] as double?,
      sacarose: map['sacarose'] as double?,
      translucido: map['translucido'] as double?,
      traca: map['traca'] as double?,
      observacoes: map['observacoes'] as String?,
      atualizadoEm: map['atualizadoEm'] != null
          ? DateTime.parse(map['atualizadoEm'] as String)
          : null,
    );
  }

  // === GETTERS PARA NOMES DAS TABELAS ===

  String get tableFichas => _tableFichas;
  String get tableAmostras => _tableAmostras;
  String get tableAmostrasDetalhadas => _tableAmostrasDetalhadas;
  String get tableMedidas => _tableMedidas;
  String get tableDefeitos => _tableDefeitos;
}
