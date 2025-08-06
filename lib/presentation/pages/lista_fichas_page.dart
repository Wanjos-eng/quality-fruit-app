import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../responsive/responsive.dart';
import '../../core/theme/responsive_theme_extensions.dart';
import '../../domain/entities/entities.dart';

/// Página para listar todas as fichas criadas
class ListaFichasPage extends StatefulWidget {
  const ListaFichasPage({super.key});

  @override
  State<ListaFichasPage> createState() => _ListaFichasPageState();
}

class _ListaFichasPageState extends State<ListaFichasPage> {
  List<Ficha> _fichas = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _carregarFichas();
  }

  Future<void> _carregarFichas() async {
    // Simular carregamento - aqui seria a chamada para o repository
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _fichas = _gerarFichasExemplo();
      _isLoading = false;
    });
  }

  List<Ficha> _gerarFichasExemplo() {
    // Gerar algumas fichas de exemplo
    return [
      Ficha(
        id: '1',
        numeroFicha: 'QF-2025-001',
        dataAvaliacao: DateTime.now().subtract(const Duration(days: 1)),
        cliente: 'Exportadora São Paulo',
        fazenda: 'Fazenda São José - Franca/SP',
        ano: 2025,
        produto: 'Uva',
        variedade: 'Thompson Seedless',
        origem: 'São Paulo - Brasil',
        lote: 'SP-2025-001',
        pesoTotal: 1500.5,
        quantidadeAmostras: 7,
        responsavelAvaliacao: 'João Silva',
        observacoes: 'Primeira avaliação da safra 2025',
        criadoEm: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Ficha(
        id: '2',
        numeroFicha: 'QF-2025-002',
        dataAvaliacao: DateTime.now().subtract(const Duration(days: 3)),
        cliente: 'Importadora Rio',
        fazenda: 'Fazenda Nossa Senhora - Ribeirão Preto/SP',
        ano: 2025,
        produto: 'Manga',
        variedade: 'Tommy Atkins',
        origem: 'São Paulo - Brasil',
        lote: 'RP-2025-001',
        pesoTotal: 2300.0,
        quantidadeAmostras: 5,
        responsavelAvaliacao: 'Maria Santos',
        observacoes: 'Qualidade excelente',
        criadoEm: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  List<Ficha> get _fichasFiltradas {
    if (_searchQuery.isEmpty) return _fichas;

    return _fichas
        .where(
          (ficha) =>
              ficha.numeroFicha.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              ficha.cliente.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              ficha.produto.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              ficha.fazenda.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      // === CONFIGURAÇÕES RESPONSIVAS ===
      applySafeArea: true,
      centerContentOnTablet: true,
      tabletMaxContentWidth: 1000.0,
      customPadding: EdgeInsets.zero,
      // === BODY RESPONSIVO ===
      body: _buildContent(context),
      mobileBody: _buildMobileLayout(context),
      tabletBody: _buildTabletLayout(context),
    );
  }

  /// Header flutuante integrado ao gradiente
  Widget _buildFloatingHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveThemeValues.elementSpacing(context)),
      child: Row(
        children: [
          // Botão de voltar
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: ResponsiveUtils.responsiveValue(
                context,
                mobile: 24.0,
                tablet: 26.0,
              ),
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          // Título
          Expanded(
            child: Text(
              'Minhas Fichas',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.responsiveValue(
                  context,
                  mobile: 24.0,
                  tablet: 28.0,
                ),
                color: Colors.white,
              ),
            ),
          ),
          // Botões de ação
          IconButton(
            icon: Icon(
              Icons.search,
              size: ResponsiveUtils.responsiveValue(
                context,
                mobile: 24.0,
                tablet: 26.0,
              ),
              color: Colors.white,
            ),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              size: ResponsiveUtils.responsiveValue(
                context,
                mobile: 24.0,
                tablet: 26.0,
              ),
              color: Colors.white,
            ),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
    );
  }

  /// Conteúdo padrão (fallback para mobile)
  Widget _buildContent(BuildContext context) {
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
              // Header flutuante
              _buildFloatingHeader(context),
              // Conteúdo principal
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkGreen
                              : AppColors.positiveGreen,
                        ),
                      )
                    : _fichasFiltradas.isEmpty
                    ? _buildEmptyState()
                    : _buildListaFichas(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Layout para dispositivos mobile
  Widget _buildMobileLayout(BuildContext context) {
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
              // Header flutuante
              _buildFloatingHeader(context),
              // Conteúdo principal
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkGreen
                              : AppColors.positiveGreen,
                        ),
                      )
                    : _fichasFiltradas.isEmpty
                    ? _buildEmptyState()
                    : _buildListaFichas(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Layout para dispositivos tablet
  Widget _buildTabletLayout(BuildContext context) {
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
              // Header flutuante
              _buildFloatingHeader(context),
              // Conteúdo principal
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveThemeValues.elementSpacing(context),
                    vertical:
                        ResponsiveThemeValues.elementSpacing(context) * 0.5,
                  ),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkGreen
                                : AppColors.positiveGreen,
                          ),
                        )
                      : _fichasFiltradas.isEmpty
                      ? _buildEmptyState()
                      : _buildTabletGridLayout(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// FloatingActionButton responsivo
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/criar-ficha'),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkGreen
          : AppColors.positiveGreen,
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: ResponsiveUtils.responsiveValue(
          context,
          mobile: 24.0,
          tablet: 28.0,
        ),
      ),
    );
  }

  /// Layout em grid para tablets
  Widget _buildTabletGridLayout() {
    return GridView.builder(
      padding: EdgeInsets.all(ResponsiveThemeValues.elementSpacing(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ResponsiveThemeValues.elementSpacing(context),
        mainAxisSpacing: ResponsiveThemeValues.elementSpacing(context),
        childAspectRatio: 1.5,
      ),
      itemCount: _fichasFiltradas.length,
      itemBuilder: (context, index) {
        final ficha = _fichasFiltradas[index];
        return _buildFichaCardTablet(ficha);
      },
    );
  }

  /// Card otimizado para tablets
  Widget _buildFichaCardTablet(Ficha ficha) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.cardDark
          : Colors.white,
      child: InkWell(
        onTap: () => _abrirDetalhes(ficha),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveThemeValues.elementSpacing(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header compacto
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkGreen
                          : AppColors.positiveGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ficha.numeroFicha,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _showOptionsMenu(ficha),
                    icon: const Icon(Icons.more_vert),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark.withValues(alpha: 0.7)
                        : Colors.grey[600],
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                  ),
                ],
              ),
              SizedBox(
                height: ResponsiveThemeValues.elementSpacing(context) * 0.5,
              ),

              // Informações principais
              Text(
                ficha.cliente,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textDark
                      : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${ficha.produto} - ${ficha.variedade}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkGreen
                      : AppColors.positiveGreen,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),

              // Footer compacto
              Row(
                children: [
                  Text(
                    '${ficha.pesoTotal.toStringAsFixed(1)}kg',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkGreen
                          : AppColors.positiveGreen,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${ficha.quantidadeAmostras} amostras',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textDark.withValues(alpha: 0.7)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'Nenhuma ficha encontrada'
                : 'Nenhuma ficha corresponde à pesquisa',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Crie sua primeira ficha de avaliação'
                : 'Tente uma pesquisa diferente',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/criar-ficha'),
              icon: const Icon(Icons.add),
              label: const Text('Criar Nova Ficha'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkGreen
                    : AppColors.positiveGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListaFichas() {
    return Column(
      children: [
        // Barra de pesquisa ativa
        if (_searchQuery.isNotEmpty)
          Container(
            margin: EdgeInsets.all(
              ResponsiveThemeValues.elementSpacing(context),
            ),
            padding: EdgeInsets.all(
              ResponsiveThemeValues.elementSpacing(context),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cardDark.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkGreen
                    : AppColors.positiveGreen,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkGreen
                      : AppColors.positiveGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pesquisando por: "$_searchQuery"',
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textDark
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _searchQuery = ''),
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkGreen
                        : AppColors.positiveGreen,
                  ),
                ),
              ],
            ),
          ),

        // Lista de fichas
        Expanded(
          child: RefreshIndicator(
            onRefresh: _carregarFichas,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkGreen
                : AppColors.positiveGreen,
            child: ListView.builder(
              padding: EdgeInsets.all(
                ResponsiveThemeValues.elementSpacing(context),
              ),
              itemCount: _fichasFiltradas.length,
              itemBuilder: (context, index) {
                final ficha = _fichasFiltradas[index];
                return _buildFichaCard(ficha);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFichaCard(Ficha ficha) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.responsiveValue(
          context,
          mobile: 12.0,
          tablet: 16.0,
        ),
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.cardDark
          : Colors.white,
      child: InkWell(
        onTap: () => _abrirDetalhes(ficha),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveThemeValues.elementSpacing(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do card
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkGreen
                          : AppColors.positiveGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ficha.numeroFicha,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatarData(ficha.dataAvaliacao),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textDark.withValues(alpha: 0.7)
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showOptionsMenu(ficha),
                    icon: const Icon(Icons.more_vert),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark.withValues(alpha: 0.7)
                        : Colors.grey[600],
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Informações principais
              Text(
                ficha.cliente,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textDark
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ficha.fazenda,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textDark.withValues(alpha: 0.8)
                      : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),

              // Produto e informações técnicas
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${ficha.produto} - ${ficha.variedade}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkGreen
                                : AppColors.positiveGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lote: ${ficha.lote}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.textDark.withValues(alpha: 0.7)
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${ficha.pesoTotal.toStringAsFixed(1)} kg',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkGreen
                              : AppColors.positiveGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${ficha.quantidadeAmostras} amostras',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textDark.withValues(alpha: 0.7)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Responsável
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark.withValues(alpha: 0.7)
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      ficha.responsavelAvaliacao,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textDark.withValues(alpha: 0.7)
                            : Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchText = _searchQuery;
        return AlertDialog(
          title: const Text('Pesquisar Fichas'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Digite o número, cliente, produto...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => searchText = value,
            controller: TextEditingController(text: _searchQuery),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _searchQuery = searchText);
                Navigator.pop(context);
              },
              child: const Text('Pesquisar'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros'),
        content: const Text(
          'Funcionalidade de filtros será implementada em breve.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _abrirDetalhes(Ficha ficha) {
    // Navegar para página de detalhes
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ficha ${ficha.numeroFicha}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${ficha.cliente}'),
            Text('Fazenda: ${ficha.fazenda}'),
            Text('Produto: ${ficha.produto} - ${ficha.variedade}'),
            Text('Peso: ${ficha.pesoTotal.toStringAsFixed(1)} kg'),
            Text('Responsável: ${ficha.responsavelAvaliacao}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Aqui seria a navegação para edição
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(Ficha ficha) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ações para ${ficha.numeroFicha}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkGreen
                    : AppColors.positiveGreen,
              ),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                // Implementar edição
                _editarFicha(ficha);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.blue),
              title: const Text('Compartilhar'),
              onTap: () {
                Navigator.pop(context);
                _compartilharFicha(ficha);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.orange),
              title: const Text('Exportar PDF'),
              onTap: () {
                Navigator.pop(context);
                _exportarPDF(ficha);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.pop(context);
                _confirmarExclusao(ficha);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _editarFicha(Ficha ficha) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Ficha'),
        content: const Text(
          'Funcionalidade de edição será implementada em breve.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _compartilharFicha(Ficha ficha) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compartilhar Ficha'),
        content: Text('Deseja compartilhar a ficha ${ficha.numeroFicha}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar compartilhamento
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ficha ${ficha.numeroFicha} compartilhada'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Compartilhar'),
          ),
        ],
      ),
    );
  }

  void _exportarPDF(Ficha ficha) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportar PDF'),
        content: Text('Deseja exportar a ficha ${ficha.numeroFicha} como PDF?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar exportação
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('PDF da ficha ${ficha.numeroFicha} exportado'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Exportar'),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(Ficha ficha) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir a ficha ${ficha.numeroFicha}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _fichas.removeWhere((f) => f.id == ficha.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ficha ${ficha.numeroFicha} excluída'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
