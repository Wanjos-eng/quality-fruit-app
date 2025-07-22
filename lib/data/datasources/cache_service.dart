import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';

/// Serviço para gerenciar cache local e rascunhos
/// Evita perda de dados quando o app é fechado inesperadamente
class CacheService {
  static const String _keyFichaRascunho = 'ficha_rascunho';
  static const String _keyAmostrasRascunho = 'amostras_rascunho_';
  static const String _keyConfiguracoes = 'configuracoes_usuario';
  static const String _keyEspecialista = 'especialista_atual';

  /// Salva rascunho de ficha em andamento
  Future<void> salvarRascunhoFicha(Ficha ficha) async {
    final prefs = await SharedPreferences.getInstance();
    final fichaModel = FichaModel.fromEntity(ficha);
    final json = jsonEncode(fichaModel.toJson());

    await prefs.setString(_keyFichaRascunho, json);
    await prefs.setString(
      '${_keyFichaRascunho}_timestamp',
      DateTime.now().toIso8601String(),
    );
  }

  /// Recupera rascunho de ficha
  Future<Ficha?> recuperarRascunhoFicha() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyFichaRascunho);

    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return FichaModel.fromJson(map).toEntity();
    } catch (e) {
      // Remove rascunho corrompido
      await limparRascunhoFicha();
      return null;
    }
  }

  /// Salva rascunhos de amostras de uma ficha
  Future<void> salvarRascunhoAmostras(
    String fichaId,
    List<Amostra> amostras,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final amostrasJson = amostras.map((amostra) {
      final model = AmostraModel.fromEntity(amostra);
      return model.toSqliteMap();
    }).toList();

    final json = jsonEncode(amostrasJson);
    await prefs.setString('$_keyAmostrasRascunho$fichaId', json);
  }

  /// Recupera rascunhos de amostras
  Future<List<Amostra>> recuperarRascunhoAmostras(String fichaId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('$_keyAmostrasRascunho$fichaId');

    if (json == null) return [];

    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map(
            (map) => AmostraModel.fromSqliteMap(
              map as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
    } catch (e) {
      // Remove rascunho corrompido
      await limparRascunhoAmostras(fichaId);
      return [];
    }
  }

  /// Define especialista atual
  Future<void> definirEspecialista(String nomeEspecialista) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEspecialista, nomeEspecialista);
  }

  /// Recupera especialista atual
  Future<String?> obterEspecialista() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEspecialista);
  }

  /// Verifica se existe rascunho de ficha
  Future<bool> existeRascunhoFicha() async {
    final ficha = await recuperarRascunhoFicha();
    return ficha != null;
  }

  /// Verifica tempo do último rascunho
  Future<DateTime?> obterDataUltimoRascunho() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString('${_keyFichaRascunho}_timestamp');

    if (timestamp == null) return null;

    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return null;
    }
  }

  /// Limpa rascunho de ficha
  Future<void> limparRascunhoFicha() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFichaRascunho);
    await prefs.remove('${_keyFichaRascunho}_timestamp');
  }

  /// Limpa rascunhos de amostras
  Future<void> limparRascunhoAmostras(String fichaId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyAmostrasRascunho$fichaId');
  }

  /// Limpa todos os rascunhos
  Future<void> limparTodosRascunhos() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where(
          (key) =>
              key.startsWith(_keyFichaRascunho) ||
              key.startsWith(_keyAmostrasRascunho),
        )
        .toList();

    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Salva configurações do usuário
  Future<void> salvarConfiguracoes(Map<String, dynamic> configuracoes) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(configuracoes);
    await prefs.setString(_keyConfiguracoes, json);
  }

  /// Recupera configurações do usuário
  Future<Map<String, dynamic>> obterConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyConfiguracoes);

    if (json == null) return {};

    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  /// Exibe estatísticas do cache
  Future<Map<String, dynamic>> obterEstatisticasCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    int rascunhosFicha = 0;
    int rascunhosAmostras = 0;

    for (final key in keys) {
      if (key.startsWith(_keyFichaRascunho)) rascunhosFicha++;
      if (key.startsWith(_keyAmostrasRascunho)) rascunhosAmostras++;
    }

    return {
      'rascunhos_ficha': rascunhosFicha,
      'rascunhos_amostras': rascunhosAmostras,
      'especialista_atual': await obterEspecialista(),
      'ultimo_rascunho': await obterDataUltimoRascunho(),
    };
  }
}
