import 'package:uuid/uuid.dart';

import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/local_datasource.dart';
import '../models/models.dart';

/// Implementação concreta do FichaRepository usando SQLite
class FichaRepositoryImpl implements FichaRepository {
  final LocalDatasource _datasource;
  final Uuid _uuid = const Uuid();

  const FichaRepositoryImpl(this._datasource);

  @override
  Future<Ficha> salvar(Ficha ficha) async {
    // Gera um novo ID se não existir
    final fichaParaSalvar = ficha.id.isEmpty
        ? ficha.copyWith(id: _uuid.v4())
        : ficha;

    final model = FichaModel.fromEntity(fichaParaSalvar);

    // Verifica se a ficha já existe para decidir entre insert ou update
    final fichaExistente = await buscarPorId(fichaParaSalvar.id);

    if (fichaExistente == null) {
      await _datasource.insert(_datasource.tableFichas, model.toSqliteMap());
    } else {
      await _datasource.update(
        _datasource.tableFichas,
        model.toSqliteMap(),
        where: 'id = ?',
        whereArgs: [fichaParaSalvar.id],
      );
    }

    return fichaParaSalvar;
  }

  @override
  Future<Ficha?> buscarPorId(String id) async {
    final results = await _datasource.query(
      _datasource.tableFichas,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;

    return FichaModel.fromSqliteMap(results.first).toEntity();
  }

  @override
  Future<Ficha?> buscarPorNumero(String numeroFicha) async {
    final results = await _datasource.query(
      _datasource.tableFichas,
      where: 'numeroFicha = ?',
      whereArgs: [numeroFicha],
      limit: 1,
    );

    if (results.isEmpty) return null;

    return FichaModel.fromSqliteMap(results.first).toEntity();
  }

  @override
  Future<List<Ficha>> listarTodas({int? limite, int? offset}) async {
    final results = await _datasource.query(
      _datasource.tableFichas,
      orderBy: 'criadoEm DESC',
      limit: limite,
      offset: offset,
    );

    return results
        .map((map) => FichaModel.fromSqliteMap(map).toEntity())
        .toList();
  }

  @override
  Future<List<Ficha>> listarPorCliente(String cliente) async {
    final results = await _datasource.query(
      _datasource.tableFichas,
      where: 'cliente LIKE ?',
      whereArgs: ['%$cliente%'],
      orderBy: 'criadoEm DESC',
    );

    return results
        .map((map) => FichaModel.fromSqliteMap(map).toEntity())
        .toList();
  }

  @override
  Future<List<Ficha>> listarPorProduto(String produto) async {
    final results = await _datasource.query(
      _datasource.tableFichas,
      where: 'produto LIKE ?',
      whereArgs: ['%$produto%'],
      orderBy: 'criadoEm DESC',
    );

    return results
        .map((map) => FichaModel.fromSqliteMap(map).toEntity())
        .toList();
  }

  @override
  Future<List<Ficha>> listarPorPeriodo({
    required DateTime dataInicio,
    required DateTime dataFim,
  }) async {
    final results = await _datasource.query(
      _datasource.tableFichas,
      where: 'dataAvaliacao BETWEEN ? AND ?',
      whereArgs: [
        dataInicio.millisecondsSinceEpoch,
        dataFim.millisecondsSinceEpoch,
      ],
      orderBy: 'dataAvaliacao DESC',
    );

    return results
        .map((map) => FichaModel.fromSqliteMap(map).toEntity())
        .toList();
  }

  @override
  Future<List<Ficha>> listarRecentes() async {
    final results = await _datasource.query(
      _datasource.tableFichas,
      orderBy: 'criadoEm DESC',
      limit: 10,
    );

    return results
        .map((map) => FichaModel.fromSqliteMap(map).toEntity())
        .toList();
  }

  @override
  Future<bool> excluir(String id) async {
    final rowsAffected = await _datasource.delete(
      _datasource.tableFichas,
      where: 'id = ?',
      whereArgs: [id],
    );

    return rowsAffected > 0;
  }

  @override
  Future<int> contarTotal() async {
    final results = await _datasource.rawQuery(
      'SELECT COUNT(*) as total FROM ${_datasource.tableFichas}',
    );

    return results.first['total'] as int;
  }

  @override
  Future<bool> existeNumero(String numeroFicha) async {
    final results = await _datasource.query(
      _datasource.tableFichas,
      columns: ['id'],
      where: 'numeroFicha = ?',
      whereArgs: [numeroFicha],
      limit: 1,
    );

    return results.isNotEmpty;
  }
}
