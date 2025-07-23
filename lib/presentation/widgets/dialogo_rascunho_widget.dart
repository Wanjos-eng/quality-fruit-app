import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/gerenciar_cache_arquivamento_usecase.dart';

/// Widget para mostrar diálogo quando rascunho é encontrado
class DialogoRascunhoWidget extends StatelessWidget {
  final Map<String, dynamic> infoRascunho;
  final Function(AcaoRascunho) onAcaoSelecionada;

  const DialogoRascunhoWidget({
    super.key,
    required this.infoRascunho,
    required this.onAcaoSelecionada,
  });

  @override
  Widget build(BuildContext context) {
    final ficha = infoRascunho['ficha'] as Ficha;
    final dataRascunho = infoRascunho['data_rascunho'] as DateTime?;
    final especialista = infoRascunho['especialista'] as String?;
    final tempoDecorrido = infoRascunho['tempo_decorrido'] as int?;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.edit_note,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.secondaryOrange.withValues(alpha: 0.8)
                : AppColors.secondaryOrange,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'Rascunho Encontrado',
            style: AppTypography.titleMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Foi encontrado um rascunho não salvo. Deseja recuperá-lo?',
            style: AppTypography.bodyLarge.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark
                  : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Informações do rascunho
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cardDark
                  : AppColors.backgroundGrayLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.secondaryOrange.withValues(alpha: 0.5)
                            : AppColors.secondaryOrange)
                        .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(context, 'Ficha:', 'Nº ${ficha.numeroFicha}'),
                _buildInfoRow(context, 'Cliente:', ficha.cliente),
                _buildInfoRow(context, 'Produto:', ficha.produto),
                if (especialista != null)
                  _buildInfoRow(context, 'Especialista:', especialista),
                if (dataRascunho != null)
                  _buildInfoRow(
                    context,
                    'Salvo em:',
                    '${dataRascunho.day}/${dataRascunho.month}/${dataRascunho.year} '
                        '${dataRascunho.hour.toString().padLeft(2, '0')}:'
                        '${dataRascunho.minute.toString().padLeft(2, '0')}',
                  ),
                if (tempoDecorrido != null)
                  _buildInfoRow(
                    context,
                    'Tempo:',
                    _formatarTempo(tempoDecorrido),
                    corValor: _corTempo(tempoDecorrido),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text(
            '⚠️ Se ignorar, todos os dados do rascunho serão perdidos permanentemente.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.statusError,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundWhite,
      actions: [
        // Botão Manter para Depois
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAcaoSelecionada(AcaoRascunho.manter);
          },
          child: Text('Manter', style: AppTypography.buttonSecondaryGreen),
        ),

        // Botão Ignorar
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAcaoSelecionada(AcaoRascunho.ignorar);
          },
          child: Text(
            'Ignorar',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.statusError,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Botão Recuperar (Principal)
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onAcaoSelecionada(AcaoRascunho.recuperar);
          },
          icon: const Icon(Icons.restore, size: 18),
          label: const Text('Recuperar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkGreen
                : AppColors.positiveGreen,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String valor, {
    Color? corValor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textDark.withValues(alpha: 0.7)
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: AppTypography.bodyMedium.copyWith(
                color:
                    corValor ??
                    (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark
                        : AppColors.textPrimary),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatarTempo(int minutos) {
    if (minutos < 60) {
      return '${minutos}min atrás';
    } else if (minutos < 1440) {
      // 24 horas
      final horas = minutos ~/ 60;
      return '${horas}h atrás';
    } else {
      final dias = minutos ~/ 1440;
      return '${dias}d atrás';
    }
  }

  Color _corTempo(int minutos) {
    if (minutos < 30) {
      return AppColors.positiveGreen; // Recente
    } else if (minutos < 1440) {
      return AppColors.secondaryOrange; // Algumas horas
    } else {
      return AppColors.statusError; // Mais de um dia
    }
  }
}

/// Método de conveniência para mostrar o diálogo
Future<void> mostrarDialogoRascunho({
  required BuildContext context,
  required Map<String, dynamic> infoRascunho,
  required Function(AcaoRascunho) onAcaoSelecionada,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Força o usuário a escolher uma ação
    builder: (context) => DialogoRascunhoWidget(
      infoRascunho: infoRascunho,
      onAcaoSelecionada: onAcaoSelecionada,
    ),
  );
}
