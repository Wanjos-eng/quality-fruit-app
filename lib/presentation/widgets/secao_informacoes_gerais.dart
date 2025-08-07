import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../responsive/responsive.dart';

/// ✅ ETAPA 2 - SEÇÃO 1: INFORMAÇÕES GERAIS
///
/// Widget responsável pela primeira seção da ficha
/// Implementa os campos iniciais com formatação adequada
class SecaoInformacoesGerais extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final int? ano;
  final String? fazenda;
  final DateTime? dataAvaliacao;
  final int? semanaAno;
  final String? inspetor;
  final String tipoAmostragem;
  final double? pesoBruto;

  // Callbacks para atualizar o estado
  final ValueChanged<int?> onAnoChanged;
  final ValueChanged<String?> onFazendaChanged;
  final ValueChanged<DateTime?> onDataChanged;
  final ValueChanged<String?> onInspetorChanged;
  final ValueChanged<String> onTipoAmostragemChanged;
  final ValueChanged<double?> onPesoBrutoChanged;

  const SecaoInformacoesGerais({
    super.key,
    required this.formKey,
    required this.ano,
    required this.fazenda,
    required this.dataAvaliacao,
    required this.semanaAno,
    required this.inspetor,
    required this.tipoAmostragem,
    required this.pesoBruto,
    required this.onAnoChanged,
    required this.onFazendaChanged,
    required this.onDataChanged,
    required this.onInspetorChanged,
    required this.onTipoAmostragemChanged,
    required this.onPesoBrutoChanged,
  });

  /// Opções de tipo de amostragem conforme especificação exata
  static const List<String> _tiposAmostragem = [
    'Cumbuca 500g',
    'Cumbuca 250g',
    'Sacola (Caixa)',
  ];

  @override
  Widget build(BuildContext context) {
    // Cache dos valores responsivos para evitar múltiplas chamadas
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;

    return ResponsivePadding(
      mobile: EdgeInsets.symmetric(
        horizontal: isTablet ? 32.0 : 16.0,
        vertical: isTablet ? 24.0 : 20.0,
      ),
      tablet: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 CAMPOS DO FORMULÁRIO - Direto no gradiente, sem caixas
            _buildFormularioResponsivo(context),
          ],
        ),
      ),
    );
  }

  /// Constrói formulário responsivo
  Widget _buildFormularioResponsivo(BuildContext context) {
    // Cache do valor para evitar múltiplas chamadas ao MediaQuery
    final isTablet = MediaQuery.of(context).size.width > 768;

    if (isTablet) {
      return _buildFormularioTablet(context);
    } else {
      return _buildFormularioMobile(context);
    }
  }

  /// Layout do formulário para tablets (2 colunas)
  Widget _buildFormularioTablet(BuildContext context) {
    const spacing = 16.0; // Espaçamento fixo para tablet

    return Column(
      children: [
        // Linha 1: Ano e Fazenda
        Row(
          children: [
            Expanded(
              child: _buildDropdownAno(
                context: context,
                label: 'Ano *',
                value: ano,
                onChanged: onAnoChanged,
                validator: (value) {
                  if (value == null) {
                    return 'Ano é obrigatório';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(child: _buildCampoFazenda(context)),
          ],
        ),

        const SizedBox(height: spacing),

        // Linha 2: Data e Semana
        Row(
          children: [
            Expanded(flex: 2, child: _buildCampoData(context)),
            const SizedBox(width: spacing),
            Expanded(child: _buildCampoSemana(context)),
          ],
        ),

        const SizedBox(height: spacing),

        // Linha 4: Inspetor e Tipo de Amostragem
        Row(
          children: [
            Expanded(
              child: _buildCampoTexto(
                context: context,
                label: 'Inspetor *',
                value: inspetor,
                onChanged: onInspetorChanged,
                hint: 'Nome do inspetor responsável',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inspetor é obrigatório';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(child: _buildDropdownTipoAmostragem(context)),
          ],
        ),

        const SizedBox(height: spacing),

        // Linha 5: Peso Bruto (centralizado)
        Row(
          children: [
            Expanded(child: _buildCampoPeso(context)),
            const Expanded(
              child: SizedBox(),
            ), // Espaço vazio para balanceamento
          ],
        ),
      ],
    );
  }

  /// Layout do formulário para mobile (1 coluna)
  Widget _buildFormularioMobile(BuildContext context) {
    const spacing = 12.0; // Espaçamento fixo para mobile

    return Column(
      children: [
        // ROW 1: Ano e Fazenda
        Row(
          children: [
            Expanded(
              child: _buildDropdownAno(
                context: context,
                label: 'Ano *',
                value: ano,
                onChanged: onAnoChanged,
                validator: (value) {
                  if (value == null) {
                    return 'Ano é obrigatório';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: spacing),
            Expanded(child: _buildCampoFazenda(context)),
          ],
        ),

        const SizedBox(height: spacing),

        // ROW 2: Data de Avaliação e Semana
        Row(
          children: [
            Expanded(flex: 2, child: _buildCampoData(context)),
            const SizedBox(width: spacing),
            Expanded(child: _buildCampoSemana(context)),
          ],
        ),

        const SizedBox(height: spacing),

        // ROW 3: Inspetor
        _buildCampoTexto(
          context: context,
          label: 'Inspetor *',
          value: inspetor,
          onChanged: onInspetorChanged,
          hint: 'Nome do inspetor responsável',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Inspetor é obrigatório';
            }
            return null;
          },
        ),

        const SizedBox(height: spacing),

        // ROW 4: Tipo de Amostragem
        _buildDropdownTipoAmostragem(context),

        const SizedBox(height: spacing),

        // ROW 5: Peso Bruto
        _buildCampoPeso(context),
      ],
    );
  }

  /// Constrói campo de texto padrão
  Widget _buildCampoTexto({
    required BuildContext context,
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
    required String hint,
    String? Function(String?)? validator,
  }) {
    const double fontSize = 14.0; // Tamanho de fonte fixo
    const double spacing = 8.0; // Espaçamento fixo
    const EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
        ),
        const SizedBox(height: spacing),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.15),
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
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
                width: 2,
              ),
            ),
            contentPadding: contentPadding,
          ),
        ),
      ],
    );
  }

  /// Constrói dropdown de ano
  Widget _buildDropdownAno({
    required BuildContext context,
    required String label,
    required int? value,
    required ValueChanged<int?> onChanged,
    String? Function(int?)? validator,
  }) {
    const double fontSize = 14.0;
    const double spacing = 8.0;
    const EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0,
    );

    // Gerar lista de anos de 2020 a 2035
    final anos = List.generate(16, (index) => 2020 + index);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
        ),
        const SizedBox(height: spacing),
        DropdownButtonFormField<int>(
          value: value,
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
          decoration: InputDecoration(
            hintText: 'Selecione o ano',
            hintStyle: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.15),
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
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
                width: 2,
              ),
            ),
            contentPadding: contentPadding,
          ),
          items: anos.map((ano) {
            return DropdownMenuItem(
              value: ano,
              child: Text(
                ano.toString(),
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            );
          }).toList(),
          isExpanded: true,
          iconEnabledColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
          dropdownColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.backgroundWhite.withValues(alpha: 0.95),
          menuMaxHeight: 300,
        ),
      ],
    );
  }

  /// Constrói campo de fazenda (texto com validação de sigla)
  Widget _buildCampoFazenda(BuildContext context) {
    const double fontSize = 14.0; // Tamanho de fonte fixo
    const double spacing = 8.0; // Espaçamento fixo
    const EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fazenda *',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
        ),
        const SizedBox(height: spacing),
        TextFormField(
          initialValue: fazenda,
          onChanged: (value) {
            // Converte para maiúsculo e limita a 3 caracteres
            final upperValue = value.toUpperCase();
            if (upperValue.length <= 3) {
              onFazendaChanged(upperValue.isEmpty ? null : upperValue);
            }
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Fazenda é obrigatória';
            }
            if (value.length != 3) {
              return 'Sigla deve ter exatamente 3 letras';
            }
            if (!RegExp(r'^[A-Z]{3}$').hasMatch(value)) {
              return 'Use apenas letras (ex: ABC)';
            }
            return null;
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(3),
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              return newValue.copyWith(text: newValue.text.toUpperCase());
            }),
          ],
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
          decoration: InputDecoration(
            hintText: 'Ex: ABC',
            hintStyle: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.15),
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
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
                width: 2,
              ),
            ),
            contentPadding: contentPadding,
          ),
        ),
      ],
    );
  }

  /// Constrói campo de data
  Widget _buildCampoData(BuildContext context) {
    const double fontSize = 14.0; // Tamanho de fonte fixo
    const double spacing = 8.0; // Espaçamento fixo
    const EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 14.0,
    );
    const double iconSize = 18.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data de Avaliação (Dia/Mês) *',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
        ),
        const SizedBox(height: spacing),
        GestureDetector(
          onTap: () => _mostrarSeletorData(context),
          child: Container(
            width: double.infinity,
            padding: padding,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cardDark.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textDark.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.7),
                  size: iconSize,
                ),
                const SizedBox(width: 12),
                Text(
                  dataAvaliacao != null
                      ? '${dataAvaliacao!.day.toString().padLeft(2, '0')}/${dataAvaliacao!.month.toString().padLeft(2, '0')}'
                      : 'Selecione dia/mês',
                  style: GoogleFonts.poppins(
                    color: dataAvaliacao != null
                        ? (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textDark
                              : Colors.white)
                        : (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textDark.withValues(alpha: 0.6)
                              : Colors.white.withValues(alpha: 0.7)),
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Método separado para mostrar o seletor de data com tratamento de erro
  Future<void> _mostrarSeletorData(BuildContext context) async {
    try {
      final DateTime? data = await showDatePicker(
        context: context,
        initialDate: dataAvaliacao ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        helpText: 'Selecione o dia e mês da avaliação',
        cancelText: 'Cancelar',
        confirmText: 'OK',
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryRed,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
                brightness: Brightness.light,
              ),
              dialogBackgroundColor: Colors.white,
              textTheme: const TextTheme(
                headlineSmall: TextStyle(color: Colors.black87),
                bodyLarge: TextStyle(color: Colors.black87),
                bodyMedium: TextStyle(color: Colors.black87),
              ),
            ),
            child: child!,
          );
        },
      );

      if (data != null && context.mounted) {
        onDataChanged(data);
      }
    } catch (e, stackTrace) {
      debugPrint('Erro ao abrir seletor de data: $e');
      debugPrint('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao abrir seletor de data. Tente novamente.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Constrói campo de semana (calculado automaticamente)
  Widget _buildCampoSemana(BuildContext context) {
    const double fontSize = 14.0; // Tamanho de fonte fixo
    const double spacing = 8.0; // Espaçamento fixo
    const EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 14.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Semana do Ano',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
        ),
        const SizedBox(height: spacing),
        Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: Text(
            semanaAno != null ? 'Semana $semanaAno' : 'Automático',
            style: GoogleFonts.poppins(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.7),
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }

  /// Constrói dropdown de tipo de amostragem
  Widget _buildDropdownTipoAmostragem(BuildContext context) {
    const double fontSize = 14.0; // Tamanho de fonte fixo
    const double spacing = 8.0; // Espaçamento fixo
    const EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Amostragem *',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
        ),
        const SizedBox(height: spacing),
        DropdownButtonFormField<String>(
          value: tipoAmostragem,
          onChanged: (valor) {
            if (valor != null) {
              onTipoAmostragemChanged(valor);
            }
          },
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.15),
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
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
                width: 2,
              ),
            ),
            contentPadding: contentPadding,
          ),
          items: _tiposAmostragem.map((tipo) {
            return DropdownMenuItem(
              value: tipo,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  tipo,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
          isExpanded: true,
          iconEnabledColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
          dropdownColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.backgroundWhite.withValues(alpha: 0.95),
          menuMaxHeight: 300,
        ),
      ],
    );
  }

  /// Constrói campo de peso bruto
  Widget _buildCampoPeso(BuildContext context) {
    const double fontSize = 14.0; // Tamanho de fonte fixo
    const double spacing = 8.0; // Espaçamento fixo
    const EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Peso Bruto (kg) *',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
        ),
        const SizedBox(height: spacing),
        TextFormField(
          initialValue: pesoBruto?.toString(),
          onChanged: (text) {
            final peso = double.tryParse(text.replaceAll(',', '.'));
            onPesoBrutoChanged(peso);
          },
          validator: (text) {
            final peso = double.tryParse(text?.replaceAll(',', '.') ?? '');
            if (peso == null) {
              return 'Peso bruto é obrigatório';
            }
            if (peso <= 0) {
              return 'Peso deve ser maior que zero';
            }
            return null;
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.poppins(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : Colors.white,
          ),
          decoration: InputDecoration(
            hintText: 'Ex: 15.5',
            hintStyle: GoogleFonts.poppins(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.7),
            ),
            suffixText: 'kg',
            suffixStyle: GoogleFonts.poppins(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textDark.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.15),
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
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
                width: 2,
              ),
            ),
            contentPadding: contentPadding,
          ),
        ),
      ],
    );
  }
}
