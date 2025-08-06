import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../responsive/responsive.dart';
import '../../core/theme/responsive_theme_extensions.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/salvar_ficha_usecase.dart';
import '../../data/repositories/ficha_repository_impl.dart';
import '../../data/datasources/local_datasource.dart';

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

  // === DEPENDÊNCIAS PARA SALVAR FICHA ===
  late final LocalDatasource _localDatasource;
  late final FichaRepositoryImpl _fichaRepository;
  late final SalvarFichaUseCase _salvarFichaUseCase;

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

    // === INICIALIZAR DEPENDÊNCIAS ===
    _localDatasource = LocalDatasource();
    _fichaRepository = FichaRepositoryImpl(_localDatasource);
    _salvarFichaUseCase = SalvarFichaUseCase(_fichaRepository);

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
    return ResponsiveScaffold(
      applySafeArea: false,
      centerContentOnTablet: true,
      tabletMaxContentWidth: 800.0,
      customPadding: EdgeInsets.zero,
      body: _buildContent(context),
      mobileBody: _buildMobileLayout(context),
      tabletBody: _buildTabletLayout(context),
    );
  }

  /// Conteúdo padrão (fallback)
  Widget _buildContent(BuildContext context) {
    return _buildMobileLayout(context);
  }

  /// Layout para dispositivos mobile
  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppColors.gradientDarkIntense
            : AppColors.gradientBrand,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context, isTablet: false),
          body: Column(
            children: [
              // Indicador de progresso
              _buildProgressIndicator(context, isTablet: false),

              // Conteúdo das páginas
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Desabilita deslizar
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    _buildDadosBasicosPage(isTablet: false),
                    _buildDadosComplementaresPage(isTablet: false),
                    _buildObservacoesPage(isTablet: false),
                  ],
                ),
              ),

              // Botões de navegação
              _buildNavigationButtons(context, isTablet: false),
            ],
          ),
        ),
      ),
    );
  }

  /// Layout para dispositivos tablet
  Widget _buildTabletLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppColors.gradientDarkIntense
            : AppColors.gradientBrand,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context, isTablet: true),
          body: ResponsivePadding(
            tablet: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 24.0,
            ),
            child: Column(
              children: [
                // Indicador de progresso
                _buildProgressIndicator(context, isTablet: true),

                SizedBox(height: ResponsiveThemeValues.sectionSpacing(context)),

                // Conteúdo das páginas
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics:
                        const NeverScrollableScrollPhysics(), // Desabilita deslizar
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    children: [
                      _buildDadosBasicosPage(isTablet: true),
                      _buildDadosComplementaresPage(isTablet: true),
                      _buildObservacoesPage(isTablet: true),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveThemeValues.elementSpacing(context)),

                // Botões de navegação
                _buildNavigationButtons(context, isTablet: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// AppBar responsiva
  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    bool isTablet = false,
  }) {
    return AppBar(
      title: Text(
        'Nova Ficha de Qualidade',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: ResponsiveUtils.responsiveValue(
            context,
            mobile: 18.0,
            tablet: 20.0,
          ),
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  /// Indicador de progresso responsivo
  Widget _buildProgressIndicator(
    BuildContext context, {
    bool isTablet = false,
  }) {
    return Container(
      padding: ResponsiveThemeValues.cardPadding(context),
      child: Column(
        children: [
          Text(
            'Passo ${_currentPage + 1} de 3',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: ResponsiveUtils.responsiveValue(
                context,
                mobile: 16.0,
                tablet: 18.0,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveThemeValues.elementSpacing(context) * 0.5),
          LinearProgressIndicator(
            value: (_currentPage + 1) / 3,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkRed
                  : AppColors.primaryRed,
            ),
            borderRadius: BorderRadius.circular(10),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  /// Botões de navegação responsivos
  Widget _buildNavigationButtons(
    BuildContext context, {
    bool isTablet = false,
  }) {
    return Container(
      padding: ResponsiveThemeValues.cardPadding(context),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.responsiveValue(
                      context,
                      mobile: 16.0,
                      tablet: 18.0,
                    ),
                  ),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Anterior',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtils.responsiveValue(
                      context,
                      mobile: 14.0,
                      tablet: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          if (_currentPage > 0)
            SizedBox(width: ResponsiveThemeValues.elementSpacing(context)),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentPage == 2 ? _salvarFicha : _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.responsiveValue(
                    context,
                    mobile: 16.0,
                    tablet: 18.0,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentPage == 2 ? 'Salvar Ficha' : 'Próximo',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtils.responsiveValue(
                    context,
                    mobile: 14.0,
                    tablet: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDadosBasicosPage({bool isTablet = false}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        ResponsiveUtils.responsiveValue(context, mobile: 16.0, tablet: 24.0),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados Básicos',
              style: GoogleFonts.poppins(
                fontSize: ResponsiveUtils.responsiveValue(
                  context,
                  mobile: 24.0,
                  tablet: 28.0,
                ),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: ResponsiveThemeValues.elementSpacing(context) * 0.5,
            ),
            Text(
              'Informações obrigatórias da ficha',
              style: GoogleFonts.poppins(
                fontSize: ResponsiveUtils.responsiveValue(
                  context,
                  mobile: 16.0,
                  tablet: 18.0,
                ),
                color: Colors.white.withValues(alpha: 0.9),
              ),
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

  Widget _buildDadosComplementaresPage({bool isTablet = false}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        ResponsiveUtils.responsiveValue(context, mobile: 16.0, tablet: 24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados Complementares',
            style: GoogleFonts.poppins(
              fontSize: ResponsiveUtils.responsiveValue(
                context,
                mobile: 24.0,
                tablet: 28.0,
              ),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveThemeValues.elementSpacing(context) * 0.5),
          Text(
            'Informações técnicas da avaliação',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
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
                  Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkGreen
                        : AppColors.positiveGreen,
                  ),
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

  Widget _buildObservacoesPage({bool isTablet = false}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        ResponsiveUtils.responsiveValue(context, mobile: 16.0, tablet: 24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Observações',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Observações específicas por amostra (A-G)',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
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
              color: Colors.white.withValues(alpha: 0.95),
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
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkGreen
                : AppColors.positiveGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkRed
                : AppColors.primaryRed,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkRed
                : AppColors.primaryRed,
            width: 2,
          ),
        ),
        errorStyle: GoogleFonts.poppins(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkRed
              : AppColors.primaryRed,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: validator != null
            ? Icon(
                Icons.star,
                size: 8,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
              )
            : null,
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  void _nextPage() {
    // Validação específica para cada página
    if (_currentPage == 0) {
      // Página 1: Dados Básicos - todos os campos são obrigatórios
      if (!_formKey.currentState!.validate()) {
        _mostrarDialogoValidacao(
          'Campos Obrigatórios',
          'Preencha todos os campos obrigatórios dos Dados Básicos para continuar.',
          Icons.warning_amber_rounded,
        );
        return;
      }
    } else if (_currentPage == 1) {
      // Página 2: Dados Complementares - validar campos obrigatórios
      if (_pesoTotalController.text.trim().isEmpty ||
          _quantidadeAmostrasController.text.trim().isEmpty ||
          _responsavelAvaliacaoController.text.trim().isEmpty) {
        _mostrarDialogoValidacao(
          'Campos Obrigatórios',
          'Preencha todos os campos obrigatórios dos Dados Complementares para continuar.',
          Icons.warning_amber_rounded,
        );
        return;
      }
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _mostrarDialogoValidacao(
    String titulo,
    String mensagem,
    IconData icone,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                icone,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  titulo,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            mensagem,
            style: GoogleFonts.poppins(fontSize: 16, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Entendi',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkRed
                      : AppColors.primaryRed,
                ),
              ),
            ),
          ],
        );
      },
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

  void _salvarFicha() async {
    // Validar campos obrigatórios manualmente (pois não estamos na página do Form)
    // Página 1: Dados Básicos
    if (_numeroFichaController.text.trim().isEmpty ||
        _clienteController.text.trim().isEmpty ||
        _fazendaController.text.trim().isEmpty ||
        _produtoController.text.trim().isEmpty ||
        _variedadeController.text.trim().isEmpty ||
        _origemController.text.trim().isEmpty ||
        _loteController.text.trim().isEmpty) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _mostrarDialogoValidacao(
        'Campos Obrigatórios',
        'Preencha todos os campos obrigatórios dos Dados Básicos para salvar a ficha.',
        Icons.warning_amber_rounded,
      );
      return;
    }

    // Página 2: Dados Complementares
    if (_pesoTotalController.text.trim().isEmpty ||
        _quantidadeAmostrasController.text.trim().isEmpty ||
        _responsavelAvaliacaoController.text.trim().isEmpty) {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _mostrarDialogoValidacao(
        'Campos Obrigatórios',
        'Preencha todos os campos obrigatórios dos Dados Complementares para salvar a ficha.',
        Icons.warning_amber_rounded,
      );
      return;
    }

    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Salvando ficha...',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ],
          ),
        ),
      );

      // Criar a ficha
      final ficha = Ficha(
        id: '', // O repository gerará o ID
        numeroFicha: _numeroFichaController.text.trim(),
        dataAvaliacao: _dataAvaliacao,
        cliente: _clienteController.text.trim(),
        fazenda: _fazendaController.text.trim(),
        ano: _ano,
        produto: _produtoController.text.trim(),
        variedade: _variedadeController.text.trim(),
        origem: _origemController.text.trim(),
        lote: _loteController.text.trim(),
        pesoTotal: double.tryParse(_pesoTotalController.text.trim()) ?? 0.0,
        quantidadeAmostras:
            int.tryParse(_quantidadeAmostrasController.text.trim()) ?? 7,
        responsavelAvaliacao: _responsavelAvaliacaoController.text.trim(),
        produtorResponsavel:
            _produtorResponsavelController.text.trim().isNotEmpty
            ? _produtorResponsavelController.text.trim()
            : null,
        observacoes: _observacoesController.text.trim().isNotEmpty
            ? _observacoesController.text.trim()
            : 'Nova ficha criada',
        observacaoA: _observacaoAController.text.trim().isNotEmpty
            ? _observacaoAController.text.trim()
            : null,
        observacaoB: _observacaoBController.text.trim().isNotEmpty
            ? _observacaoBController.text.trim()
            : null,
        observacaoC: _observacaoCController.text.trim().isNotEmpty
            ? _observacaoCController.text.trim()
            : null,
        observacaoD: _observacaoDController.text.trim().isNotEmpty
            ? _observacaoDController.text.trim()
            : null,
        observacaoF: _observacaoFController.text.trim().isNotEmpty
            ? _observacaoFController.text.trim()
            : null,
        observacaoG: _observacaoGController.text.trim().isNotEmpty
            ? _observacaoGController.text.trim()
            : null,
        criadoEm: DateTime.now(),
      );

      // === SALVAR NO BANCO DE DADOS ===
      final fichaSalva = await _salvarFichaUseCase.call(ficha);

      // Verificar se o widget ainda está montado
      if (!mounted) return;

      // Fechar loading
      Navigator.pop(context);

      // Mostrar diálogo de sucesso
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkGreen
                    : AppColors.positiveGreen,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Sucesso!',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Ficha ${fichaSalva.numeroFicha} salva com sucesso no banco de dados!\n\nID: ${fichaSalva.id}',
            style: GoogleFonts.poppins(fontSize: 16, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fechar diálogo
                Navigator.pop(context); // Voltar para home
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkGreen
                      : AppColors.positiveGreen,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // Verificar se o widget ainda está montado
      if (!mounted) return;

      // Fechar loading se estiver aberto
      Navigator.pop(context);

      // Mostrar erro
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_rounded,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkRed
                    : AppColors.primaryRed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Erro ao Salvar',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Ocorreu um erro ao salvar a ficha:\n\n${e.toString()}',
            style: GoogleFonts.poppins(fontSize: 16, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Tentar Novamente',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkRed
                      : AppColors.primaryRed,
                ),
              ),
            ),
          ],
        ),
      );
    }
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
