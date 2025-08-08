import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget de Splash Screen que cria efeitos de carregamento
/// sobre a logo estática nativa do Android com transição de cores
///
/// Simula um carregamento com animações de círculos e textos
/// que aparecem sobre a splash screen nativa, enquanto o fundo
/// gradualmente adquire as cores da tela home
class LoadingOverlaySplash extends StatefulWidget {
  /// Callback chamado quando a animação é concluída
  final VoidCallback? onAnimationComplete;

  /// Duração total da animação (padrão: 4 segundos)
  final Duration duration;

  const LoadingOverlaySplash({
    super.key,
    this.onAnimationComplete,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<LoadingOverlaySplash> createState() => _LoadingOverlaySplashState();
}

class _LoadingOverlaySplashState extends State<LoadingOverlaySplash>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _circleController;
  late AnimationController _textController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _circleRotationAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _colorTransitionAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Controller para efeitos de carregamento
    _loadingController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Controller para rotação contínua dos círculos
    _circleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Controller para animação do texto PuraFruta
    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Animação de fade-in dos elementos de carregamento
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Animação de rotação contínua
    _circleRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _circleController, curve: Curves.linear));

    // Animação de progresso de carregamento
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: const Interval(0.2, 0.9, curve: Curves.easeInOut),
      ),
    );

    // Animação de transição de cor do fundo (branco → gradiente home)
    _colorTransitionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Animação de deslizamento do texto PuraFruta
    _textSlideAnimation = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
    );

    // Animação de escala pulsante para o texto
    _textScaleAnimation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Listener para callback de conclusão
    _loadingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

    // Iniciar animações
    _startAnimations();
  }

  void _startAnimations() {
    // Pequeno delay para sincronizar com a splash nativa
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _loadingController.forward();
        _circleController.repeat(); // Rotação contínua
        _textController.repeat(reverse: true); // Pulsação contínua do texto
      }
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _circleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _loadingController,
          _circleController,
          _textController,
        ]),
        builder: (context, child) {
          // Criar gradiente de transição: branco → gradiente da home
          final backgroundGradient = LinearGradient(
            colors: [
              Color.lerp(
                Colors.white,
                const Color(0xFF8B0000), // Dark Red
                _colorTransitionAnimation.value,
              )!,
              Color.lerp(
                Colors.white,
                const Color(0xFFFF4500), // Orange Red
                _colorTransitionAnimation.value,
              )!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

          return Container(
            decoration: BoxDecoration(gradient: backgroundGradient),
            child: Stack(
              children: [
                // Indicador de carregamento circular animado sobre a logo
                Center(
                  child: Opacity(
                    opacity: _fadeInAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 120,
                        ), // Espaço para a logo nativa
                        // Círculos de carregamento animados
                        Transform.rotate(
                          angle: _circleRotationAnimation.value,
                          child: const _AnimatedLoadingCircles(),
                        ),

                        const SizedBox(height: 20),

                        // Texto animado "PuraFruta..." com efeito de movimento
                        Transform.translate(
                          offset: Offset(_textSlideAnimation.value, 0),
                          child: Transform.scale(
                            scale: _textScaleAnimation.value,
                            child: _AnimatedPuraFrutaText(
                              colorProgress: _colorTransitionAnimation.value,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Barra de progresso - cor dinâmica
                        Container(
                          width: 200,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Color.lerp(
                              Colors.grey[300]!,
                              Colors.white.withValues(alpha: 0.3),
                              _colorTransitionAnimation.value,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 200 * _progressAnimation.value,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Color.lerp(
                                  const Color(0xFFE53E3E),
                                  Colors.white,
                                  _colorTransitionAnimation.value *
                                      0.5, // Mantém contraste
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Widget que desenha círculos de carregamento animados
/// Simula o movimento dos arcos da logo original
class _AnimatedLoadingCircles extends StatelessWidget {
  const _AnimatedLoadingCircles();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(painter: _LoadingCirclesPainter()),
    );
  }
}

/// Painter para círculos de carregamento em movimento
class _LoadingCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 3.0;

    // Círculo externo - Verde
    final greenPaint = Paint()
      ..color = const Color(0xFF38A169)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 25),
      -pi / 2,
      pi, // 180 graus
      false,
      greenPaint,
    );

    // Círculo médio - Laranja
    final orangePaint = Paint()
      ..color = const Color(0xFFED8936)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 18),
      pi / 2,
      pi, // 180 graus
      false,
      orangePaint,
    );

    // Círculo interno - Vermelho
    final redPaint = Paint()
      ..color = const Color(0xFFE53E3E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 11),
      -pi / 2,
      pi, // 180 graus
      false,
      redPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget que renderiza o texto "PuraFruta..." com efeitos de movimento
class _AnimatedPuraFrutaText extends StatelessWidget {
  final double colorProgress;

  const _AnimatedPuraFrutaText({required this.colorProgress});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          // "Pura" em estilo normal
          TextSpan(
            text: 'Pura',
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color.lerp(
                const Color(0xFFE53E3E), // Vermelho da logo
                Colors.white,
                colorProgress * 0.8,
              ),
              letterSpacing: 1.5,
            ),
          ),
          // "Fruta" em estilo bold
          TextSpan(
            text: 'Fruta',
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color.lerp(
                const Color(0xFFE53E3E), // Vermelho da logo
                Colors.white,
                colorProgress * 0.8,
              ),
              letterSpacing: 1.5,
            ),
          ),
          // Pontos com efeito de fade
          TextSpan(
            text: '...',
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color.lerp(
                const Color(0xFFED8936), // Laranja
                Colors.white.withValues(alpha: 0.7),
                colorProgress,
              ),
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
