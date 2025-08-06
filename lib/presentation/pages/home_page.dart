import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../responsive/responsive.dart';
import '../../core/theme/responsive_theme_extensions.dart';
import 'lista_fichas_page.dart';
import 'criar_ficha_page.dart';

/// Página principal do aplicativo de controle de qualidade
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, int> _estatisticas;

  @override
  void initState() {
    super.initState();
    _carregarEstatisticas();
  }

  void _carregarEstatisticas() {
    // Simular dados dinâmicos - em produção viria do repository
    final agora = DateTime.now();
    final pendentes = (agora.day % 5) + 1; // Entre 1-5 baseado no dia
    final salvos = (agora.day % 20) + 8; // Entre 8-27 baseado no dia

    setState(() {
      _estatisticas = {
        'pendentes': pendentes,
        'salvos': salvos,
        'total': pendentes + salvos,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      // === CONFIGURAÇÕES RESPONSIVAS ===
      applySafeArea:
          false, // Gerenciamos SafeArea manualmente para preservar gradiente
      centerContentOnTablet: true,
      tabletMaxContentWidth: 1000.0,
      customPadding:
          EdgeInsets.zero, // Sem padding padrão para preservar gradiente
      // === BODY RESPONSIVO ===
      body: _buildContent(context),
      mobileBody: _buildMobileLayout(context),
      tabletBody: _buildTabletLayout(context),
    );
  }

  /// Conteúdo padrão (fallback para mobile)
  Widget _buildContent(BuildContext context) {
    return _buildMobileLayout(context);
  }

  /// Layout para dispositivos mobile (preserva design original)
  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppColors.gradientDarkIntense
            : AppColors.gradientBrand,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, isTablet: false),
              const SizedBox(height: 60),

              // Cards de ação principal
              Expanded(child: _buildActionCards(context, isTablet: false)),

              // Status de sincronização
              _buildStatistics(context, isTablet: false),
            ],
          ),
        ),
      ),
    );
  }

  /// Layout para dispositivos tablet (duas colunas)
  Widget _buildTabletLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppColors.gradientDarkIntense
            : AppColors.gradientBrand,
      ),
      child: SafeArea(
        child: ResponsivePadding(
          tablet: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header responsivo
              _buildHeader(context, isTablet: true),

              SizedBox(height: ResponsiveThemeValues.sectionSpacing(context)),

              // Conteúdo principal em duas colunas
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Coluna esquerda - Cards de ação
                    Expanded(
                      flex: 2,
                      child: _buildActionCards(context, isTablet: true),
                    ),

                    SizedBox(
                      width: ResponsiveThemeValues.sectionSpacing(context),
                    ),

                    // Coluna direita - Estatísticas
                    Expanded(
                      flex: 1,
                      child: _buildStatistics(context, isTablet: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header responsivo que se adapta ao tipo de dispositivo
  Widget _buildHeader(BuildContext context, {bool isTablet = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isTablet ? 20 : 40),
        Text(
          'QualityFruit',
          style: GoogleFonts.poppins(
            fontSize: ResponsiveUtils.responsiveValue(
              context,
              mobile: 32,
              tablet: 40,
            ),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
        ),
        Text(
          'Sistema Offline de Controle de Qualidade 🍇',
          style: GoogleFonts.poppins(
            fontSize: ResponsiveUtils.responsiveValue(
              context,
              mobile: 16,
              tablet: 18,
            ),
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  /// Cards de ação responsivos
  Widget _buildActionCards(BuildContext context, {bool isTablet = false}) {
    if (isTablet) {
      // Layout em grid para tablets
      return Column(
        children: [
          // Primeira linha - Nova Ficha e Minhas Fichas
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: 'Nova Ficha',
                  subtitle: 'Criar nova avaliação',
                  icon: Icons.add_circle,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.cardDark
                      : Colors.white,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CriarFichaPage(),
                      ),
                    );
                    _carregarEstatisticas();
                  },
                ),
              ),
              SizedBox(width: ResponsiveThemeValues.elementSpacing(context)),
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: 'Minhas Fichas',
                  subtitle: 'Visualizar avaliações',
                  icon: Icons.list_alt,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.cardDark
                      : Colors.white,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListaFichasPage(),
                      ),
                    );
                    _carregarEstatisticas();
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveThemeValues.elementSpacing(context)),

          // Segunda linha - Sincronização
          _buildActionCard(
            context: context,
            title: 'Sincronizar com Drive',
            subtitle: 'Backup para Google Drive da empresa',
            icon: Icons.cloud_sync,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark
                : Colors.white,
            onTap: () => _showSyncDialog(context),
          ),
        ],
      );
    } else {
      // Layout vertical para mobile (original)
      return Column(
        children: [
          _buildActionCard(
            context: context,
            title: 'Nova Ficha',
            subtitle: 'Criar nova avaliação de qualidade',
            icon: Icons.add_circle,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark
                : Colors.white,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CriarFichaPage()),
              );
              _carregarEstatisticas();
            },
          ),
          const SizedBox(height: 20),
          _buildActionCard(
            context: context,
            title: 'Minhas Fichas',
            subtitle: 'Visualizar avaliações existentes',
            icon: Icons.list_alt,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark
                : Colors.white,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListaFichasPage(),
                ),
              );
              _carregarEstatisticas();
            },
          ),
          const SizedBox(height: 20),
          _buildActionCard(
            context: context,
            title: 'Sincronizar com Drive',
            subtitle: 'Backup para Google Drive da empresa',
            icon: Icons.cloud_sync,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark
                : Colors.white,
            onTap: () => _showSyncDialog(context),
          ),
        ],
      );
    }
  }

  /// Estatísticas responsivas
  Widget _buildStatistics(BuildContext context, {bool isTablet = false}) {
    if (isTablet) {
      // Painel vertical para tablets
      return Container(
        padding: ResponsiveThemeValues.cardPadding(context),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.cardDark.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estatísticas',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textDark
                    : Colors.white,
              ),
            ),
            SizedBox(height: ResponsiveThemeValues.elementSpacing(context)),
            _buildStatCard(
              context,
              'Pendentes',
              '${_estatisticas['pendentes'] ?? 0}',
              Icons.schedule,
              const Color(0xFFFFB74D),
            ),
            SizedBox(height: ResponsiveThemeValues.elementSpacing(context)),
            _buildStatCard(
              context,
              'Salvos',
              '${_estatisticas['salvos'] ?? 0}',
              Icons.check_circle,
              const Color(0xFF81C784),
            ),
            SizedBox(height: ResponsiveThemeValues.elementSpacing(context)),
            _buildStatCard(
              context,
              'Total',
              '${_estatisticas['total'] ?? 0}',
              Icons.folder,
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark
                  : Colors.white,
            ),
          ],
        ),
      );
    } else {
      // Layout horizontal para mobile (original)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.cardDark.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSyncStatus(
              context,
              'Pendentes',
              '${_estatisticas['pendentes'] ?? 0}',
              Icons.schedule,
              const Color(0xFFFFB74D),
            ),
            _buildSyncStatus(
              context,
              'Salvos',
              '${_estatisticas['salvos'] ?? 0}',
              Icons.check_circle,
              const Color(0xFF81C784),
            ),
            _buildSyncStatus(
              context,
              'Total',
              '${_estatisticas['total'] ?? 0}',
              Icons.folder,
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark
                  : Colors.white,
            ),
          ],
        ),
      );
    }
  }

  /// Card de estatística individual para tablets
  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundDark.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark
                        : Colors.white,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkRed
                      : AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textDark.withValues(alpha: 0.7)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatus(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark
                  : Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundDark
            : AppColors.backgroundWhite,
        title: Text(
          'Sincronização com Google Drive',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Este sistema funciona 100% offline no seu dispositivo.\n\n'
          'Quando conectado à internet, você pode sincronizar:\n'
          '• Backup de todas as fichas criadas\n'
          '• Envio para pasta específica do técnico\n'
          '• Armazenamento no Google Drive da empresa\n'
          '• Acesso aos dados de qualquer dispositivo\n\n'
          'Funcionalidade em desenvolvimento.',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Entendi',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors
                          .darkOrange // Usando cor padrão sem amarelo
                    : AppColors.primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
