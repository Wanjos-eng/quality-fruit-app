import 'package:flutter/material.dart';
import '../../responsive/responsive_utils.dart';

/// Extensões responsivas para o tema da aplicação
///
/// Fornece métodos auxiliares para obter valores responsivos
/// baseados no tema atual e tipo de dispositivo
extension ResponsiveThemeExtension on ThemeData {
  /// Obtém tamanho de texto responsivo baseado no dispositivo
  ///
  /// [context] - Contexto do widget
  /// [baseStyle] - Estilo base para mobile
  /// [tabletScale] - Escala para aplicar em tablets (padrão: 1.1)
  TextStyle? responsiveTextStyle(
    BuildContext context,
    TextStyle? baseStyle, {
    double tabletScale = 1.1,
  }) {
    if (baseStyle == null) return null;

    return ResponsiveUtils.responsiveValue(
      context,
      mobile: baseStyle,
      tablet: baseStyle.copyWith(
        fontSize: (baseStyle.fontSize ?? 14) * tabletScale,
      ),
    );
  }

  /// Obtém espaçamento responsivo baseado no tema
  ///
  /// [context] - Contexto do widget
  /// [basePadding] - Padding base para mobile
  /// [tabletMultiplier] - Multiplicador para tablet (padrão: 1.5)
  EdgeInsets responsivePadding(
    BuildContext context,
    EdgeInsets basePadding, {
    double tabletMultiplier = 1.5,
  }) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: basePadding,
      tablet: basePadding * tabletMultiplier,
    );
  }

  /// Obtém raio de borda responsivo
  ///
  /// [context] - Contexto do widget
  /// [baseRadius] - Raio base para mobile
  /// [tabletRadius] - Raio específico para tablet (opcional)
  double responsiveBorderRadius(
    BuildContext context,
    double baseRadius, {
    double? tabletRadius,
  }) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: baseRadius,
      tablet: tabletRadius ?? baseRadius * 1.2,
    );
  }

  /// Obtém elevação responsiva para sombras
  ///
  /// [context] - Contexto do widget
  /// [baseElevation] - Elevação base para mobile
  /// [tabletElevation] - Elevação para tablet (opcional)
  double responsiveElevation(
    BuildContext context,
    double baseElevation, {
    double? tabletElevation,
  }) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: baseElevation,
      tablet: tabletElevation ?? baseElevation + 2,
    );
  }
}

/// Classe utilitária para valores responsivos relacionados ao tema
///
/// Centraliza constantes e cálculos de design responsivo
class ResponsiveThemeValues {
  /// Padding padrão para conteúdo principal
  static EdgeInsets contentPadding(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: const EdgeInsets.all(16.0),
      tablet: const EdgeInsets.all(24.0),
    );
  }

  /// Padding para cards e elementos destacados
  static EdgeInsets cardPadding(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: const EdgeInsets.all(12.0),
      tablet: const EdgeInsets.all(20.0),
    );
  }

  /// Espaçamento entre seções
  static double sectionSpacing(BuildContext context) {
    return ResponsiveUtils.responsiveValue(context, mobile: 24.0, tablet: 32.0);
  }

  /// Espaçamento entre elementos
  static double elementSpacing(BuildContext context) {
    return ResponsiveUtils.responsiveValue(context, mobile: 16.0, tablet: 20.0);
  }

  /// Altura de botões
  static double buttonHeight(BuildContext context) {
    return ResponsiveUtils.responsiveValue(context, mobile: 48.0, tablet: 56.0);
  }

  /// Altura de campos de texto
  static double textFieldHeight(BuildContext context) {
    return ResponsiveUtils.responsiveValue(context, mobile: 56.0, tablet: 64.0);
  }

  /// Tamanho de ícones
  static double iconSize(BuildContext context) {
    return ResponsiveUtils.responsiveValue(context, mobile: 24.0, tablet: 28.0);
  }

  /// Tamanho de ícones grandes (FAB, etc)
  static double largeIconSize(BuildContext context) {
    return ResponsiveUtils.responsiveValue(context, mobile: 56.0, tablet: 64.0);
  }
}
