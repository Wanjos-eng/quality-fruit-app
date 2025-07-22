import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Sistema de Tipografia da Pura Fruta Exportadora
/// Fonte principal: Montserrat | Alternativa: Inter | Fallback: Roboto
class AppTypography {
  // === CONFIGURAÇÃO DE FONTES ===

  /// Fonte principal - Montserrat
  static TextStyle get _baseTextStyle => GoogleFonts.montserrat();

  /// Fonte alternativa - Inter (caso Montserrat não carregue)
  static TextStyle get _fallbackTextStyle => GoogleFonts.inter();

  // === TÍTULOS (18-22px, Negrito, Vermelho ou Verde) ===

  /// Título Principal - 22px, Negrito, Vermelho
  static TextStyle get titleLarge => _baseTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryRed,
    height: 1.3,
  );

  /// Título Médio - 20px, Negrito, Vermelho
  static TextStyle get titleMedium => _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryRed,
    height: 1.3,
  );

  /// Título Pequeno - 18px, Negrito, Verde (para destaques positivos)
  static TextStyle get titleSmall => _baseTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.positiveGreen,
    height: 1.3,
  );

  // === TEXTO NORMAL (16px) ===

  /// Texto normal - 16px, Regular
  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Texto médio - 14px, Regular
  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Texto pequeno - 12px, Regular
  static TextStyle get bodySmall => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // === AÇÕES SECUNDÁRIAS (Verde/Laranja) ===

  /// Botão secundário - Verde
  static TextStyle get buttonSecondaryGreen => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.positiveGreen,
    height: 1.2,
  );

  /// Botão secundário - Laranja
  static TextStyle get buttonSecondaryOrange => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryOrange,
    height: 1.2,
  );

  // === BOTÕES PRINCIPAIS ===

  /// Botão principal - Texto branco sobre vermelho
  static TextStyle get buttonPrimary => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.backgroundWhite,
    height: 1.2,
  );

  // === CAMPOS DE INPUT ===

  /// Label dos campos
  static TextStyle get inputLabel => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Texto dentro dos campos
  static TextStyle get inputText => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Placeholder dos campos
  static TextStyle get inputHint => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDisabled,
    height: 1.4,
  );

  // === VARIAÇÕES PARA MODO ESCURO ===

  /// Título para modo escuro
  static TextStyle get titleLargeDark =>
      titleLarge.copyWith(color: AppColors.textDark);

  /// Texto normal para modo escuro
  static TextStyle get bodyLargeDark =>
      bodyLarge.copyWith(color: AppColors.textDark);

  /// Texto secundário para modo escuro
  static TextStyle get bodyMediumDark =>
      bodyMedium.copyWith(color: AppColors.textDark.withOpacity(0.7));

  // === UTILITÁRIOS ===

  /// Cria uma variação com cor personalizada
  static TextStyle withColor(TextStyle base, Color color) {
    return base.copyWith(color: color);
  }

  /// Cria uma variação com tamanho personalizado
  static TextStyle withSize(TextStyle base, double size) {
    return base.copyWith(fontSize: size);
  }

  /// Cria uma variação com peso personalizado
  static TextStyle withWeight(TextStyle base, FontWeight weight) {
    return base.copyWith(fontWeight: weight);
  }
}
