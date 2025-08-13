import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/amostra_detalhada.dart';

/// ✅ ETAPA 3 - SEÇÃO 2: AMOSTRAS E DEFEITOS
///
/// Widget responsável pela segunda seção da ficha
/// Permite preencher 1 amostra por vez com todos os campos necessários
/// Agora com sistema dinâmico de adição/remoção de amostras
class SecaoAmostrasDefeitos extends StatefulWidget {
  final List<AmostraDetalhada> amostras;
  final String tipoAmostragem;
  final ValueChanged<AmostraDetalhada> onAmostraAtualizada;
  final VoidCallback onAdicionarAmostra;
  final VoidCallback onRemoverAmostra;

  const SecaoAmostrasDefeitos({
    super.key,
    required this.amostras,
    required this.tipoAmostragem,
    required this.onAmostraAtualizada,
    required this.onAdicionarAmostra,
    required this.onRemoverAmostra,
  });

  @override
  State<SecaoAmostrasDefeitos> createState() => _SecaoAmostrasDefeitosState();
}

class _SecaoAmostrasDefeitosState extends State<SecaoAmostrasDefeitos> {
  int _amostraAtualIndex = 0;
  late AmostraDetalhada _amostraAtual;

  // Armazena o valor do campo Baga no formato string (ex: "16-18")
  String? _bagaString;

  // Controllers para Brix (quantidade variável)
  final List<TextEditingController> _brixControllers = List.generate(
    20, // Máximo 20 para Cumbuca 250g
    (index) => TextEditingController(),
  );

  // Controllers para Peso Bruto (quantidade variável)
  final List<TextEditingController> _pesoBrutoControllers = List.generate(
    20, // Máximo 20 para Cumbuca 250g
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _amostraAtual = widget.amostras[_amostraAtualIndex];
    _inicializarControllers();
  }

  /// Retorna o valor de exibição para o campo Baga
  String? _getBagaDisplayValue() {
    return _bagaString;
  }

  @override
  void dispose() {
    for (final controller in _brixControllers) {
      controller.dispose();
    }
    for (final controller in _pesoBrutoControllers) {
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

    // Inicializar controllers de Peso Bruto com valores existentes
    final leiturasP = _amostraAtual.pesoBrutoLeituras ?? [];
    for (int i = 0; i < _pesoBrutoControllers.length; i++) {
      if (i < leiturasP.length) {
        _pesoBrutoControllers[i].text = leiturasP[i].toString();
      } else {
        _pesoBrutoControllers[i].clear();
      }
    }

    // Limpar o valor da baga para nova amostra (será preenchido pelo usuário)
    _bagaString = null;
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
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Detectar apenas swipes horizontais, não interferir com scroll vertical
        if (details.velocity.pixelsPerSecond.dx > 300) {
          // Swipe para direita (anterior)
          if (_amostraAtualIndex > 0) {
            _amostraAnterior();
          }
        } else if (details.velocity.pixelsPerSecond.dx < -300) {
          // Swipe para esquerda (próxima)
          if (_amostraAtualIndex < widget.amostras.length - 1) {
            _proximaAmostra();
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize
            .min, // Importante: não ocupar mais espaço que o necessário
        children: [
          // � CABEÇALHO COM NAVEGAÇÃO VISUAL
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
                const SizedBox(height: 8),
                Text(
                  '${_contarAmostrasPreenchidas()} de ${widget.amostras.length} amostras concluídas • Deslize para navegar',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔘 INDICADORES DE NAVEGAÇÃO POR PONTOS
                _buildIndicadoresNavegacao(),

                const SizedBox(height: 12),

                // 🔧 BOTÕES DE GERENCIAMENTO DE AMOSTRAS
                _buildBotoesGerenciamento(),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ⚙️ INFORMAÇÕES DA AMOSTRA
          _buildSecaoInformacoesAmostra(),

          const SizedBox(height: 16),

          // ⚖️ PESO BRUTO (MÚLTIPLAS LEITURAS)
          _buildSecaoPesoBruto(),

          const SizedBox(height: 16),

          // 📊 BRIX (10 LEITURAS)
          _buildSecaoBrix(),

          const SizedBox(height: 24),

          // 🦠 DEFEITOS
          _buildSecaoDefeitos(),

          const SizedBox(height: 32),

          // 🔢 NAVEGAÇÃO ENTRE AMOSTRAS (FINAL DA PÁGINA)
          _buildNavegacaoFinal(),
        ],
      ),
    );
  }

  Widget _buildSecaoInformacoesAmostra() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações da Amostra',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Sempre branco para labels
            ),
          ),
          const SizedBox(height: 16),

