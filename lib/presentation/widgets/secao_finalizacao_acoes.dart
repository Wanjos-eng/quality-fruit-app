import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/amostra_detalhada.dart';

/// ✅ NOVA SEÇÃO 3: FINALIZAÇÃO E AÇÕES
///
/// Widget responsável pela nova terceira seção da ficha
/// Permite salvar, exportar PDF e compartilhar a ficha
class SecaoFinalizacaoAcoes extends StatelessWidget {
  final List<AmostraDetalhada> amostras;
  final Map<String, dynamic> dadosGerais;
  final VoidCallback? onSalvarRascunho;
  final VoidCallback? onSalvarFinal;
  final VoidCallback? onExportarPDF;
  final VoidCallback? onCompartilhar;
  final VoidCallback? onVisualizarResumo;

  const SecaoFinalizacaoAcoes({
    super.key,
    required this.amostras,
    required this.dadosGerais,
    this.onSalvarRascunho,
    this.onSalvarFinal,
    this.onExportarPDF,
    this.onCompartilhar,
    this.onVisualizarResumo,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 📋 CABEÇALHO DA SEÇÃO
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Finalizar Ficha',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Salve, exporte ou compartilhe sua ficha de qualidade',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),

        // 📊 RESUMO RÁPIDO
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[600]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumo da Ficha',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              _buildResumoItem(
                icon: Icons.assignment,
                label: 'Fazenda',
                valor: dadosGerais['fazenda']?.toString() ?? 'Não informado',
                isDark: isDark,
              ),
              _buildResumoItem(
                icon: Icons.calendar_today,
                label: 'Data de Avaliação',
                valor: dadosGerais['dataAvaliacao'] != null
                    ? _formatarData(dadosGerais['dataAvaliacao'] as DateTime)
                    : 'Não informado',
                isDark: isDark,
              ),
              _buildResumoItem(
                icon: Icons.science,
                label: 'Amostras Analisadas',
                valor:
                    '${amostras.length} amostra${amostras.length != 1 ? 's' : ''}',
                isDark: isDark,
              ),
              _buildResumoItem(
                icon: Icons.check_circle,
                label: 'Status',
                valor: _calcularStatusFicha(),
                isDark: isDark,
              ),
            ],
          ),
        ),

        // 🎯 AÇÕES PRINCIPAIS
        Column(
          children: [
            // Salvar como Rascunho
            _buildBotaoAcao(
              icon: Icons.save_outlined,
              titulo: 'Salvar como Rascunho',
              subtitulo: 'Salve para continuar preenchendo depois',
              cor: Colors.blue,
              onTap: onSalvarRascunho,
              isDark: isDark,
            ),

            const SizedBox(height: 12),

            // Salvar Ficha Final
            _buildBotaoAcao(
              icon: Icons.save_alt,
              titulo: 'Salvar Ficha Final',
              subtitulo: 'Finaliza e salva a ficha como concluída',
              cor: Colors.green,
              onTap: onSalvarFinal,
              isDark: isDark,
            ),

            const SizedBox(height: 12),

            // Exportar PDF
            _buildBotaoAcao(
              icon: Icons.picture_as_pdf,
              titulo: 'Exportar como PDF',
              subtitulo: 'Gera um arquivo PDF para impressão',
              cor: Colors.red,
              onTap: onExportarPDF,
              isDark: isDark,
            ),

            const SizedBox(height: 12),

            // Compartilhar
            _buildBotaoAcao(
              icon: Icons.share,
              titulo: 'Compartilhar',
              subtitulo: 'Compartilhe via WhatsApp, email ou outros apps',
              cor: Colors.orange,
              onTap: onCompartilhar,
              isDark: isDark,
            ),

            const SizedBox(height: 12),

            // Visualizar Resumo
            _buildBotaoAcao(
              icon: Icons.visibility,
              titulo: 'Visualizar Resumo',
              subtitulo: 'Veja um resumo completo antes de finalizar',
              cor: Colors.purple,
              onTap: onVisualizarResumo,
              isDark: isDark,
            ),
          ],
        ),

        // 📝 NOTA INFORMATIVA
        Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[300], size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'As fichas são salvas automaticamente no dispositivo. Use "Compartilhar" para enviar para outros dispositivos ou backup na nuvem.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResumoItem({
    required IconData icon,
    required String label,
    required String valor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoAcao({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required Color cor,
    required VoidCallback? onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[600]! : Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: cor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final meses = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    return '${data.day} ${meses[data.month - 1]} ${data.year}';
  }

  String _calcularStatusFicha() {
    final amostrasCompletas = amostras.where((a) => a.temDadosMinimos).length;
    if (amostrasCompletas == amostras.length) {
      return 'Completa (${amostras.length}/${amostras.length})';
    } else {
      return 'Em andamento ($amostrasCompletas/${amostras.length})';
    }
  }
}
