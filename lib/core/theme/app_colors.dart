import 'package:flutter/material.dart';

/// Sistema de cores adaptativo da Pura Fruta Exportadora
/// Suporte automático para light/dark mode com cores da marca
class AppColors {
  // === CORES PRINCIPAIS DA MARCA ===
  
  /// Vermelho principal Pura Fruta (#D81E05)
  static const Color primaryRed = Color(0xFFD81E05);
  
  /// Laranja secundário Pura Fruta (#FF5722 ou #FF9800)
  static const Color secondaryOrange = Color(0xFFFF5722);
  static const Color secondaryOrangeAlt = Color(0xFFFF9800);
  
  // === CORES PARA DARK MODE ===
  
  /// Vermelho escuro para dark mode
  static const Color primaryRedDark = Color(0xFF8B0000);
  
  /// Laranja escuro para dark mode  
  static const Color secondaryOrangeDark = Color(0xFFD84315);

  // === CORES BÁSICAS ===
  
  /// Branco puro
  static const Color backgroundWhite = Colors.white;
  
  /// Preto puro
  static const Color backgroundBlack = Colors.black;
  
  /// Cinza claro para backgrounds
  static const Color backgroundGrayLight = Color(0xFFF5F5F5);
  
  /// Cinza escuro para dark mode
  static const Color backgroundGrayDark = Color(0xFF2D2D2D);
  
  // === CORES DE TEXTO ===
  
  /// Texto primário (escuro)
  static const Color textPrimary = Color(0xFF2C2C2C);
  
  /// Texto secundário (cinza)
  static const Color textSecondary = Color(0xFF666666);
  
  /// Texto claro (branco)
  static const Color textLight = Colors.white;
  
  // === CORES DE STATUS ===
  
  /// Verde para sucesso/positivo
  static const Color positiveGreen = Color(0xFF4CAF50);
  
  /// Vermelho para erro/negativo  
  static const Color statusError = Color(0xFFF44336);
  
  /// Amarelo para aviso
  static const Color warningYellow = Color(0xFFFF9800);

  // === CORES ADICIONAIS (COMPATIBILIDADE) ===
  
  /// Cor de borda
  static const Color border = Color(0xFFE0E0E0);
  
  /// Cor de divider
  static const Color divider = Color(0xFFE0E0E0);
  
  /// Cor de texto desabilitado
  static const Color textDisabled = Color(0xFFBDBDBD);
  
  /// Cor de texto escuro
  static const Color textDark = Color(0xFFFFFFFF);
  
  /// Cor de card escuro
  static const Color cardDark = Color(0xFF2D2D2D);
  
  /// Cor de background escuro
  static const Color backgroundDark = Color(0xFF1E1E1E);
  
  /// Gradiente vermelho-laranja
  static const LinearGradient gradientRedOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, secondaryOrange],
  );

  // === MÉTODOS ADAPTATIVOS ===
  
  /// Retorna gradiente principal adaptativo baseado no tema
  static List<Color> getMainGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark 
      ? [primaryRedDark, secondaryOrangeDark]
      : [primaryRed, secondaryOrange];
  }
  
  /// Retorna cor de card adaptativa baseada no tema
  static Color getCardColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? backgroundGrayDark : backgroundWhite;
  }
  
  /// Retorna cor de background adaptativa baseada no tema
  static Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? backgroundBlack : backgroundWhite;
  }
  
  /// Retorna cor de texto primário adaptativa baseada no tema
  static Color getPrimaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? textLight : textPrimary;
  }
  
  /// Retorna cor de texto secundário adaptativa baseada no tema
  static Color getSecondaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Color(0xFFB0B0B0) : textSecondary;
  }
  
  /// Retorna cor de ícone primário adaptativa baseada no tema
  static Color getPrimaryIconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? primaryRedDark : primaryRed;
  }
  
  /// Retorna cor de ícone secundário adaptativa baseada no tema
  static Color getSecondaryIconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? secondaryOrangeDark : secondaryOrange;
  }
  
  /// Retorna cor de diálogo adaptativa baseada no tema
  static Color getDialogBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Color(0xFF1E1E1E) : backgroundWhite;
  }
  
  /// Retorna cor de divider adaptativa baseada no tema
  static Color getDividerColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Color(0xFF444444) : Color(0xFFE0E0E0);
  }
}