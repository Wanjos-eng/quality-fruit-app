import 'package:flutter/material.dart';

/// Paleta de Cores da Pura Fruta Exportadora
/// Identidade Visual: Flat/Minimalista com alto contraste
class AppColors {
  // === CORES PRINCIPAIS DA MARCA ===

  /// Cor Primária - Vermelho #E53935
  static const primaryRed = Color(0xFFE53935);

  /// Cor Secundária - Laranja #FF9800
  static const secondaryOrange = Color(0xFFFF9800);

  /// Destaque Positivo - Verde #43A047
  static const positiveGreen = Color(0xFF43A047);

  /// Alerta Positivo - Amarelo #FFC107
  static const warningYellow = Color(0xFFFFC107);

  // === CORES DE FUNDO ===

  /// Fundo Principal - Branco
  static const backgroundWhite = Color(0xFFFFFFFF);

  /// Fundo Secundário - Cinza Claro
  static const backgroundGrayLight = Color(0xFFF5F5F5);

  // === MODO ESCURO ===

  /// Fundo Modo Escuro
  static const backgroundDark = Color(0xFF181A1B);

  /// Cards Modo Escuro
  static const cardDark = Color(0xFF2C2E2F);

  /// Texto Modo Escuro
  static const textDark = Color(0xFFFFFFFF);

  // === CORES NEUTRAS ===

  /// Texto Principal
  static const textPrimary = Color(0xFF212121);

  /// Texto Secundário
  static const textSecondary = Color(0xFF757575);

  /// Texto Disabled
  static const textDisabled = Color(0xFFBDBDBD);

  /// Bordas
  static const border = Color(0xFFE0E0E0);

  /// Divisores
  static const divider = Color(0xFFEEEEEE);

  // === CORES DE STATUS ===

  /// Status Finalizada (Verde)
  static const statusCompleted = positiveGreen;

  /// Status Em Andamento (Laranja)
  static const statusInProgress = secondaryOrange;

  /// Status Erro (Vermelho)
  static const statusError = primaryRed;

  /// Status Sucesso (Verde)
  static const statusSuccess = positiveGreen;

  // === GRADIENTES ===

  /// Gradiente Vermelho-Laranja para abas ativas
  static const gradientRedOrange = LinearGradient(
    colors: [primaryRed, secondaryOrange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Gradiente Verde para elementos positivos
  static const gradientGreen = LinearGradient(
    colors: [positiveGreen, Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
