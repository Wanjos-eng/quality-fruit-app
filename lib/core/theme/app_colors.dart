import 'package:flutter/material.dart';

/// Paleta de Cores da Pura Fruta Exportadora
/// Baseada nas cores exatas do logotipo da empresa
/// Design moderno com suporte a tema claro e escuro
class AppColors {
  // === CORES EXATAS DA LOGO PURA FRUTA ===

  /// Cor Primária - Vermelho da Logo #D81E05
  static const Color primaryRed = Color(0xFFD81E05);

  /// Cor Secundária - Laranja da Logo #FDB813
  static const Color secondaryOrange = Color(0xFFFDB813);

  /// Destaque Positivo - Verde da Logo #61BB46
  static const Color positiveGreen = Color(0xFF61BB46);

  /// Preto da Logo #000000
  static const Color brandBlack = Color(0xFF000000);

  // === VARIAÇÕES PARA TEMA CLARO ===

  /// Vermelho mais suave para tema claro
  static const Color lightRed = Color(0xFFE85A47);

  /// Verde mais suave para tema claro
  static const Color lightGreen = Color(0xFF7BC662);

  /// Laranja mais suave para tema claro (sem amarelo)
  static const Color lightOrange = Color(0xFFFF6B35);

  // === VARIAÇÕES PARA TEMA ESCURO ===

  /// Vermelho mais escuro para tema escuro
  static const Color darkRed = Color(0xFF8B0000);

  /// Verde mais escuro para tema escuro
  static const Color darkGreen = Color(0xFF16A34A);

  /// Laranja mais escuro para tema escuro (sem amarelo)
  static const Color darkOrange = Color(0xFFFF4500);

  // === CORES DE FUNDO ===

  /// Fundo Principal - Branco
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  /// Fundo Secundário - Cinza Claro
  static const Color backgroundGrayLight = Color(0xFFF8F9FA);

  // === MODO ESCURO ===

  /// Fundo Modo Escuro - Cinza muito escuro
  static const Color backgroundDark = Color(0xFF0F0F0F);

  /// Cards Modo Escuro - Cinza escuro
  static const Color cardDark = Color(0xFF1A1A1A);

  /// Surface Modo Escuro - Cinza médio escuro
  static const Color surfaceDark = Color(0xFF262626);

  /// Texto Modo Escuro
  static const Color textDark = Color(0xFFF5F5F5);

  // === CORES NEUTRAS ===

  /// Texto Principal
  static const Color textPrimary = Color(0xFF212121);

  /// Texto Secundário
  static const Color textSecondary = Color(0xFF757575);

  /// Texto Disabled
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// Bordas
  static const Color border = Color(0xFFE0E0E0);

  /// Divisores
  static const Color divider = Color(0xFFEEEEEE);

  // === CORES DE STATUS ===

  /// Status Finalizada (Verde)
  static const Color statusCompleted = positiveGreen;

  /// Status Em Andamento (Laranja)
  static const Color statusInProgress = secondaryOrange;

  /// Status Erro (Vermelho)
  static const Color statusError = primaryRed;

  /// Status Sucesso (Verde)
  static const Color statusSuccess = positiveGreen;

  // === GRADIENTES PURA FRUTA EXPORTADORA ===

  /// 1. Gradiente Principal da Marca (Escuro)
  static const LinearGradient gradientBrand = LinearGradient(
    colors: [Color(0xFF8B0000), Color(0xFFFF4500)], // Dark Red → Orange Red
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 2. Gradiente Tema Escuro
  static const LinearGradient gradientDark = LinearGradient(
    colors: [Color(0xFF8B0000), Color(0xFFFF4500)], // Dark Red → Orange Red
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 3. Gradiente Escuro Intenso (HomePage)
  static const LinearGradient gradientDarkIntense = LinearGradient(
    colors: [Color(0xFF660000), Color(0xFFCC3300)], // Very Dark Red → Dark Red
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// 4. Gradiente Logo Original (Vermelho → Laranja)
  static const LinearGradient gradientRedOrange = LinearGradient(
    colors: [Color(0xFFD81E05), Color(0xFFFDB813)], // Cores exatas da logo
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// 5. Gradiente Tema Claro
  static const LinearGradient gradientLight = LinearGradient(
    colors: [Color(0xFFE85A47), Color(0xFFFF6B35)], // Light Red → Light Orange
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente Verde para elementos positivos
  static const LinearGradient gradientGreen = LinearGradient(
    colors: [positiveGreen, lightGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // === CORES AUXILIARES PURA FRUTA (sem amarelo) ===

  /// Cor de alerta/warning - Laranja (sem amarelo)
  static const Color warningYellow = Color(0xFFFF8C00);

  /// Cor de informação - Azul
  static const Color infoBlue = Color(0xFF3B82F6);

  /// Cor neutra moderna
  static const Color neutralGray = Color(0xFF6B7280);
}
