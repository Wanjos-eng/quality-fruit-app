import 'package:flutter/material.dart';
import 'responsive_utils.dart';
import 'responsive_widget.dart';

/// Scaffold responsivo que adapta automaticamente layout para mobile e tablet
///
/// Serve como base para todas as telas da aplicação, fornecendo:
/// - AppBar responsiva com altura e elementos ajustados
/// - Body com padding e constraints responsivos
/// - FloatingActionButton posicionado adequadamente
/// - Drawer e BottomNavigationBar quando necessário
class ResponsiveScaffold extends StatelessWidget {
  /// Título da tela exibido na AppBar
  final String? title;

  /// Widget personalizado para o título (sobrescreve title se fornecido)
  final Widget? titleWidget;

  /// Conteúdo principal da tela
  final Widget body;

  /// Widget para layout mobile específico (sobrescreve body se fornecido)
  final Widget? mobileBody;

  /// Widget para layout tablet específico (sobrescreve body se fornecido)
  final Widget? tabletBody;

  /// Lista de ações na AppBar
  final List<Widget>? actions;

  /// Widget de leading na AppBar (botão voltar customizado)
  final Widget? leading;

  /// FloatingActionButton da tela
  final Widget? floatingActionButton;

  /// Posição do FloatingActionButton
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Drawer lateral (gaveta de navegação)
  final Widget? drawer;

  /// BottomNavigationBar para navegação inferior
  final Widget? bottomNavigationBar;

  /// Cor de fundo da tela
  final Color? backgroundColor;

  /// Se deve aplicar SafeArea automaticamente
  final bool applySafeArea;

  /// Padding adicional personalizado
  final EdgeInsets? customPadding;

  /// Se deve centralizar o conteúdo em tablets
  final bool centerContentOnTablet;

  /// Largura máxima do conteúdo em tablets
  final double? tabletMaxContentWidth;

  const ResponsiveScaffold({
    super.key,
    this.title,
    this.titleWidget,
    required this.body,
    this.mobileBody,
    this.tabletBody,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.applySafeArea = true,
    this.customPadding,
    this.centerContentOnTablet = true,
    this.tabletMaxContentWidth = 800.0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // === APPBAR RESPONSIVA ===
      appBar: _buildResponsiveAppBar(context),

      // === DRAWER ===
      drawer: drawer,

      // === BODY RESPONSIVO ===
      body: _buildResponsiveBody(context),

      // === FLOATING ACTION BUTTON ===
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,

      // === BOTTOM NAVIGATION ===
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  /// Constrói AppBar responsiva adaptada ao tipo de dispositivo
  PreferredSizeWidget? _buildResponsiveAppBar(BuildContext context) {
    if (title == null && titleWidget == null) return null;

    // Altura da AppBar responsiva
    final appBarHeight = ResponsiveUtils.responsiveValue(
      context,
      mobile: kToolbarHeight, // 56.0
      tablet: kToolbarHeight + 8.0, // 64.0 - um pouco maior em tablets
    );

    // Tamanho do texto do título
    final titleTextStyle = ResponsiveUtils.responsiveValue(
      context,
      mobile: Theme.of(context).textTheme.titleLarge,
      tablet: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
    );

    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        title: titleWidget ?? Text(title!, style: titleTextStyle),
        actions: actions,
        leading: leading,
        centerTitle: ResponsiveUtils.isMobile(context),
        elevation: ResponsiveUtils.responsiveValue(
          context,
          mobile: 0,
          tablet: 1,
        ),
      ),
    );
  }

  /// Constrói body responsivo com layout apropriado para cada dispositivo
  Widget _buildResponsiveBody(BuildContext context) {
    // Determina qual widget de conteúdo usar
    Widget content = body;
    if (ResponsiveUtils.isMobile(context) && mobileBody != null) {
      content = mobileBody!;
    } else if (ResponsiveUtils.isTablet(context) && tabletBody != null) {
      content = tabletBody!;
    }

    // Aplica SafeArea se solicitado
    if (applySafeArea) {
      content = SafeArea(child: content);
    }

    // Aplica padding responsivo
    content = ResponsivePadding(
      mobile: customPadding ?? _getDefaultMobilePadding(),
      tablet: customPadding ?? _getDefaultTabletPadding(),
      child: content,
    );

    // Em tablets, centraliza conteúdo e aplica largura máxima se solicitado
    if (ResponsiveUtils.isTablet(context) && centerContentOnTablet) {
      content = ResponsiveConstraints(
        tabletMaxWidth: tabletMaxContentWidth,
        alignment: Alignment.topCenter,
        child: content,
      );
    }

    return content;
  }

  /// Padding padrão para dispositivos mobile
  EdgeInsets _getDefaultMobilePadding() {
    return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  }

  /// Padding padrão para dispositivos tablet
  EdgeInsets _getDefaultTabletPadding() {
    return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
  }
}

/// Page wrapper responsivo para navegação entre telas
///
/// Facilita a criação de páginas que se adaptam automaticamente
class ResponsivePage extends StatelessWidget {
  /// Conteúdo da página que será exibido responsivamente
  final Widget child;

  /// Se deve aplicar scroll automático quando conteúdo exceder a tela
  final bool enableScroll;

  /// Tipo de scroll (apenas para mobile por padrão)
  final ScrollPhysics? scrollPhysics;

  const ResponsivePage({
    super.key,
    required this.child,
    this.enableScroll = true,
    this.scrollPhysics,
  });

  @override
  Widget build(BuildContext context) {
    if (!enableScroll) {
      return child;
    }

    // Em mobile, sempre aplica scroll
    // Em tablet, aplica scroll apenas se necessário
    final shouldScroll =
        ResponsiveUtils.isMobile(context) || _contentExceedsScreen(context);

    if (shouldScroll) {
      return SingleChildScrollView(
        physics:
            scrollPhysics ??
            (ResponsiveUtils.isMobile(context)
                ? const BouncingScrollPhysics()
                : const ClampingScrollPhysics()),
        child: child,
      );
    }

    return child;
  }

  /// Verifica se o conteúdo provavelmente excederá a altura da tela
  /// (implementação simplificada - pode ser expandida conforme necessário)
  bool _contentExceedsScreen(BuildContext context) {
    // Por simplicidade, assume que tablets têm mais espaço
    // Em implementação real, poderia medir o widget filho
    return ResponsiveUtils.getAvailableHeight(context) < 600;
  }
}
