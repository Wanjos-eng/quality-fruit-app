import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_logo_splash.dart';

/// Tela de Splash Screen da aplicação
///
/// Exibe o logo animado da empresa e navega automaticamente
/// para a tela principal após a conclusão da animação
class SplashScreen extends StatefulWidget {
  /// Rota para navegar após a splash screen
  final String nextRoute;

  const SplashScreen({super.key, this.nextRoute = '/home'});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Configurar status bar para splash screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Callback chamado quando a animação do logo é concluída
  void _onAnimationComplete() {
    if (mounted) {
      // Navegar para a próxima tela com transição suave
      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedLogoSplash(
          onAnimationComplete: _onAnimationComplete,
          duration: const Duration(seconds: 3),
        ),
      ),
    );
  }
}

/// Classe para definir transições customizadas da splash screen
class SplashPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  SplashPageRoute({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Transição de fade suave
          return FadeTransition(opacity: animation, child: child);
        },
      );
}
