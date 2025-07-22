import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Tema principal da aplicação Pura Fruta Exportadora
/// Implementa design flat/minimalista com cantos arredondados e sombra leve
class AppTheme {
  // === CONFIGURAÇÕES GERAIS ===

  /// Raio padrão para cantos arredondados
  static const double borderRadius = 16.0;

  /// Raio menor para elementos pequenos
  static const double borderRadiusSmall = 8.0;

  /// Raio maior para cards principais
  static const double borderRadiusLarge = 24.0;

  /// Elevação padrão para sombra leve
  static const double elevation = 4.0;

  /// Elevação menor para elementos sutis
  static const double elevationSmall = 2.0;

  // === TEMA CLARO ===

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // === ESQUEMA DE CORES ===
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        brightness: Brightness.light,
        primary: AppColors.primaryRed,
        secondary: AppColors.secondaryOrange,
        tertiary: AppColors.positiveGreen,
        surface: AppColors.backgroundWhite,
        error: AppColors.statusError,
        onPrimary: AppColors.backgroundWhite,
        onSecondary: AppColors.backgroundWhite,
        onSurface: AppColors.textPrimary,
      ),

      // === TIPOGRAFIA ===
      textTheme: TextTheme(
        // Títulos
        headlineLarge: AppTypography.titleLarge,
        headlineMedium: AppTypography.titleMedium,
        headlineSmall: AppTypography.titleSmall,

        // Corpo do texto
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,

        // Labels
        labelLarge: AppTypography.buttonPrimary,
        labelMedium: AppTypography.inputLabel,
        labelSmall: AppTypography.bodySmall,
      ),

      // === APP BAR ===
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundWhite,
        foregroundColor: AppColors.textPrimary,
        elevation: elevationSmall,
        centerTitle: true,
        titleTextStyle: AppTypography.titleMedium,
        shadowColor: AppColors.border.withValues(alpha: 0.3),
      ),

      // === BOTÕES PRINCIPAIS ===
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.backgroundWhite,
          elevation: elevation,
          shadowColor: AppColors.primaryRed.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: AppTypography.buttonPrimary,
        ),
      ),

      // === BOTÕES SECUNDÁRIOS ===
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondaryOrange,
          side: const BorderSide(color: AppColors.secondaryOrange, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: AppTypography.buttonSecondaryOrange,
        ),
      ),

      // === BOTÕES DE TEXTO ===
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.positiveGreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTypography.buttonSecondaryGreen,
        ),
      ),

      // === BOTÕES DE AÇÃO FLUTUANTE ===
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.positiveGreen,
        foregroundColor: AppColors.backgroundWhite,
        elevation: elevation,
        shape: CircleBorder(),
      ),

      // === CAMPOS DE INPUT ===
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.statusError, width: 2),
        ),
        labelStyle: AppTypography.inputLabel,
        hintStyle: AppTypography.inputHint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // === CARDS ===
      cardTheme: CardThemeData(
        color: AppColors.backgroundWhite,
        elevation: elevation,
        shadowColor: AppColors.border.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // === ABAS ===
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.backgroundWhite,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTypography.buttonPrimary,
        unselectedLabelStyle: AppTypography.bodyMedium,
        indicator: BoxDecoration(
          gradient: AppColors.gradientRedOrange,
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      // === DIVISORES ===
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // === TEMA ESCURO ===

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // === ESQUEMA DE CORES ===
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        brightness: Brightness.dark,
        primary: AppColors.primaryRed,
        secondary: AppColors.secondaryOrange,
        tertiary: AppColors.positiveGreen,
        surface: AppColors.cardDark,
        error: AppColors.statusError,
        onPrimary: AppColors.backgroundWhite,
        onSecondary: AppColors.backgroundWhite,
        onSurface: AppColors.textDark,
      ),

      // === TIPOGRAFIA MODO ESCURO ===
      textTheme: TextTheme(
        headlineLarge: AppTypography.titleLargeDark,
        headlineMedium: AppTypography.titleLargeDark,
        headlineSmall: AppTypography.titleSmall.copyWith(
          color: AppColors.positiveGreen,
        ),
        bodyLarge: AppTypography.bodyLargeDark,
        bodyMedium: AppTypography.bodyMediumDark,
        bodySmall: AppTypography.bodyMediumDark,
      ),

      // === APP BAR MODO ESCURO ===
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textDark,
        elevation: elevationSmall,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLargeDark,
      ),

      // === CARDS MODO ESCURO ===
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: elevation,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // === CAMPOS INPUT MODO ESCURO ===
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: BorderSide(color: AppColors.textDark.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: BorderSide(color: AppColors.textDark.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
        ),
        labelStyle: AppTypography.inputLabel.copyWith(
          color: AppColors.textDark,
        ),
        hintStyle: AppTypography.inputHint.copyWith(
          color: AppColors.textDark.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
