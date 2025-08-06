/// Definição de breakpoints para responsividade mobile e tablet
/// Segue padrões de design responsivo focados em dispositivos móveis
class ResponsiveBreakpoints {
  /// Largura mínima para considerar dispositivo mobile pequeno (smartphones compactos)
  static const double mobileSmall = 320.0;

  /// Largura mínima para considerar dispositivo mobile padrão (smartphones normais)
  static const double mobile = 375.0;

  /// Largura mínima para considerar dispositivo mobile grande (smartphones grandes)
  static const double mobileLarge = 414.0;

  /// Largura mínima para considerar dispositivo tablet pequeno (tablets 7-8")
  static const double tabletSmall = 600.0;

  /// Largura mínima para considerar dispositivo tablet padrão (tablets 9-10")
  static const double tablet = 768.0;

  /// Largura mínima para considerar dispositivo tablet grande (tablets 11-12")
  static const double tabletLarge = 1024.0;

  /// Altura mínima para considerar tela pequena
  static const double shortScreen = 568.0;

  /// Altura padrão para telas normais
  static const double normalScreen = 812.0;

  /// Altura para telas longas (dispositivos modernos)
  static const double tallScreen = 926.0;
}

/// Enum para tipos de dispositivo suportados
enum DeviceType {
  /// Smartphone pequeno (< 375px)
  mobileSmall,

  /// Smartphone padrão (375px - 414px)
  mobile,

  /// Smartphone grande (414px - 600px)
  mobileLarge,

  /// Tablet pequeno (600px - 768px)
  tabletSmall,

  /// Tablet padrão (768px - 1024px)
  tablet,

  /// Tablet grande (> 1024px)
  tabletLarge,
}

/// Enum para orientação da tela
enum ScreenOrientation {
  /// Tela em modo retrato
  portrait,

  /// Tela em modo paisagem
  landscape,
}
