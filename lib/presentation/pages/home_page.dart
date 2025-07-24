import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
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
    return Scaffold(
      body: Container(
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
                const SizedBox(height: 40),
                Text(
                  'QualityFruit',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark
                        : Colors.white,
                  ),
                ),
                Text(
                  'Sistema Offline de Controle de Qualidade 🍇',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 60),

                // Cards de ação principal
                Expanded(
                  child: Column(
                    children: [
                      // Card Nova Ficha
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
                            MaterialPageRoute(
                              builder: (context) => const CriarFichaPage(),
                            ),
                          );
                          // Atualizar estatísticas ao retornar
                          _carregarEstatisticas();
                        },
                      ),
                      const SizedBox(height: 20),

                      // Card Ver Fichas
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
                          // Atualizar estatísticas ao retornar
                          _carregarEstatisticas();
                        },
                      ),
                      const SizedBox(height: 20),

                      // Card Sincronização
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
                  ),
                ),

                // Status de sincronização
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
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
                        const Color(0xFFFFB74D), // Âmbar para pendentes
                      ),
                      _buildSyncStatus(
                        context,
                        'Salvos',
                        '${_estatisticas['salvos'] ?? 0}',
                        Icons.check_circle,
                        const Color(0xFF81C784), // Verde suave
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
                ),
              ],
            ),
          ),
        ),
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
