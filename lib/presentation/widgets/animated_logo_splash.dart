import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget de Splash Screen animado com logo da empresa recriado em código
///
/// Recria o logotipo "pura fruta EXPORTADORA" com três arcos concêntricos
/// e animação de rotação, escala e fade-in dos textos
class AnimatedLogoSplash extends StatefulWidget {
  /// Callback chamado quando a animação é concluída
  final VoidCallback? onAnimationComplete;

  /// Duração total da animação (padrão: 3 segundos)
  final Duration duration;

  const AnimatedLogoSplash({
    super.key,
    this.onAnimationComplete,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedLogoSplash> createState() => _AnimatedLogoSplashState();
}

class _AnimatedLogoSplashState extends State<AnimatedLogoSplash>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Controller principal da animação
    _mainController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Animação de rotação (0% a 40% da duração)
    _rotationAnimation =
        Tween<double>(
          begin: 0.0,
          end: 2 * pi, // 360 graus
        ).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
          ),
        );

    // Animação de escala (0% a 40% da duração)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    // Animação de opacidade do texto (50% a 80% da duração)
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );

    // Listener para callback de conclusão
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

    // Iniciar animação
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _mainController.forward();
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _mainController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animado (três arcos concêntricos)
                Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: const _LogoGraphic(),
                  ),
                ),

                const SizedBox(height: 40),

                // Textos com fade-in
                Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: const _LogoText(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Widget que desenha o elemento gráfico do logo (três arcos concêntricos)
class _LogoGraphic extends StatelessWidget {
  const _LogoGraphic();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

/// Painter personalizado para desenhar os três arcos concêntricos
class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Arco externo (verde-água)
    final outerPaint = Paint()
      ..color = const Color(0xFF33C3A8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 50),
      -pi / 3, // Ângulo inicial
      1.5 * pi, // 270 graus
      false,
      outerPaint,
    );

    // Arco intermediário (laranja)
    final middlePaint = Paint()
      ..color = const Color(0xFFF08A24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 35),
      -pi / 2.5, // Ângulo inicial
      1.5 * pi, // 270 graus
      false,
      middlePaint,
    );

    // Arco interno (vermelho)
    final innerPaint = Paint()
      ..color = const Color(0xFFD6373F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 20),
      -pi / 2, // Ângulo inicial
      1.5 * pi, // 270 graus
      false,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget que renderiza os textos do logo
class _LogoText extends StatelessWidget {
  const _LogoText();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Texto principal "pura fruta" (duas linhas)
        Text(
          'pura\nfruta',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE5585E),
            height: 1.1,
          ),
        ),

        const SizedBox(height: 8),

        // Texto secundário "EXPORTADORA"
        Text(
          'EXPORTADORA',
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFE5585E),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