          // ROW 1: Classe
          _buildDropdown(
            label: 'Classe',
            value: _amostraAtual.classe,
            items: const ['Clamshell', 'Open', 'Sacola'],
            hint: 'Tipo de embalagem',
            onChanged: (valor) {
              _amostraAtual = _amostraAtual.copyWith(classe: valor);
            },
          ),

          const SizedBox(height: 16),

          // ROW 2: Área e Variedade
          Row(
            children: [
              Expanded(
                child: _buildCampoTexto(
                  label: 'Área',
                  value: _amostraAtual.area,
                  hint: 'Local de coleta',
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-ZÀ-ÿ0-9\s\-]'),
                    ),
                  ],
                  onChanged: (valor) {
                    _amostraAtual = _amostraAtual.copyWith(area: valor);
                  },
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

          // ROW 4: Aparência e Embalagem
          Row(
            children: [
              Expanded(
                child: _buildDropdownNumerico(
                  label: 'Aparência',
                  value: _amostraAtual.aparenciaCalibro0a7,
                  items: List.generate(8, (i) => i.toString()),
                  hint: '(0 - 7)',
                  onChanged: (valor) {
                    _amostraAtual = _amostraAtual.copyWith(
                      aparenciaCalibro0a7: valor,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownNumerico(
                  label: 'Embalagem',
                  value: _amostraAtual.aparenciaCalibro0a7, // Temporário
                  items: List.generate(8, (i) => i.toString()),
                  hint: '(0 - 7)',
                  onChanged: (valor) {
                    // Temporário - usar campo existente
                    _amostraAtual = _amostraAtual.copyWith(
                      aparenciaCalibro0a7: valor,
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ROW 5: Caixa/Marca (linha sozinha)
          _buildCampoTexto(
            label: 'Caixa / Marca',
            value: _amostraAtual.caixaMarca,
            hint: 'Identifique a embalagem',
            onChanged: (valor) {
              _amostraAtual = _amostraAtual.copyWith(caixaMarca: valor);
            },
          ),

          const SizedBox(height: 16),

          // ROW 6: Cor (linha sozinha)
          _buildDropdown(
            label: 'Cor',
            value: _amostraAtual.corUMD,
            items: const ['U', 'M', 'D'],
            hint: 'Uniforme / Mista / Desuniforme',
            onChanged: (valor) {
              _amostraAtual = _amostraAtual.copyWith(corUMD: valor);
            },
          ),

          const SizedBox(height: 16),

          // ROW 7: Peso da Embalagem e Peso Líquido (lado a lado)
          Row(
            children: [
              Expanded(
                child: _buildCampoNumericoComUnidade(
                  label: 'Peso da Embalagem',
                  value: _amostraAtual.pesoEmbalagem,
                  unidade: 'g',
                  onChanged: (valor) {
                    _amostraAtual = _amostraAtual.copyWith(
                      pesoEmbalagem: valor,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCampoNumericoComUnidade(
                  label: 'Peso Líquido',
                  value: _amostraAtual.pesoLiquido,
                  unidade: 'g',
                  onChanged: (valor) {
                    setState(() {
                      _amostraAtual = _amostraAtual.copyWith(
                        pesoLiquido: valor,
                      );
                    });
                    widget.onAmostraAtualizada(_amostraAtual);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ROW 8: Ø Baga
          _buildCampoTexto(
            label: 'Ø Baga',
            value: _getBagaDisplayValue(),
            hint: 'Formato: 16-18, 15-17, etc.',
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}-?\d{0,2}$')),
              _BagaFormatter(),
            ],
            onChanged: (valor) {
              // Só aceita se estiver no formato correto
              if (valor != null && RegExp(r'^\d+-\d+$').hasMatch(valor)) {
                // Armazena o valor como string no formato original
                _bagaString = valor;
                // Para fins de compatibilidade, calcula a média para bagaMm
                final partes = valor.split('-');
                final media = (int.parse(partes[0]) + int.parse(partes[1])) / 2;
                _amostraAtual = _amostraAtual.copyWith(bagaMm: media);
              } else if (valor == null || valor.isEmpty) {
                _bagaString = null;
                _amostraAtual = _amostraAtual.copyWith(bagaMm: null);
              }
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Constrói a seção de peso bruto com múltiplas leituras
  Widget _buildSecaoPesoBruto() {
    final quantidadeLeituras = _getQuantidadeLeiturasPesoBruto();

    return Card(
      margin: const EdgeInsets.all(0), // Forçar margin zero para debug
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // Não ocupar mais espaço que necessário
          children: [
            Text(
              'PESO BRUTO - $quantidadeLeituras Leituras (g)',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quantidade varia conforme tipo de amostragem',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Grid de campos de peso bruto
            GridView.builder(
              shrinkWrap: true, // Ajustar altura ao conteúdo
              physics:
                  const NeverScrollableScrollPhysics(), // Deixar scroll para o pai (SingleChildScrollView)
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
              ),
              itemCount: quantidadeLeituras,
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
                        controller: _pesoBrutoControllers[index],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          _DecimalFormatter(),
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '0.0',
                          suffixText: 'g',
                          suffixStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                        style: const TextStyle(fontSize: 12),
                        onChanged: (value) {
                          final peso = double.tryParse(value);
                          _atualizarPesoBruto(index, peso);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecaoBrix() {
    final quantidadeLeituras = _getQuantidadeLeiturasBrix();

    return Card(
      margin: const EdgeInsets.all(0), // Forçar margin zero para debug
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // Não ocupar mais espaço que necessário
          children: [
            Text(
              'BRIX - $quantidadeLeituras Leituras Manuais',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quantidade varia conforme tipo de amostragem',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Grid de campos de Brix
            GridView.builder(
              shrinkWrap: true, // Ajustar altura ao conteúdo
              physics:
                  const NeverScrollableScrollPhysics(), // Deixar scroll para o pai (SingleChildScrollView)
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
              ),
              itemCount: quantidadeLeituras,
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
                        inputFormatters: [
                          _DecimalFormatter(),
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '0.0',
                          suffixText: '°Bx',
                          suffixStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
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
          mainAxisSize:
              MainAxisSize.min, // Não ocupar mais espaço que necessário
          children: [
            Text(
              'Defeitos',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _obterTextoTipoContagem(),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Grid de defeitos (exceto Desgrane)
            ...FichaFisicaConstants.defeitosPrincipais
                .where((defeito) => defeito != 'Desgrane')
                .map((defeito) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildContadorDefeito(defeito),
                  );
                }),

            // Desgrane (%) - caso especial percentual
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildContadorDefeito('Desgrane'),
            ),

            // Cor da Baga (%) - caso especial
            const SizedBox(height: 8),
            _buildDropdownCorBaga(),

            // Observações da Amostra
            const SizedBox(height: 24),
            _buildCampoObservacoes(),
          ],
        ),
      ),
    );
  }

  Widget _buildContadorDefeito(String nomeDefeito) {
    final valor = _obterValorDefeito(nomeDefeito);

    // Desgrane é um campo percentual especial
    if (nomeDefeito == 'Desgrane') {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$nomeDefeito (%)',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey[800],
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: TextFormField(
              key: Key(
                'desgrane_${_amostraAtual.id}',
              ), // Key única para forçar reconstrução
              initialValue:
                  (_amostraAtual.desgranePercentual != null &&
                      _amostraAtual.desgranePercentual! > 0)
                  ? _amostraAtual.desgranePercentual!.toStringAsFixed(
                      _amostraAtual.desgranePercentual! % 1 == 0 ? 0 : 1,
                    )
                  : null,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              inputFormatters: [
                _PercentFormatter(),
              ],
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey[800],
              ),
              decoration: InputDecoration(
                hintText: '0-100%',
                suffixText: '%',
                suffixStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                isDense: true,
                errorText:
                    (_amostraAtual.desgranePercentual != null &&
                        (_amostraAtual.desgranePercentual! < 0 ||
                            _amostraAtual.desgranePercentual! > 100))
                    ? 'Valor deve estar entre 0 e 100'
                    : null,
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final numero = double.tryParse(value);
                  if (numero == null) {
                    return 'Digite um número válido';
                  }
                  if (numero < 0 || numero > 100) {
                    return 'Valor deve estar entre 0 e 100';
                  }
                }
                return null;
              },
              onChanged: (text) {
                if (text.isEmpty) {
                  setState(() {
                    _amostraAtual = _amostraAtual.copyWith(
                      desgranePercentual: 0.0,
                    );
                  });
                  return;
                }

                final novoValor = double.tryParse(text);
                if (novoValor != null) {
                  // Limita entre 0 e 100
                  final valorLimitado = novoValor.clamp(0.0, 100.0);
                  setState(() {
                    _amostraAtual = _amostraAtual.copyWith(
                      desgranePercentual: valorLimitado,
                    );
                  });

                  // Se o valor foi limitado, atualiza o campo
                  if (valorLimitado != novoValor) {
                    // Força a atualização do TextFormField para mostrar o valor limitado
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final controller = TextEditingController(
                        text: valorLimitado.toStringAsFixed(
                          valorLimitado % 1 == 0 ? 0 : 1,
                        ),
                      );
                      controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length),
                      );
                    });
                  }
                }
              },
            ),
          ),
        ],
      );
    }

    // Para outros defeitos, manter o contador normal
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            nomeDefeito,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey[800],
            ),
          ),
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
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey[800],
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
    const double fontSize = 14.0;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Cor da Baga (%)',
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors
                        .grey[800], // Cor escura para contraste com Card branco
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<double>(
            key: Key(
              'corBaga_${_amostraAtual.id}',
            ), // Key única para forçar reconstrução
            value: _amostraAtual.corBagaPercentual, // Usar campo existente
            onChanged: (valor) {
              _amostraAtual = _amostraAtual.copyWith(corBagaPercentual: valor);
            },
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            items: FichaFisicaConstants.opcoesCorBagaPercentual.map((
              percentual,
            ) {
              return DropdownMenuItem(
                value: percentual,
                child: Text(
                  '${percentual.toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
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
                ? Colors.grey.shade800
                : Colors.white,
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

      // Notificar o parent sobre a mudança
      widget.onAmostraAtualizada(_amostraAtual);
    });
  }

  // Widgets auxiliares
  Widget _buildCampoTexto({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
    required String hint,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    const double fontSize = 14.0;
    const double spacing = 8.0;
    const EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0,
    );

    // Determinar cor da borda baseada no preenchimento
    final bool isRequired = label.contains('*');
    final bool isFilled = value != null && value.trim().isNotEmpty;

    Color getBorderColor() {
      if (isFilled) {
        return Colors.green; // Verde quando preenchido
      } else if (isRequired) {
        return Colors.red; // Vermelho quando obrigatório e vazio
      } else {
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade600
            : Colors.grey.shade400;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Sempre branco para labels
          ),
        ),
        const SizedBox(height: spacing),
        TextFormField(
          key: Key(
            '${label}_${_amostraAtual.id}',
          ), // Key única para forçar reconstrução
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: getBorderColor(), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: getBorderColor(), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: contentPadding,
          ),
        ),
      ],
    );
  }

  Widget _buildCampoNumericoComUnidade({
    required String label,
    required double? value,
    required String unidade,
    required ValueChanged<double?> onChanged,
  }) {
    const double fontSize = 14.0;
    const double spacing = 8.0;
    const EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0,
    );

    // Determinar cor da borda baseada no preenchimento
    final bool isFilled = value != null && value > 0;

    Color getBorderColor() {
      if (isFilled) {
        return Colors.green; // Verde quando preenchido
      } else {
        return Colors.red; // Vermelho quando obrigatório e vazio
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Sempre branco para labels
          ),
        ),
        const SizedBox(height: spacing),
        TextFormField(
          key: Key(
            '${label}_${_amostraAtual.id}',
          ), // Key única para forçar reconstrução
          initialValue: value?.toString(),
          onChanged: (text) {
            final numero = double.tryParse(text.replaceAll(',', '.'));
            onChanged(numero);
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            _DecimalFormatter(),
          ],
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Digite o peso',
            suffixText: unidade,
            suffixStyle: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade300
                  : Colors.grey.shade700,
            ),
            hintStyle: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: getBorderColor(), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: getBorderColor(), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: contentPadding,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
  }) {
    const double fontSize = 14.0;
    const double spacing = 8.0;
    const EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0,
    );

    // Determinar cor da borda baseada no preenchimento
    final bool isFilled = value != null && value.isNotEmpty;

    Color getBorderColor() {
      if (isFilled) {
        return Colors.green; // Verde quando preenchido
      } else {
        return Colors.red; // Vermelho quando obrigatório e vazio
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Sempre branco para labels
          ),
        ),
        const SizedBox(height: spacing),
        DropdownButtonFormField<String>(
          key: Key(
            '${label}_${_amostraAtual.id}',
          ), // Key única para forçar reconstrução
          value: value,
          onChanged: onChanged,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: fontSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
            ),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: getBorderColor(), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: getBorderColor(), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: contentPadding,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
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
              ? Colors.grey.shade800
              : Colors.white,
        ),
      ],
    );
  }

  Widget _buildDropdownNumerico({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
  }) {
    return _buildDropdown(
      label: label,
      value: value,
      items: items,
      onChanged: onChanged,
      hint: hint,
    );
  }

  Widget _buildDropdownVariedade() {
    const double fontSize = 14.0;
    const double spacing = 8.0;
    const EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 12.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Variedade',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Sempre branco para labels
          ),
        ),
        const SizedBox(height: spacing),
        DropdownButtonFormField<String>(
          key: Key(
            'variedade_${_amostraAtual.id}',
          ), // Key única para forçar reconstrução
          value: _amostraAtual.variedade,
          onChanged: (valor) {
            _amostraAtual = _amostraAtual.copyWith(variedade: valor);
          },
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: contentPadding,
          ),
          items: FichaFisicaConstants.variedadesUva.map((variedade) {
            return DropdownMenuItem(
              value: variedade,
              child: Text(
                variedade,
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
              ? Colors.grey.shade800
              : Colors.white,
        ),
      ],
    );
  }

  // � BOTÕES DE GERENCIAMENTO DE AMOSTRAS
  Widget _buildBotoesGerenciamento() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Botão Remover Amostra (mínimo 1)
          ElevatedButton.icon(
            onPressed: widget.amostras.length > 1
                ? () {
                    // Se estamos na última amostra, volta para a anterior antes de remover
                    if (_amostraAtualIndex >= widget.amostras.length - 1 &&
                        _amostraAtualIndex > 0) {
                      _amostraAnterior();
                    }
                    widget.onRemoverAmostra();
                  }
                : null,
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            label: Text(
              'Remover',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red[700],
              backgroundColor: Colors.red[50],
              disabledForegroundColor: Colors.grey[400],
              disabledBackgroundColor: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Botão Adicionar Amostra (máximo 26 = A-Z)
          ElevatedButton.icon(
            onPressed: widget.amostras.length < 26
                ? () {
                    widget.onAdicionarAmostra();
                    // Navegar automaticamente para a nova amostra após adicionar
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _amostraAtualIndex = widget.amostras.length - 1;
                        _amostraAtual = widget.amostras[_amostraAtualIndex];
                        _inicializarControllers();
                      });
                    });
                  }
                : null,
            icon: const Icon(Icons.add_circle_outline, size: 20),
            label: Text(
              'Adicionar',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.green[700],
              backgroundColor: Colors.green[50],
              disabledForegroundColor: Colors.grey[400],
              disabledBackgroundColor: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // �🔘 INDICADORES DE NAVEGAÇÃO POR PONTOS
  Widget _buildIndicadoresNavegacao() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final larguraDisponivel = constraints.maxWidth - 32;
        final numeroAmostras = widget.amostras.length;

        // Tamanho fixo dos botões para melhor usabilidade
        const tamanhoAtivoIdeal = 48.0;
        const tamanhoInativoIdeal = 42.0;
        const espacamentoEntreButtons = 8.0;

        // Calcula quantos botões cabem por linha
        final larguraPorBotao = tamanhoAtivoIdeal + espacamentoEntreButtons;
        final botoesPorLinha = (larguraDisponivel / larguraPorBotao)
            .floor()
            .clamp(1, numeroAmostras);

        // Organiza os botões em linhas
        final linhas = <List<int>>[];
        for (int i = 0; i < numeroAmostras; i += botoesPorLinha) {
          final fimLinha = (i + botoesPorLinha).clamp(0, numeroAmostras);
          linhas.add(List.generate(fimLinha - i, (index) => i + index));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: linhas.map((botoesDaLinha) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: botoesDaLinha.map((index) {
                    final isAtual = index == _amostraAtualIndex;
                    final isPreenchida = _verificarAmostraPreenchida(index);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => _irParaAmostra(index),
                        child: Container(
                          width: isAtual
                              ? tamanhoAtivoIdeal
                              : tamanhoInativoIdeal,
                          height: isAtual
                              ? tamanhoAtivoIdeal
                              : tamanhoInativoIdeal,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getCorIndicador(isAtual, isPreenchida),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.9),
                              width: isAtual ? 3 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.amostras[index].letraAmostra,
                              style: GoogleFonts.poppins(
                                fontSize: isAtual ? 18.0 : 16.0,
                                fontWeight: isAtual
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  //  NAVEGAÇÃO FINAL SIMPLIFICADA (APENAS VOLTAR/PRÓXIMO)
  Widget _buildNavegacaoFinal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Seta para a esquerda
          IconButton(
            onPressed: _amostraAtualIndex > 0 ? _amostraAnterior : null,
            icon: Icon(Icons.arrow_back_ios, size: 20),
            style: IconButton.styleFrom(
              foregroundColor: _amostraAtualIndex > 0
                  ? Colors.green[700]
                  : Theme.of(context).disabledColor,
              backgroundColor: _amostraAtualIndex > 0
                  ? Colors.green[50]
                  : Colors.transparent,
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // Indicador da amostra atual
          Text(
            'Amostra ${_amostraAtualIndex + 1} de ${widget.amostras.length}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),

          // Seta para a direita
          IconButton(
            onPressed: _amostraAtualIndex < widget.amostras.length - 1
                ? _proximaAmostra
                : null,
            icon: Icon(Icons.arrow_forward_ios, size: 20),
            style: IconButton.styleFrom(
              foregroundColor: _amostraAtualIndex < widget.amostras.length - 1
                  ? Colors.green[700]
                  : Theme.of(context).disabledColor,
              backgroundColor: _amostraAtualIndex < widget.amostras.length - 1
                  ? Colors.green[50]
                  : Colors.transparent,
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares para navegação
  void _irParaAmostra(int index) {
    if (index != _amostraAtualIndex) {
      _salvarAmostraAtual();
      setState(() {
        _amostraAtualIndex = index;
        _amostraAtual = widget.amostras[index];
        _inicializarControllers();
      });
    }
  }

  bool _verificarAmostraPreenchida(int index) {
    final amostra = widget.amostras[index];

    // Verificar campos obrigatórios básicos
    final camposBasicosPreenchidos =
        (amostra.caixaMarca?.isNotEmpty == true) &&
        (amostra.classe?.isNotEmpty == true) &&
        (amostra.area?.isNotEmpty == true) &&
        (amostra.variedade?.isNotEmpty == true);

    // Verificar se tem pelo menos alguns pesos preenchidos (novos campos ou compatibilidade)
    final pesosPreenchidos =
        (amostra.pesoBrutoLeituras?.isNotEmpty == true) ||
        (amostra.pesoLiquido != null && amostra.pesoLiquido! > 0) ||
        (amostra.pesoEmbalagem != null && amostra.pesoEmbalagem! > 0) ||
        (amostra.pesoLiquidoKg != null &&
            amostra.pesoLiquidoKg! > 0); // Compatibilidade

    // Verificar se tem pelo menos algumas leituras de Brix
    final brixPreenchido =
        amostra.brixLeituras != null && amostra.brixLeituras!.isNotEmpty;

    // Amostra considerada preenchida se tem os campos básicos E (pesos OU brix)
    return camposBasicosPreenchidos && (pesosPreenchidos || brixPreenchido);
  }

  int _contarAmostrasPreenchidas() {
    int contador = 0;
    for (int i = 0; i < widget.amostras.length; i++) {
      if (_verificarAmostraPreenchida(i)) {
        contador++;
      }
    }
    return contador;
  }

  Color _getCorIndicador(bool isAtual, bool isPreenchida) {
    if (isAtual) {
      return Colors.orange[600]!.withValues(
        alpha: 0.8,
      ); // Laranja semi-transparente para amostra atual
    } else if (isPreenchida) {
      return Colors.green[600]!.withValues(
        alpha: 0.7,
      ); // Verde semi-transparente para preenchida
    } else {
      return Colors.white.withValues(
        alpha: 0.3,
      ); // Branco bem transparente para não preenchida
    }
  }

  /// Retorna a quantidade de leituras de peso bruto baseada no tipo de amostragem
  /// - Cumbuca 500g: 10 leituras
  /// - Cumbuca 250g: 20 leituras
  /// - Sacola (Caixa): 1 leitura
  int _getQuantidadeLeiturasPesoBruto() {
    switch (widget.tipoAmostragem) {
      case 'Cumbuca 500g':
        return 10;
      case 'Cumbuca 250g':
        return 20;
      case 'Sacola (Caixa)':
        return 1;
      default:
        return 10; // Default para Cumbuca 500g
    }
  }

  /// Retorna a quantidade de leituras de brix (sempre 10, independente do tipo)
  int _getQuantidadeLeiturasBrix() {
    return 10;
  }

  /// Atualiza o valor de peso bruto em um índice específico
  void _atualizarPesoBruto(int index, double? valor) {
    final leituras = List<double>.from(_amostraAtual.pesoBrutoLeituras ?? []);

    // Garante que a lista tenha o tamanho adequado
    while (leituras.length <= index) {
      leituras.add(0.0);
    }

    if (valor != null) {
      leituras[index] = valor;
    } else {
      leituras.removeAt(index);
    }

    final media = leituras.isNotEmpty
        ? leituras.fold(0.0, (sum, leitura) => sum + leitura) / leituras.length
        : null;

    setState(() {
      _amostraAtual = _amostraAtual.copyWith(
        pesoBrutoLeituras: leituras.isEmpty ? null : leituras,
        pesoBrutoMedia: media,
      );
    });
  }

  /// Constrói campo de observações para a amostra atual
  Widget _buildCampoObservacoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Observações da Amostra ${_amostraAtual.letraAmostra}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Adicione observações específicas desta amostra (opcional)',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[600]!
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: TextFormField(
            key: Key(
              'observacoes_${_amostraAtual.id}',
            ), // Key única para forçar reconstrução
            initialValue: _amostraAtual.observacoes ?? '',
            maxLines: 4,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'Digite observações sobre esta amostra...',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (valor) {
              setState(() {
                _amostraAtual = _amostraAtual.copyWith(
                  observacoes: valor.isEmpty ? null : valor,
                );
              });
              widget.onAmostraAtualizada(_amostraAtual);
            },
          ),
        ),
      ],
    );
  }
}

/// Formatador personalizado para campo Baga no formato "número-número"
class _BagaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Se está vazio, permite
    if (text.isEmpty) {
      return newValue;
    }

    // Remove caracteres não numéricos e hífen
    final cleaned = text.replaceAll(RegExp(r'[^\d-]'), '');

    // Se só tem números, adiciona hífen automaticamente após 2 dígitos
    if (!cleaned.contains('-') && cleaned.length > 2) {
      final formatted = '${cleaned.substring(0, 2)}-${cleaned.substring(2)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // Se já tem hífen, limita a 2 dígitos antes e 2 depois
    if (cleaned.contains('-')) {
      final parts = cleaned.split('-');
      if (parts.length == 2) {
        final primeiro = parts[0].length > 2
            ? parts[0].substring(0, 2)
            : parts[0];
        final segundo = parts[1].length > 2
            ? parts[1].substring(0, 2)
            : parts[1];
        final formatted = '$primeiro-$segundo';
        return TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }

    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  }
}

/// Formatador personalizado para números decimais que aceita tanto . quanto ,
class _DecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Se está vazio, permite
    if (text.isEmpty) {
      return newValue;
    }
    
    // Converte vírgula para ponto
    final normalizedText = text.replaceAll(',', '.');
    
    // Valida se é um número decimal válido
    if (RegExp(r'^\d*\.?\d*$').hasMatch(normalizedText)) {
      return TextEditingValue(
        text: normalizedText,
        selection: TextSelection.collapsed(offset: normalizedText.length),
      );
    }
    
    // Se não é válido, mantém o valor anterior
    return oldValue;
  }
}

/// Formatador para percentuais (0-100%) que aceita vírgula e ponto
class _PercentFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Se está vazio, permite
    if (text.isEmpty) {
      return newValue;
    }
    
    // Converte vírgula para ponto
    final normalizedText = text.replaceAll(',', '.');
    
    // Valida formato básico
    if (!RegExp(r'^\d{0,3}(\.\d{0,2})?$').hasMatch(normalizedText)) {
      return oldValue;
    }
    
    // Verifica se o número está dentro do limite (0-100)
    final numero = double.tryParse(normalizedText);
    if (numero != null && numero > 100) {
      return oldValue;
    }
    
    return TextEditingValue(
      text: normalizedText,
      selection: TextSelection.collapsed(offset: normalizedText.length),
    );
  }
}
