import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/amostra_detalhada.dart';
import '../widgets/secao_informacoes_gerais.dart';
import '../widgets/secao_amostras_defeitos.dart';
import '../widgets/secao_observacoes_finais.dart';

/// ✅ PÁGINA PRINCIPAL - CRIAR FICHA DE QUALIDADE
///
/// Página responsável por criar uma nova ficha de qualidade
/// Gerencia navegação entre as 3 seções e estado global da ficha
class CriarFichaPage extends StatefulWidget {
  final String? fichaId;

  const CriarFichaPage({super.key, this.fichaId});

  @override
  State<CriarFichaPage> createState() => _CriarFichaPageState();
}

class _CriarFichaPageState extends State<CriarFichaPage> {
  // ⚙️ CONTROLE DE NAVEGAÇÃO ENTRE SEÇÕES
  int _etapaAtual = 0; // 0=Informações Gerais, 1=Amostras, 2=Observações

  // ⚙️ ESTADO GLOBAL DA FICHA
  String _tipoAmostragem = 'Cumbuca 500g'; // Padrão inicial
  final List<AmostraDetalhada> _amostras = [];

  // ⚙️ DADOS DA SEÇÃO 1 (Informações Gerais)
  final _formKey = GlobalKey<FormState>();
  late String _fichaId;
  int? _ano = DateTime.now().year; // Ano atual como padrão
  String? _fazenda;
  DateTime? _dataAvaliacao;
  int? _semanaAno;
  String? _inspetor;

  // ⚙️ OBSERVAÇÕES FINAIS (Seção 3)
  final Map<String, String> _observacoesPorAmostra = {};

  @override
  void initState() {
    super.initState();
    _fichaId =
        widget.fichaId ?? DateTime.now().millisecondsSinceEpoch.toString();
    _gerarAmostrasIniciais();
  }

  /// Gera amostra inicial (sempre começa com apenas uma amostra A)
  void _gerarAmostrasIniciais() {
    _amostras.clear();
    _observacoesPorAmostra.clear();

    // Sempre começar com uma única amostra A
    _amostras.add(
      AmostraDetalhada(
        id: '${_fichaId}_A',
        fichaId: _fichaId,
        letraAmostra: 'A',
        criadoEm: DateTime.now(),
      ),
    );

    // Inicializar observação vazia para a amostra A
    _observacoesPorAmostra['A'] = '';
  }

  /// Adiciona uma nova amostra
  void _adicionarAmostra() {
    setState(() {
      final proximaLetra = String.fromCharCode(
        65 + _amostras.length,
      ); // A=65, B=66, etc.

      _amostras.add(
        AmostraDetalhada(
          id: '${_fichaId}_$proximaLetra',
          fichaId: _fichaId,
          letraAmostra: proximaLetra,
          criadoEm: DateTime.now(),
        ),
      );

      // Inicializar observação vazia para esta amostra
      _observacoesPorAmostra[proximaLetra] = '';
    });
  }

  /// Remove a última amostra (mínimo 1 amostra)
  void _removerAmostra() {
    if (_amostras.length > 1) {
      setState(() {
        final ultimaAmostra = _amostras.removeLast();
        _observacoesPorAmostra.remove(ultimaAmostra.letraAmostra);
      });
    }
  }

  void _atualizarTipoAmostragem(String novoTipo) {
    setState(() {
      _tipoAmostragem = novoTipo;
      // NÃO regenera amostras - apenas atualiza o tipo que afeta apenas peso bruto
    });
  }

  /// Navega para a próxima etapa
  void _proximaEtapa() {
    if (_etapaAtual < 2) {
      setState(() {
        _etapaAtual++;
      });
    }
  }

  /// Volta para a etapa anterior
  void _etapaAnterior() {
    if (_etapaAtual > 0) {
      setState(() {
        _etapaAtual--;
      });
    }
  }

  /// Verifica se pode avançar para próxima etapa
  bool _podeAvancar() {
    switch (_etapaAtual) {
      case 0: // Informações Gerais
        return _ano != null &&
            _fazenda != null &&
            _dataAvaliacao != null &&
            _inspetor != null;
      case 1: // Amostras
        return _amostras.every((amostra) => amostra.temDadosMinimos);
      case 2: // Observações
        return true; // Sempre pode finalizar
      default:
        return false;
    }
  }

