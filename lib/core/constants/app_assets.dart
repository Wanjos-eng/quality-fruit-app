/// Classe de constantes para gerenciar assets de ícones e imagens
///
/// Centraliza o acesso aos recursos visuais do projeto,
/// facilitando manutenção e evitando erros de digitação
class AppAssets {
  // Pasta base de assets
  static const String _iconsPath = 'assets/icons';
  static const String _imagesPath = 'assets/images';

  // === ÍCONES DO APP ===

  /// Logo principal em alta resolução (1024x1024)
  static const String logoHigh = '$_iconsPath/app_icon/logo_1024.png';

  /// Logo para play store (512x512)
  static const String logoPlayStore = '$_iconsPath/app_icon/logo_512.png';

  // === ÍCONES ANDROID (para configuração manual) ===
  // Estes arquivos estão em assets/icons/android/res/
  // e podem ser copiados para android/app/src/main/res/

  static const String androidIconsPath = '$_iconsPath/android/res';

  // === IMAGENS GERAIS ===
  // Adicione aqui conforme necessário
  static const String backgroundPath = '$_imagesPath/';
  // static const String splashBackground = '$_imagesPath/splash_bg.png';

  // === MÉTODOS UTILITÁRIOS ===

  /// Retorna o caminho do logo baseado no tamanho desejado
  static String getLogoPath({bool highRes = false}) {
    return highRes ? logoHigh : logoPlayStore;
  }

  /// Lista todos os assets de ícones disponíveis
  static List<String> getAllIconAssets() {
    return [logoHigh, logoPlayStore];
  }

  /// Lista todos os assets de imagens disponíveis
  static List<String> getAllImageAssets() {
    return [
      // Adicione conforme necessário
    ];
  }
}
