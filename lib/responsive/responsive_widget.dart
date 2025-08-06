import 'package:flutter/material.dart';
import 'responsive_utils.dart';
import 'breakpoints.dart';

/// Widget builder que constrói layouts diferentes baseado no tipo de dispositivo
///
/// Permite criar layouts específicos para mobile e tablet de forma declarativa
typedef ResponsiveWidgetBuilder =
    Widget Function(
      BuildContext context,
      DeviceType deviceType,
      ScreenOrientation orientation,
    );

/// Widget base para responsividade que escolhe automaticamente o layout
/// apropriado baseado no tamanho da tela e orientação
///
/// Este widget serve como base para todas as telas responsivas da aplicação
class ResponsiveWidget extends StatelessWidget {
  /// Builder para dispositivos mobile (todos os tamanhos)
  final Widget Function(BuildContext context)? mobile;

  /// Builder para dispositivos tablet (todos os tamanhos)
  final Widget Function(BuildContext context)? tablet;

  /// Builder universal que recebe informações detalhadas do dispositivo
  /// Se fornecido, tem prioridade sobre mobile e tablet
  final ResponsiveWidgetBuilder? builder;

  /// Widget padrão caso nenhum builder específico seja fornecido
  final Widget? fallback;

  const ResponsiveWidget({
    super.key,
    this.mobile,
    this.tablet,
    this.builder,
    this.fallback,
  }) : assert(
         builder != null || mobile != null || fallback != null,
         'Pelo menos um builder (mobile, tablet, builder) ou fallback deve ser fornecido',
       );

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final orientation = ResponsiveUtils.getOrientation(context);

    // Se builder universal foi fornecido, usa ele
    if (builder != null) {
      return builder!(context, deviceType, orientation);
    }

    // Caso contrário, usa builders específicos por tipo de dispositivo
    if (ResponsiveUtils.isMobile(context) && mobile != null) {
      return mobile!(context);
    }

    if (ResponsiveUtils.isTablet(context) && tablet != null) {
      return tablet!(context);
    }

    // Fallback: se for tablet mas não tem builder tablet, usa mobile
    if (ResponsiveUtils.isTablet(context) && mobile != null) {
      return mobile!(context);
    }

    // Último recurso: widget fallback ou container vazio
    return fallback ?? const SizedBox.shrink();
  }
}

/// Widget wrapper que aplica padding responsivo baseado no tipo de dispositivo
///
/// Facilita a aplicação de espaçamentos consistentes em diferentes telas
class ResponsivePadding extends StatelessWidget {
  /// Widget filho que receberá o padding
  final Widget child;

  /// Padding para dispositivos mobile
  final EdgeInsets? mobile;

  /// Padding para dispositivos tablet
  final EdgeInsets? tablet;

  /// Padding padrão se valores específicos não forem fornecidos
  final EdgeInsets defaultPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.defaultPadding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsiveValue(
      context,
      mobile: mobile ?? defaultPadding,
      tablet: tablet ?? mobile ?? defaultPadding,
    );

    return Padding(padding: padding, child: child);
  }
}

/// Widget wrapper que aplica espaçamento responsivo entre elementos
///
/// Útil para manter consistência visual em listas e colunas
class ResponsiveSpacing extends StatelessWidget {
  /// Lista de widgets filhos que receberão espaçamento entre eles
  final List<Widget> children;

  /// Espaçamento vertical para dispositivos mobile
  final double? mobileSpacing;

  /// Espaçamento vertical para dispositivos tablet
  final double? tabletSpacing;

  /// Espaçamento padrão
  final double defaultSpacing;

  /// Direção do espaçamento (vertical ou horizontal)
  final Axis direction;

  const ResponsiveSpacing({
    super.key,
    required this.children,
    this.mobileSpacing,
    this.tabletSpacing,
    this.defaultSpacing = 16.0,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.responsiveValue(
      context,
      mobile: mobileSpacing ?? defaultSpacing,
      tablet: tabletSpacing ?? mobileSpacing ?? defaultSpacing,
    );

    final spacedChildren = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);

      // Adiciona espaçamento entre elementos (exceto após o último)
      if (i < children.length - 1) {
        if (direction == Axis.vertical) {
          spacedChildren.add(SizedBox(height: spacing));
        } else {
          spacedChildren.add(SizedBox(width: spacing));
        }
      }
    }

    return direction == Axis.vertical
        ? Column(children: spacedChildren)
        : Row(children: spacedChildren);
  }
}

/// Widget que aplica constraints responsivos baseados no tipo de dispositivo
///
/// Útil para limitar largura de conteúdo em tablets mantendo boa legibilidade
class ResponsiveConstraints extends StatelessWidget {
  /// Widget filho que receberá as constraints
  final Widget child;

  /// Largura máxima para dispositivos mobile
  final double? mobileMaxWidth;

  /// Largura máxima para dispositivos tablet
  final double? tabletMaxWidth;

  /// Altura máxima (aplicada a todos os dispositivos)
  final double? maxHeight;

  /// Alinhamento do conteúdo dentro das constraints
  final Alignment alignment;

  const ResponsiveConstraints({
    super.key,
    required this.child,
    this.mobileMaxWidth,
    this.tabletMaxWidth,
    this.maxHeight,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveUtils.responsiveValue(
      context,
      mobile: mobileMaxWidth,
      tablet: tabletMaxWidth,
    );

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: child,
      ),
    );
  }
}