  /// Obter título da etapa atual
  String _obterTituloEtapa() {
    switch (_etapaAtual) {
      case 0:
        return 'SEÇÃO 1: Informações Gerais';
      case 1:
        return 'SEÇÃO 2: Amostras e Defeitos';
      case 2:
        return 'SEÇÃO 3: Observações Finais';
      default:
        return 'Criar Ficha de Qualidade';
    }
  }

  /// Obter widget da seção atual
  Widget _obterSecaoAtual() {
    switch (_etapaAtual) {
      case 0:
        return SecaoInformacoesGerais(
          formKey: _formKey,
          ano: _ano,
          fazenda: _fazenda,
          dataAvaliacao: _dataAvaliacao,
          semanaAno: _semanaAno,
          inspetor: _inspetor,
          tipoAmostragem: _tipoAmostragem,
          onAnoChanged: (valor) {
            setState(() {
              _ano = valor;
              // Recalcular semana do ano se já temos data e ano
              if (_dataAvaliacao != null && valor != null) {
                _semanaAno = _calcularSemanaAno(_dataAvaliacao!, valor);
              }
            });
          },
          onFazendaChanged: (valor) => setState(() => _fazenda = valor),
          onDataChanged: (valor) {
            setState(() {
              _dataAvaliacao = valor;
              // Calcular semana do ano automaticamente usando o ano selecionado
              if (valor != null && _ano != null) {
                _semanaAno = _calcularSemanaAno(valor, _ano!);
              }
            });
          },
          onInspetorChanged: (valor) => setState(() => _inspetor = valor),
          onTipoAmostragemChanged: _atualizarTipoAmostragem,
        );
      case 1:
        return SecaoAmostrasDefeitos(
          amostras: _amostras,
          tipoAmostragem: _tipoAmostragem,
          onAmostraAtualizada: (amostra) {
            setState(() {
              final index = _amostras.indexWhere((a) => a.id == amostra.id);
              if (index >= 0) {
                _amostras[index] = amostra;
              }
            });
          },
          onAdicionarAmostra: _adicionarAmostra,
          onRemoverAmostra: _removerAmostra,
        );
      case 2:
        return SecaoObservacaoFinais(
          amostras: _amostras,
          observacoesPorAmostra: _observacoesPorAmostra,
          onObservacaoChanged: (letra, observacao) {
            setState(() {
              _observacoesPorAmostra[letra] = observacao;
            });
          },
        );
      default:
        return const Center(child: Text('Seção não encontrada'));
    }
  }

  /// Calcula a semana do ano baseada na data e ano selecionado
  int _calcularSemanaAno(DateTime data, int anoSelecionado) {
    // Criar data com o ano selecionado, mas dia/mês da data informada
    final dataComAnoSelecionado = DateTime(
      anoSelecionado,
      data.month,
      data.day,
    );
    final inicioAno = DateTime(anoSelecionado, 1, 1);
    final diferenca = dataComAnoSelecionado.difference(inicioAno).inDays;
    return (diferenca / 7).ceil();
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
          child: Column(
            children: [
              // 📱 HEADER SIMPLES COM TÍTULO
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _obterTituloEtapa(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 📊 INDICADOR DE PROGRESSO MINIMALISTA
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    for (int i = 0; i <= 2; i++) ...[
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: i <= _etapaAtual
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      if (i < 2) const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),

              // 📋 CONTEÚDO DA SEÇÃO
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  child: _obterSecaoAtual(),
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔘 BOTÕES FLUTUANTES NA PARTE INFERIOR
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Botão Voltar
            if (_etapaAtual > 0) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _etapaAnterior,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: Text(
                    'Voltar',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.8),
                      width: 2,
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Botão Próxima/Finalizar
            Expanded(
              flex: _etapaAtual > 0 ? 2 : 1,
              child: ElevatedButton.icon(
                onPressed: _podeAvancar()
                    ? () {
                        if (_etapaAtual == 2) {
                          _finalizarFicha();
                        } else {
                          _proximaEtapa();
                        }
                      }
                    : null,
                icon: Icon(
                  _etapaAtual == 2 ? Icons.check_circle : Icons.arrow_forward,
                  size: 20,
                ),
                label: Text(
                  _etapaAtual == 2 ? 'Finalizar' : 'Próxima',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
                  disabledForegroundColor: Colors.grey[400],
                  elevation: 3,
                  shadowColor: Colors.black.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Finaliza e salva a ficha completa
  void _finalizarFicha() {
    // Implementar salvamento e geração de PDF na ETAPA 7
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Ficha finalizada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }
}
