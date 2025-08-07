import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/amostra_detalhada.dart';

/// ✅ ETAPA 5 - SEÇÃO 3: OBSERVAÇÕES FINAIS
///
/// Widget responsável pela terceira seção da ficha
/// Permite escrever observações específicas por amostra
class SecaoObservacaoFinais extends StatelessWidget {
  final List<AmostraDetalhada> amostras;
  final Map<String, String> observacoesPorAmostra;
  final Function(String letra, String observacao) onObservacaoChanged;

  const SecaoObservacaoFinais({
    super.key,
    required this.amostras,
    required this.observacoesPorAmostra,
    required this.onObservacaoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 📋 CABEÇALHO SIMPLES DA SEÇÃO
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Observações Finais',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Adicione observações específicas para cada amostra (${amostras.length} amostras)',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),

        // 📝 LISTA DE OBSERVAÇÕES POR AMOSTRA
        ...amostras.map((amostra) => _buildCampoObservacao(amostra)),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCampoObservacao(AmostraDetalhada amostra) {
    final observacao = observacoesPorAmostra[amostra.letraAmostra] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amostra ${amostra.letraAmostra}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: observacao,
            onChanged: (valor) =>
                onObservacaoChanged(amostra.letraAmostra, valor),
            maxLines: 3,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText:
                  'Observações específicas para a amostra ${amostra.letraAmostra}...',
              hintStyle: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.7),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
