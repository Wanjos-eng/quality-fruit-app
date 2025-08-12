import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/theme_notifier.dart';

/// Widget de botão deslizante animado para alternar tema
class AnimatedThemeToggle extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final double? width;
  final double? height;

  const AnimatedThemeToggle({
    super.key,
    required this.themeNotifier,
    this.width = 80.0,
    this.height = 40.0,
  });

  @override
  State<AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<AnimatedThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Define posição inicial baseada no tema atual
    if (widget.themeNotifier.isDarkMode) {
      _animationController.value = 1.0;
    }

    // Escuta mudanças no tema
    widget.themeNotifier.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (widget.themeNotifier.isDarkMode) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    widget.themeNotifier.removeListener(_onThemeChanged);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? 80.0;
    final height = widget.height ?? 40.0;
    final isDark = widget.themeNotifier.isDarkMode;

    return GestureDetector(
      onTap: () async {
        // Vibração tátil leve
        HapticFeedback.lightImpact();
        await widget.themeNotifier.toggleTheme();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF2C3E50), const Color(0xFF34495E)]
                      : [const Color(0xFFFFE5B4), const Color(0xFFFFF8DC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Botão deslizante
                  Positioned(
                    left: _slideAnimation.value * (width - height + 4) + 2,
                    top: 2,
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: height - 4,
                            height: height - 4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                (height - 4) / 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              isDark ? Icons.nightlight_round : Icons.wb_sunny,
                              color: isDark
                                  ? const Color(0xFF2C3E50)
                                  : const Color(0xFFFFA500),
                              size: (height - 4) * 0.55,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Labels dos lados - com máscaras para evitar sobreposição
                  Positioned.fill(
                    child: Row(
                      children: [
                        // Área do sol (lado esquerdo)
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: AnimatedOpacity(
                              opacity: isDark ? 0.0 : 0.6,
                              duration: const Duration(milliseconds: 250),
                              child: AnimatedScale(
                                scale: isDark ? 0.7 : 1.0,
                                duration: const Duration(milliseconds: 250),
                                child: Transform.translate(
                                  offset: Offset(
                                    _slideAnimation.value *
                                        -8.0, // Move para a esquerda quando desliza
                                    0,
                                  ),
                                  child: Text(
                                    '☀️',
                                    style: TextStyle(fontSize: height * 0.32),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Área da lua (lado direito)
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: AnimatedOpacity(
                              opacity: isDark ? 0.6 : 0.0,
                              duration: const Duration(milliseconds: 250),
                              child: AnimatedScale(
                                scale: isDark ? 1.0 : 0.7,
                                duration: const Duration(milliseconds: 250),
                                child: Transform.translate(
                                  offset: Offset(
                                    (1.0 - _slideAnimation.value) *
                                        8.0, // Move para a direita quando não desliza
                                    0,
                                  ),
                                  child: Text(
                                    '🌙',
                                    style: TextStyle(fontSize: height * 0.32),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
