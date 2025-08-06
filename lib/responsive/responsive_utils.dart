import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Utilitário global para detecção e configuração de responsividade
/// Centraliza toda lógica de responsividade para mobile e tablet
class ResponsiveUtils {
  /// Obtém o tipo de dispositivo baseado na largura da tela
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  ///
  /// Retorna [DeviceType] correspondente ao tamanho da tela
  static DeviceType getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < ResponsiveBreakpoints.mobile) {
      return DeviceType.mobileSmall;
    } else if (screenWidth < ResponsiveBreakpoints.mobileLarge) {
      return DeviceType.mobile;
    } else if (screenWidth < ResponsiveBreakpoints.tabletSmall) {
      return DeviceType.mobileLarge;
    } else if (screenWidth < ResponsiveBreakpoints.tablet) {
      return DeviceType.tabletSmall;
    } else if (screenWidth < ResponsiveBreakpoints.tabletLarge) {
      return DeviceType.tablet;
    } else {
      return DeviceType.tabletLarge;
    }
  }

  /// Verifica se o dispositivo é um mobile (qualquer tamanho)
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  ///
  /// Retorna true se for mobile (small, normal ou large)
  static bool isMobile(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.mobileSmall ||
        deviceType == DeviceType.mobile ||
        deviceType == DeviceType.mobileLarge;
  }

  /// Verifica se o dispositivo é um tablet (qualquer tamanho)
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  ///
  /// Retorna true se for tablet (small, normal ou large)
  static bool isTablet(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.tabletSmall ||
        deviceType == DeviceType.tablet ||
        deviceType == DeviceType.tabletLarge;
  }

  /// Obtém a orientação atual da tela
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  ///
  /// Retorna [ScreenOrientation] (portrait ou landscape)
  static ScreenOrientation getOrientation(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait
        ? ScreenOrientation.portrait
        : ScreenOrientation.landscape;
  }

  /// Verifica se a tela está em modo paisagem
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  static bool isLandscape(BuildContext context) {
    return getOrientation(context) == ScreenOrientation.landscape;
  }

  /// Verifica se a tela está em modo retrato
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  static bool isPortrait(BuildContext context) {
    return getOrientation(context) == ScreenOrientation.portrait;
  }

  /// Obtém o padding de segurança da tela (SafeArea)
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  ///
  /// Retorna EdgeInsets com os valores de padding seguros
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Obtém a altura total da tela
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Obtém a largura total da tela
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Obtém a altura disponível (descontando SafeArea e barra de status)
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  static double getAvailableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
  }

  /// Obtém a largura disponível (descontando SafeArea lateral se houver)
  ///
  /// [context] - Contexto do widget para acessar MediaQuery
  static double getAvailableWidth(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width -
        mediaQuery.padding.left -
        mediaQuery.padding.right;
  }

  /// Calcula um valor responsivo baseado no tipo de dispositivo
  ///
  /// Permite definir valores diferentes para cada tipo de dispositivo
  /// Se um valor não for fornecido, usa o valor mobile como fallback
  ///
  /// [context] - Contexto do widget
  /// [mobile] - Valor para dispositivos mobile
  /// [tablet] - Valor para dispositivos tablet (opcional)
  /// [mobileSmall] - Valor específico para mobile pequeno (opcional)
  /// [mobileLarge] - Valor específico para mobile grande (opcional)
  /// [tabletLarge] - Valor específico para tablet grande (opcional)
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? mobileSmall,
    T? mobileLarge,
    T? tabletLarge,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobileSmall:
        return mobileSmall ?? mobile;
      case DeviceType.mobile:
        return mobile;
      case DeviceType.mobileLarge:
        return mobileLarge ?? mobile;
      case DeviceType.tabletSmall:
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.tabletLarge:
        return tabletLarge ?? tablet ?? mobile;
    }
  }
}
