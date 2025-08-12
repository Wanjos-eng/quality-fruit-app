import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gerenciador de estado do tema da aplicação
class ThemeNotifier extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light; // Começa sempre no modo claro

  ThemeMode get themeMode => _themeMode;

  /// Inicializa o tema salvando a preferência do usuário
  Future<void> initTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            _themeMode = ThemeMode.light;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            break;
          default:
            _themeMode = ThemeMode.light; // Padrão é claro
        }
      } else {
        // Se não há preferência salva, define como claro e salva
        _themeMode = ThemeMode.light;
        await _saveTheme();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar tema: $e');
      _themeMode = ThemeMode.light;
    }
  }

  /// Alterna entre tema claro e escuro
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    await _saveTheme();
    notifyListeners();
  }

  /// Salva a preferência de tema
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = _themeMode == ThemeMode.light ? 'light' : 'dark';
      await prefs.setString(_themeKey, themeString);
    } catch (e) {
      debugPrint('Erro ao salvar tema: $e');
    }
  }

  /// Verifica se está no modo escuro
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Verifica se está no modo claro
  bool get isLightMode => _themeMode == ThemeMode.light;
}
