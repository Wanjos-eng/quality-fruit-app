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
        child: ResponsivePadding(
          mobile: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.responsiveValue(
              context,
              mobile: 16.0,
              mobileSmall: 12.0,
            ),
          ),
          child: Column(
            children: [
              // === CABEÇALHO FIXO ===
              Container(
                padding: EdgeInsets.symmetric(
                  vertical:
                      ResponsiveThemeValues.elementSpacing(context) * 0.75,
                ),
                child: _buildHeader(context, isTablet: false),
              ),

              // === ÁREA CENTRAL FLEXÍVEL E ROLÁVEL ===
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: ResponsiveUtils.responsiveValue(
                      context,
                      mobile: 20.0,
                      mobileSmall: 16.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ResponsiveUtils.responsiveValue(
                          context,
                          mobile: 40.0,
                          mobileSmall: 24.0,
                        ),
                      ),

                      // Cards de ação principal
                      _buildActionCards(context, isTablet: false),

                      SizedBox(
                        height: ResponsiveUtils.responsiveValue(
                          context,
                          mobile: 40.0,
                          mobileSmall: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // === RODAPÉ FIXO (BARRA DE STATUS) ===
              Container(
                padding: EdgeInsets.only(
                  bottom: ResponsiveUtils.responsiveValue(
                    context,
                    mobile: 20.0,
                    mobileSmall: 16.0,
                  ),
                ),
                child: _buildStatistics(context, isTablet: false),
              ),
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
        SizedBox(
          height: isTablet
              ? ResponsiveThemeValues.elementSpacing(context) * 0.5
              : ResponsiveThemeValues.elementSpacing(context) * 0.25,
        ),

        // Alinhamento usando valores globais do sistema responsivo
        ResponsivePadding(
          mobile: EdgeInsets.only(
            left: ResponsiveThemeValues.elementSpacing(context) * 0.25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'QualityFruit',
                style: GoogleFonts.poppins(
                  fontSize: ResponsiveUtils.responsiveValue(
                    context,
                    mobile: 28.0,
                    mobileSmall: 24.0,
                    tablet: 32.0,
                  ),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textDark
                      : Colors.white,
                ),
              ),
              SizedBox(
                height: ResponsiveThemeValues.elementSpacing(context) * 0.125,
              ),
              Text(
                'Sistema Offline de Controle de Qualidade 🍇',
                style: GoogleFonts.poppins(
                  fontSize: ResponsiveUtils.responsiveValue(
                    context,
                    mobile: 14.0,
                    mobileSmall: 12.0,
                    tablet: 16.0,
                  ),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textDark.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
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
          SizedBox(
            height: ResponsiveUtils.responsiveValue(
              context,
              mobile: 20.0,
              mobileSmall: 16.0,
            ),
          ),
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
          SizedBox(
            height: ResponsiveUtils.responsiveValue(
              context,
              mobile: 20.0,
              mobileSmall: 16.0,
            ),
          ),
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
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.responsiveValue(
            context,
            mobile: 24.0,
            mobileSmall: 16.0,
          ),
          vertical: ResponsiveUtils.responsiveValue(
            context,
            mobile: 20.0,
            mobileSmall: 16.0,
          ),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.cardDark.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.25),
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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.responsiveValue(
          context,
          tablet: 16.0,
          mobile: 14.0,
        ),
        vertical: ResponsiveUtils.responsiveValue(
          context,
          tablet: 12.0,
          mobile: 10.0,
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundDark.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: ResponsiveUtils.responsiveValue(
              context,
              tablet: 24.0,
              mobile: 22.0,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.responsiveValue(
              context,
              tablet: 12.0,
              mobile: 10.0,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: ResponsiveUtils.responsiveValue(
                      context,
                      tablet: 20.0,
                      mobile: 18.0,
                    ),
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark
                        : Colors.white,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: ResponsiveUtils.responsiveValue(
                      context,
                      tablet: 12.0,
                      mobile: 11.0,
                    ),
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
      elevation: ResponsiveUtils.responsiveValue(
        context,
        mobile: 8.0,
        mobileSmall: 6.0,
      ),
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.responsiveValue(
              context,
              mobile: 24.0,
              mobileSmall: 20.0,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.responsiveValue(
                    context,
                    mobile: 16.0,
                    mobileSmall: 12.0,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkRed
                      : AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  size: ResponsiveUtils.responsiveValue(
                    context,
                    mobile: 32.0,
                    mobileSmall: 28.0,
                  ),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.responsiveValue(
                  context,
                  mobile: 20.0,
                  mobileSmall: 16.0,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: ResponsiveUtils.responsiveValue(
                          context,
                          mobile: 20.0,
                          mobileSmall: 18.0,
                        ),
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
                        fontSize: ResponsiveUtils.responsiveValue(
                          context,
                          mobile: 14.0,
                          mobileSmall: 12.0,
                        ),
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
                size: ResponsiveUtils.responsiveValue(
                  context,
                  mobile: 20.0,
                  mobileSmall: 18.0,
                ),
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
          Icon(
            icon,
            color: iconColor,
            size: ResponsiveUtils.responsiveValue(
              context,
              mobile: 18.0,
              mobileSmall: 16.0,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.responsiveValue(
              context,
              mobile: 6.0,
              mobileSmall: 4.0,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: ResponsiveUtils.responsiveValue(
                context,
                mobile: 20.0,
                mobileSmall: 18.0,
              ),
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark
                  : Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: ResponsiveUtils.responsiveValue(
                context,
                mobile: 11.0,
                mobileSmall: 10.0,
              ),
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
