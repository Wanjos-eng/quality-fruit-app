import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/amostra_detalhada.dart';

/// ✅ ETAPA 3 - SEÇÃO 2: AMOSTRAS E DEFEITOS
///
/// Widget responsável pela segunda seção da ficha
/// Permite preencher 1 amostra por vez com todos os campos necessários
class SecaoAmostrasDefeitos extends StatefulWidget {
  final List<AmostraDetalhada> amostras;
  final String tipoAmostragem;
  final ValueChanged<AmostraDetalhada> onAmostraAtualizada;

  const SecaoAmostrasDefeitos({
    super.key,
    required this.amostras,
    required this.tipoAmostragem,
    required this.onAmostraAtualizada,
  });

  @override
  State<SecaoAmostrasDefeitos> createState() => _SecaoAmostrasDefeitosState();
}

class _SecaoAmostrasDefeitosState extends State<SecaoAmostrasDefeitos> {
  int _amostraAtualIndex = 0;
  late AmostraDetalhada _amostraAtual;

  // Controllers para Brix (10 leituras)
  final List<TextEditingController> _brixControllers = List.generate(
    10,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _amostraAtual = widget.amostras[_amostraAtualIndex];
    _inicializarControllers();
  }

  @override
  void dispose() {
    for (final controller in _brixControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _inicializarControllers() {
    // Inicializar controllers de Brix com valores existentes
    final leituras = _amostraAtual.brixLeituras ?? [];
    for (int i = 0; i < _brixControllers.length; i++) {
      if (i < leituras.length) {
        _brixControllers[i].text = leituras[i].toString();
      } else {
        _brixControllers[i].clear();
      }
    }
  }

  void _proximaAmostra() {
    _salvarAmostraAtual();
    if (_amostraAtualIndex < widget.amostras.length - 1) {
      setState(() {
        _amostraAtualIndex++;
        _amostraAtual = widget.amostras[_amostraAtualIndex];
        _inicializarControllers();
      });
    }
  }

  void _amostraAnterior() {
    _salvarAmostraAtual();
    if (_amostraAtualIndex > 0) {
      setState(() {
        _amostraAtualIndex--;
        _amostraAtual = widget.amostras[_amostraAtualIndex];
        _inicializarControllers();
      });
    }
  }

  void _salvarAmostraAtual() {
    // Coletar leituras de Brix
    final leiturasBrix = <double>[];
    for (final controller in _brixControllers) {
      final valor = double.tryParse(controller.text.replaceAll(',', '.'));
      if (valor != null) {
        leiturasBrix.add(valor);
      }
    }

    // Calcular Brix médio se temos pelo menos uma leitura
    double? brixMedio;
    if (leiturasBrix.isNotEmpty) {
      final soma = leiturasBrix.fold(0.0, (sum, valor) => sum + valor);
      brixMedio = soma / leiturasBrix.length;
    }

    final amostraAtualizada = _amostraAtual.copyWith(
      brixLeituras: leiturasBrix.isNotEmpty ? leiturasBrix : null,
      brixMedia: brixMedio, // Usando campo existente
      atualizadoEm: DateTime.now(),
    );

    widget.onAmostraAtualizada(amostraAtualizada);
  }

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
                'Amostra ${_amostraAtual.letraAmostra}',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_amostraAtualIndex + 1} de ${widget.amostras.length} amostras',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),

        // 🔢 NAVEGAÇÃO ENTRE AMOSTRAS
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _amostraAtualIndex > 0 ? _amostraAnterior : null,
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              label: Text(
                'Anterior',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: _amostraAtualIndex < widget.amostras.length - 1
                  ? _proximaAmostra
                  : null,
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 18,
              ),
              label: Text(
                'Próxima',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // ⚙️ INFORMAÇÕES DA AMOSTRA
        _buildSecaoInformacoesAmostra(),

        const SizedBox(height: 24),

        // 📊 BRIX (10 LEITURAS)
        _buildSecaoBrix(),

        const SizedBox(height: 24),

        // 🦠 DEFEITOS
        _buildSecaoDefeitos(),
      ],
    );
  }

  Widget _buildSecaoInformacoesAmostra() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações da Amostra',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),

            // ROW 1: Caixa/Marca e Classe
            Row(
              children: [
                Expanded(
                  child: _buildCampoTexto(
                    label: 'Caixa / Marca',
                    value: _amostraAtual.caixaMarca,
                    onChanged: (valor) {
                      _amostraAtual = _amostraAtual.copyWith(caixaMarca: valor);
                    },
                    hint: 'Identificação da embalagem',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Classe',
                    value: _amostraAtual.classe,
                    items: const ['Clamshell', 'Open', 'Sacola'],
                    onChanged: (valor) {
                      _amostraAtual = _amostraAtual.copyWith(classe: valor);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ROW 2: Área e Variedade
            Row(
              children: [
                Expanded(
                  child: _buildCampoTexto(
                    label: 'Área',
                    value: _amostraAtual.area,
                    onChanged: (valor) {
                      _amostraAtual = _amostraAtual.copyWith(area: valor);
                    },
                    hint: 'Local de coleta',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdownVariedade()),
              ],
            ),

            const SizedBox(height: 16),

            // ROW 3: Campos de validação
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Certa/Errada',
                    value: _amostraAtual.sacolaCumbuca,
                    items: const ['C', 'E'],
                    onChanged: (valor) {
                      _amostraAtual = _amostraAtual.copyWith(
                        sacolaCumbuca: valor,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Caixa Alta',
                    value: _amostraAtual.caixaCumbucaAlta,
                    items: const ['S', 'N'],
                    onChanged: (valor) {
                      _amostraAtual = _amostraAtual.copyWith(
                        caixaCumbucaAlta: valor,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ROW 4: Aparência, Embalagem e Cor
            Row(
              children: [
                Expanded(
                  child: _buildDropdownNumerico(
                    label: 'Aparência (0-7)',
                    value: _amostraAtual.aparenciaCalibro0a7,
                    items: List.generate(8, (i) => i.toString()),
                    onChanged: (valor) {
                      _amostraAtual = _amostraAtual.copyWith(
                        aparenciaCalibro0a7: valor,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownNumerico(
                    label: 'Embalagem (0-7)',
                    value: _amostraAtual.aparenciaCalibro0a7, // Temporário
                    items: List.generate(8, (i) => i.toString()),
                    onChanged: (valor) {
                      // Temporário - usar campo existente
                      _amostraAtual = _amostraAtual.copyWith(
                        aparenciaCalibro0a7: valor,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: 'Cor',
                    value: _amostraAtual.corUMD,
                    items: const ['U', 'M', 'D'],
                    onChanged: (valor) {
                      _amostraAtual = _amostraAtual.copyWith(corUMD: valor);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ROW 5: Pesos
            Row(
              children: [
                Expanded(
                  child: _buildCampoNumerico(
                    label: 'Peso com Embalagem (kg)',
                    value: _amostraAtual
                        .pesoEmbalagem, // Temporário - usar campo existente
                    onChanged: (valor) {
                      _amostraAtual = _amostraAtual.copyWith(
                        pesoEmbalagem: valor,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCampoNumerico(
                    label: 'Peso Líquido (kg)',
                    value: _amostraAtual.pesoLiquidoKg,
                    onChanged: (valor) {
                      _amostraAtual = _amostraAtual.copyWith(
                        pesoLiquidoKg: valor,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ROW 6: Ø Baga
            _buildCampoTexto(
              label: 'Ø Baga (mm)',
              value: _amostraAtual.bagaMm?.toString(),
              onChanged: (valor) {
                final baga = double.tryParse(valor ?? '');
                _amostraAtual = _amostraAtual.copyWith(bagaMm: baga);
              },
              hint: 'Ex: 16-18',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecaoBrix() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BRIX - 10 Leituras Manuais',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),

            // Grid de 10 campos de Brix
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(
                      '${index + 1}°',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: TextFormField(
                        controller: _brixControllers[index],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          hintText: '0.0',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // Brix Médio Calculado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.calculate, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Brix Médio: ${_calcularBrixMedio()?.toStringAsFixed(2) ?? "--"}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecaoDefeitos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Defeitos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _obterTextoTipoContagem(),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Grid de defeitos
            ...FichaFisicaConstants.defeitosPrincipais.map((defeito) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildContadorDefeito(defeito),
              );
            }),

            // Cor da Baga (%) - caso especial
            const SizedBox(height: 8),
            _buildDropdownCorBaga(),
          ],
        ),
      ),
    );
  }

  Widget _buildContadorDefeito(String nomeDefeito) {
    final valor = _obterValorDefeito(nomeDefeito);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(nomeDefeito, style: const TextStyle(fontSize: 14)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _alterarDefeito(nomeDefeito, -1),
              icon: const Icon(Icons.remove_circle_outline),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                valor.toStringAsFixed(valor % 1 == 0 ? 0 : 1),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _alterarDefeito(nomeDefeito, 1),
              icon: const Icon(Icons.add_circle_outline),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownCorBaga() {
    return Row(
      children: [
        const Expanded(
          flex: 3,
          child: Text(
            'Cor da Baga (%)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<double>(
            value: _amostraAtual.corBagaPercentual, // Usar campo existente
            onChanged: (valor) {
              _amostraAtual = _amostraAtual.copyWith(corBagaPercentual: valor);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
            ),
            items: FichaFisicaConstants.opcoesCorBagaPercentual.map((
              percentual,
            ) {
              return DropdownMenuItem(
                value: percentual,
                child: Text('${percentual.toInt()}%'),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Métodos auxiliares
  double? _calcularBrixMedio() {
    final leituras = <double>[];
    for (final controller in _brixControllers) {
      final valor = double.tryParse(controller.text.replaceAll(',', '.'));
      if (valor != null) {
        leituras.add(valor);
      }
    }

    if (leituras.isEmpty) return null;
    return leituras.fold(0.0, (sum, valor) => sum + valor) / leituras.length;
  }

  String _obterTextoTipoContagem() {
    switch (widget.tipoAmostragem) {
      case 'CUMBUCA_500':
      case 'CUMBUCA_250':
        return 'Contagem: quantas cumbucas apresentaram o defeito';
      case 'SACOLA':
        return 'Contagem: quantidade real encontrada na amostra';
      default:
        return 'Contagem de defeitos';
    }
  }

  double _obterValorDefeito(String nomeDefeito) {
    switch (nomeDefeito) {
      case 'Teia de Aranha':
        return _amostraAtual.teiaAranha ?? 0;
      case 'Aranha':
        return _amostraAtual.aranha ?? 0;
      case 'Amassada':
        return _amostraAtual.amassada ?? 0;
      case 'Aquosa':
        return _amostraAtual.aquosaCorBaga ?? 0; // Usar campo existente
      case 'Cacho duro':
        return _amostraAtual.cachoDuro ?? 0;
      case 'Cacho ralo / banguelo':
        return _amostraAtual.cachoRaloBanguelo ?? 0;
      case 'Cicatriz':
        return _amostraAtual.cicatriz ?? 0;
      case 'Corpo estranho':
        return _amostraAtual.corpoEstranho ?? 0;
      case 'Desgrane':
        return _amostraAtual.desgranePercentual ?? 0;
      case 'Mosca da fruta':
        return _amostraAtual.moscaFruta ?? 0;
      case 'Murcha':
        return _amostraAtual.murcha ?? 0;
      case 'Oídio':
        return _amostraAtual.oidio ?? 0;
      case 'Podre':
        return _amostraAtual.podre ?? 0;
      case 'Queimado sol':
        return _amostraAtual.queimadoSol ?? 0;
      case 'Rachada':
        return _amostraAtual.rachada ?? 0;
      case 'Sacarose':
        return _amostraAtual.sacarose ?? 0;
      case 'Translúcido':
        return _amostraAtual.translucido ?? 0;
      case 'Glomerella':
        return _amostraAtual.glomerella ?? 0;
      case 'Traça':
        return _amostraAtual.traca ?? 0;
      default:
        return 0;
    }
  }

  void _alterarDefeito(String nomeDefeito, int incremento) {
    final valorAtual = _obterValorDefeito(nomeDefeito);
    final novoValor = (valorAtual + incremento).clamp(0.0, double.infinity);

    setState(() {
      switch (nomeDefeito) {
        case 'Teia de Aranha':
          _amostraAtual = _amostraAtual.copyWith(teiaAranha: novoValor);
          break;
        case 'Aranha':
          _amostraAtual = _amostraAtual.copyWith(aranha: novoValor);
          break;
        case 'Amassada':
          _amostraAtual = _amostraAtual.copyWith(amassada: novoValor);
          break;
        case 'Aquosa':
          _amostraAtual = _amostraAtual.copyWith(
            aquosaCorBaga: novoValor,
          ); // Usar campo existente
          break;
        case 'Cacho duro':
          _amostraAtual = _amostraAtual.copyWith(cachoDuro: novoValor);
          break;
        case 'Cacho ralo / banguelo':
          _amostraAtual = _amostraAtual.copyWith(cachoRaloBanguelo: novoValor);
          break;
        case 'Cicatriz':
          _amostraAtual = _amostraAtual.copyWith(cicatriz: novoValor);
          break;
        case 'Corpo estranho':
          _amostraAtual = _amostraAtual.copyWith(corpoEstranho: novoValor);
          break;
        case 'Desgrane':
          _amostraAtual = _amostraAtual.copyWith(desgranePercentual: novoValor);
          break;
        case 'Mosca da fruta':
          _amostraAtual = _amostraAtual.copyWith(moscaFruta: novoValor);
          break;
        case 'Murcha':
          _amostraAtual = _amostraAtual.copyWith(murcha: novoValor);
          break;
        case 'Oídio':
          _amostraAtual = _amostraAtual.copyWith(oidio: novoValor);
          break;
        case 'Podre':
          _amostraAtual = _amostraAtual.copyWith(podre: novoValor);
          break;
        case 'Queimado sol':
          _amostraAtual = _amostraAtual.copyWith(queimadoSol: novoValor);
          break;
        case 'Rachada':
          _amostraAtual = _amostraAtual.copyWith(rachada: novoValor);
          break;
        case 'Sacarose':
          _amostraAtual = _amostraAtual.copyWith(sacarose: novoValor);
          break;
        case 'Translúcido':
          _amostraAtual = _amostraAtual.copyWith(translucido: novoValor);
          break;
        case 'Glomerella':
          _amostraAtual = _amostraAtual.copyWith(glomerella: novoValor);
          break;
        case 'Traça':
          _amostraAtual = _amostraAtual.copyWith(traca: novoValor);
          break;
      }
    });
  }

  // Widgets auxiliares
  Widget _buildCampoTexto({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCampoNumerico({
    required String label,
    required double? value,
    required ValueChanged<double?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value?.toString(),
          onChanged: (text) {
            final numero = double.tryParse(text.replaceAll(',', '.'));
            onChanged(numero);
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownNumerico({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return _buildDropdown(
      label: label,
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownVariedade() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Variedade',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _amostraAtual.variedade,
          onChanged: (valor) {
            _amostraAtual = _amostraAtual.copyWith(variedade: valor);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
          items: FichaFisicaConstants.variedadesUva.map((variedade) {
            return DropdownMenuItem(value: variedade, child: Text(variedade));
          }).toList(),
        ),
      ],
    );
  }
}
