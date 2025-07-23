import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/entities.dart';

/// Página para criar nova ficha de avaliação
class CriarFichaPage extends StatefulWidget {
  const CriarFichaPage({super.key});

  @override
  State<CriarFichaPage> createState() => _CriarFichaPageState();
}

class _CriarFichaPageState extends State<CriarFichaPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;

  // Controllers dos campos obrigatórios
  final _numeroFichaController = TextEditingController();
  final _clienteController = TextEditingController();
  final _fazendaController = TextEditingController();
  final _produtoController = TextEditingController();
  final _variedadeController = TextEditingController();
  final _origemController = TextEditingController();
  final _loteController = TextEditingController();
  final _pesoTotalController = TextEditingController();
  final _quantidadeAmostrasController = TextEditingController();
  final _responsavelAvaliacaoController = TextEditingController();

  // Controllers dos campos opcionais
  final _produtorResponsavelController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _observacaoAController = TextEditingController();
  final _observacaoBController = TextEditingController();
  final _observacaoCController = TextEditingController();
  final _observacaoDController = TextEditingController();
  final _observacaoFController = TextEditingController();
  final _observacaoGController = TextEditingController();

  DateTime _dataAvaliacao = DateTime.now();
  int _ano = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    // Gerar número da ficha automaticamente
    _numeroFichaController.text = _gerarNumeroFicha();
    _quantidadeAmostrasController.text = '7'; // Padrão A,B,C,D,E,F,G
  }

  String _gerarNumeroFicha() {
    final now = DateTime.now();
    return 'QF-${now.year}-${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(10)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Nova Ficha de Qualidade',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF16A34A) // darkGreen
            : const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Indicador de progresso
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF4CAF50),
            child: Column(
              children: [
                Text(
                  'Passo ${_currentPage + 1} de 3',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentPage + 1) / 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),

          // Conteúdo das páginas
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildDadosBasicosPage(),
                _buildDadosComplementaresPage(),
                _buildObservacoesPage(),
              ],
            ),
          ),

          // Botões de navegação
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousPage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF4CAF50)),
                      ),
                      child: Text(
                        'Anterior',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF4CAF50),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentPage == 2 ? _salvarFicha : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Salvar Ficha' : 'Próximo',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDadosBasicosPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados Básicos',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Informações obrigatórias da ficha',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            _buildTextField(
              controller: _numeroFichaController,
              label: 'Número da Ficha *',
              hint: 'QF-2025-001',
              validator: (value) =>
                  value?.isEmpty == true ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _clienteController,
              label: 'Cliente *',
              hint: 'Nome do cliente',
              validator: (value) =>
                  value?.isEmpty == true ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _fazendaController,
              label: 'Fazenda *',
              hint: 'Nome da fazenda - Cidade/Estado',
              validator: (value) =>
                  value?.isEmpty == true ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _produtoController,
                    label: 'Produto *',
                    hint: 'Ex: Uva, Manga',
                    validator: (value) =>
                        value?.isEmpty == true ? 'Campo obrigatório' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _variedadeController,
                    label: 'Variedade *',
                    hint: 'Ex: Thompson',
                    validator: (value) =>
                        value?.isEmpty == true ? 'Campo obrigatório' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _origemController,
              label: 'Origem *',
              hint: 'Local de origem',
              validator: (value) =>
                  value?.isEmpty == true ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _loteController,
              label: 'Lote *',
              hint: 'Identificação do lote',
              validator: (value) =>
                  value?.isEmpty == true ? 'Campo obrigatório' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDadosComplementaresPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados Complementares',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Informações técnicas da avaliação',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _pesoTotalController,
                  label: 'Peso Total (kg) *',
                  hint: '1500.5',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Campo obrigatório' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _quantidadeAmostrasController,
                  label: 'Qtd. Amostras *',
                  hint: '7',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Campo obrigatório' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _responsavelAvaliacaoController,
            label: 'Responsável pela Avaliação *',
            hint: 'Nome do inspetor',
            validator: (value) =>
                value?.isEmpty == true ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _produtorResponsavelController,
            label: 'Produtor Responsável',
            hint: 'Nome do produtor (opcional)',
          ),
          const SizedBox(height: 16),

          // Seletor de data
          InkWell(
            onTap: _selecionarData,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 12),
                  Text(
                    'Data da Avaliação: ${_dataAvaliacao.day}/${_dataAvaliacao.month}/${_dataAvaliacao.year}',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Seletor de ano
          DropdownButtonFormField<int>(
            value: _ano,
            decoration: InputDecoration(
              labelText: 'Ano da Safra *',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: List.generate(10, (index) {
              final year = DateTime.now().year - 5 + index;
              return DropdownMenuItem(
                value: year,
                child: Text(year.toString()),
              );
            }),
            onChanged: (value) => setState(() => _ano = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildObservacoesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Observações',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Observações específicas por amostra (A-G)',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          _buildTextField(
            controller: _observacoesController,
            label: 'Observações Gerais',
            hint: 'Observações sobre toda a avaliação',
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          Text(
            'Observações por Amostra',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _observacaoAController,
            label: 'Observação A',
            hint: 'Observações específicas da amostra A',
            maxLines: 2,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _observacaoBController,
            label: 'Observação B',
            hint: 'Observações específicas da amostra B',
            maxLines: 2,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _observacaoCController,
            label: 'Observação C',
            hint: 'Observações específicas da amostra C',
            maxLines: 2,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _observacaoDController,
            label: 'Observação D',
            hint: 'Observações específicas da amostra D',
            maxLines: 2,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _observacaoFController,
            label: 'Observação F',
            hint: 'Observações específicas da amostra F',
            maxLines: 2,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _observacaoGController,
            label: 'Observação G',
            hint: 'Observações específicas da amostra G',
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
    );
  }

  void _nextPage() {
    if (_currentPage == 0 && !_formKey.currentState!.validate()) {
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataAvaliacao,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (data != null) {
      setState(() => _dataAvaliacao = data);
    }
  }

  void _salvarFicha() {
    if (!_formKey.currentState!.validate()) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    // Criar a ficha
    final ficha = Ficha(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      numeroFicha: _numeroFichaController.text,
      dataAvaliacao: _dataAvaliacao,
      cliente: _clienteController.text,
      fazenda: _fazendaController.text,
      ano: _ano,
      produto: _produtoController.text,
      variedade: _variedadeController.text,
      origem: _origemController.text,
      lote: _loteController.text,
      pesoTotal: double.tryParse(_pesoTotalController.text) ?? 0.0,
      quantidadeAmostras: int.tryParse(_quantidadeAmostrasController.text) ?? 7,
      responsavelAvaliacao: _responsavelAvaliacaoController.text,
      produtorResponsavel: _produtorResponsavelController.text.isNotEmpty
          ? _produtorResponsavelController.text
          : null,
      observacoes: _observacoesController.text.isNotEmpty
          ? _observacoesController.text
          : 'Nova ficha criada',
      observacaoA: _observacaoAController.text.isNotEmpty
          ? _observacaoAController.text
          : null,
      observacaoB: _observacaoBController.text.isNotEmpty
          ? _observacaoBController.text
          : null,
      observacaoC: _observacaoCController.text.isNotEmpty
          ? _observacaoCController.text
          : null,
      observacaoD: _observacaoDController.text.isNotEmpty
          ? _observacaoDController.text
          : null,
      observacaoF: _observacaoFController.text.isNotEmpty
          ? _observacaoFController.text
          : null,
      observacaoG: _observacaoGController.text.isNotEmpty
          ? _observacaoGController.text
          : null,
      criadoEm: DateTime.now(),
    );

    // Mostrar diálogo de sucesso
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sucesso!'),
        content: Text('Ficha ${ficha.numeroFicha} criada com sucesso!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fechar diálogo
              Navigator.pop(context); // Voltar para home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _numeroFichaController.dispose();
    _clienteController.dispose();
    _fazendaController.dispose();
    _produtoController.dispose();
    _variedadeController.dispose();
    _origemController.dispose();
    _loteController.dispose();
    _pesoTotalController.dispose();
    _quantidadeAmostrasController.dispose();
    _responsavelAvaliacaoController.dispose();
    _produtorResponsavelController.dispose();
    _observacoesController.dispose();
    _observacaoAController.dispose();
    _observacaoBController.dispose();
    _observacaoCController.dispose();
    _observacaoDController.dispose();
    _observacaoFController.dispose();
    _observacaoGController.dispose();
    super.dispose();
  }
}
