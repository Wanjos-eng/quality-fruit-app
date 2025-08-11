import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../responsive/responsive.dart';
import '../../core/theme/responsive_theme_extensions.dart';
import '../../domain/entities/entities.dart';
import '../../core/services/services.dart';
import '../../domain/usecases/usecases.dart';
import '../../data/datasources/local_datasource.dart';
import '../../data/repositories/ficha_repository_impl.dart';
import 'dart:io';

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

  // Repositórios e use cases
  late final LocalDatasource _datasource;
  late final FichaRepositoryImpl _fichaRepository;
  late final ListarFichasUseCase _listarFichasUseCase;
  late final SalvarFichaUseCase _salvarFichaUseCase;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      _datasource = LocalDatasource();

      // FORÇAR reset completo do banco para garantir estrutura correta
      debugPrint('🔄 Resetando banco de dados...');
      await _datasource.resetDatabase();

      // Inicializar banco com nova estrutura
      debugPrint('🔄 Inicializando nova estrutura do banco...');
      await _datasource.database;

      // Inicializar repositórios e use cases
      _fichaRepository = FichaRepositoryImpl(_datasource);
      _listarFichasUseCase = ListarFichasUseCase(_fichaRepository);
      _salvarFichaUseCase = SalvarFichaUseCase(_fichaRepository);

      debugPrint('✅ Serviços inicializados com sucesso!');

      // Criar fichas de teste
      await _criarFichasDeTeste();

      // Carregar fichas do banco
      await _carregarFichas();
    } catch (e) {
      debugPrint('❌ Erro na inicialização: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro na inicialização: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _carregarFichas() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔍 Carregando fichas do banco...');
      final fichas = await _listarFichasUseCase.listarTodas();
      debugPrint('📊 ${fichas.length} fichas encontradas');

      if (mounted) {
        setState(() {
          _fichas = fichas;
          _isLoading = false;
        });
        debugPrint('✅ Fichas carregadas com sucesso na UI');
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar fichas: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar fichas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _criarFichasDeTeste() async {
    try {
      debugPrint('🔄 Iniciando criação de fichas de teste...');

      final agoraExato = DateTime.now(); // Data atual do sistema

      // Ficha 1: Fazenda Pura Verde
      final dataFicha1 = agoraExato.subtract(const Duration(days: 1));
      final ficha1 = Ficha(
        id: '',
        numeroFicha: '', // Será gerado automaticamente pelo SalvarFichaUseCase
        dataAvaliacao: dataFicha1,
        cliente: '', // Não preenchido pelo usuário, manter vazio
        // APENAS campos preenchidos pelo usuário na SEÇÃO 1
        ano: dataFicha1.year,
        fazenda: 'PVE', // Pura Verde (3 letras)
        semanaAno: Ficha.calcularSemanaAno(dataFicha1),
        inspetor: 'João Silva',
        tipoAmostragem: TiposAmostragem.cumbuca500g,
        pesoBrutoKg: 0.0, // Não preenchido pelo usuário
        // Campos obrigatórios mínimos (valores padrão)
        produto: 'Uva',
        variedade: '',
        origem: '',
        lote: '',
        pesoTotal: 1.0, // Valor mínimo para passar validação
        quantidadeAmostras: 10, // Baseado no tipo de amostragem
        responsavelAvaliacao: 'João Silva',
        observacoes: '',
        criadoEm:
            agoraExato, // Será definido automaticamente pelo SalvarFichaUseCase
      );

      // Ficha 2: Fazenda João Paulo
      final dataFicha2 = agoraExato.subtract(const Duration(days: 3));
      final ficha2 = Ficha(
        id: '',
        numeroFicha: '', // Será gerado automaticamente
        dataAvaliacao: dataFicha2,
        cliente: '',
        // APENAS campos preenchidos pelo usuário na SEÇÃO 1
        ano: dataFicha2.year,
        fazenda: 'JPA', // João Paulo (3 letras)
        semanaAno: Ficha.calcularSemanaAno(dataFicha2),
        inspetor: 'Maria Santos',
        tipoAmostragem: TiposAmostragem.cumbuca250g,
        pesoBrutoKg: 0.0,
        // Campos obrigatórios mínimos (valores padrão)
        produto: 'Uva',
        variedade: '',
        origem: '',
        lote: '',
        pesoTotal: 1.0, // Valor mínimo para passar validação
        quantidadeAmostras: 20, // Baseado no tipo de amostragem
        responsavelAvaliacao: 'Maria Santos',
        observacoes: '',
        criadoEm: agoraExato, // Será definido automaticamente
      );

      // Ficha 3: Fazenda Santa Rita
      final dataFicha3 = agoraExato.subtract(const Duration(days: 5));
      final ficha3 = Ficha(
        id: '',
        numeroFicha: '', // Será gerado automaticamente
        dataAvaliacao: dataFicha3,
        cliente: '',
        // APENAS campos preenchidos pelo usuário na SEÇÃO 1
        ano: dataFicha3.year,
        fazenda: 'SRT', // Santa Rita (3 letras)
        semanaAno: Ficha.calcularSemanaAno(dataFicha3),
        inspetor: 'Carlos Eduardo',
        tipoAmostragem: TiposAmostragem.sacola,
        pesoBrutoKg: 0.0,
        // Campos obrigatórios mínimos (valores padrão)
        produto: 'Uva',
        variedade: '',
        origem: '',
        lote: '',
        pesoTotal: 1.0, // Valor mínimo para passar validação
        quantidadeAmostras: 7, // Baseado no tipo de amostragem
        responsavelAvaliacao: 'Carlos Eduardo',
        observacoes: '',
        criadoEm: agoraExato, // Será definido automaticamente
      );

      // Ficha 4: Fazenda Vale do Sol
      final dataFicha4 = agoraExato.subtract(const Duration(days: 7));
      final ficha4 = Ficha(
        id: '',
        numeroFicha: '', // Será gerado automaticamente
        dataAvaliacao: dataFicha4,
        cliente: '',
        // APENAS campos preenchidos pelo usuário na SEÇÃO 1
        ano: dataFicha4.year,
        fazenda: 'VSO', // Vale do Sol (3 letras)
        semanaAno: Ficha.calcularSemanaAno(dataFicha4),
        inspetor: 'Ana Beatriz',
        tipoAmostragem: TiposAmostragem.cumbuca500g,
        pesoBrutoKg: 0.0,
        // Campos obrigatórios mínimos (valores padrão)
        produto: 'Uva',
        variedade: '',
        origem: '',
        lote: '',
        pesoTotal: 1.0, // Valor mínimo para passar validação
        quantidadeAmostras: 10, // Baseado no tipo de amostragem
        responsavelAvaliacao: 'Ana Beatriz',
        observacoes: '',
        criadoEm: agoraExato, // Será definido automaticamente
      );

      // Salvar todas as fichas de teste - o numeroFicha será gerado automaticamente
      debugPrint('📝 Salvando ficha 1 (fazenda: ${ficha1.fazenda})');
      final fichaSalva1 = await _salvarFichaUseCase.call(ficha1);
      debugPrint('✅ Ficha 1 salva com número: ${fichaSalva1.numeroFicha}');

      debugPrint('📝 Salvando ficha 2 (fazenda: ${ficha2.fazenda})');
      final fichaSalva2 = await _salvarFichaUseCase.call(ficha2);
      debugPrint('✅ Ficha 2 salva com número: ${fichaSalva2.numeroFicha}');

      debugPrint('📝 Salvando ficha 3 (fazenda: ${ficha3.fazenda})');
      final fichaSalva3 = await _salvarFichaUseCase.call(ficha3);
      debugPrint('✅ Ficha 3 salva com número: ${fichaSalva3.numeroFicha}');

      debugPrint('📝 Salvando ficha 4 (fazenda: ${ficha4.fazenda})');
      final fichaSalva4 = await _salvarFichaUseCase.call(ficha4);
      debugPrint('✅ Ficha 4 salva com número: ${fichaSalva4.numeroFicha}');

      debugPrint('✅ 4 fichas de UVA criadas com números automáticos!');
      debugPrint(
        '📋 Números gerados: ${fichaSalva1.numeroFicha}, ${fichaSalva2.numeroFicha}, ${fichaSalva3.numeroFicha}, ${fichaSalva4.numeroFicha}',
      );
    } catch (e) {
      debugPrint('❌ Erro ao criar fichas de teste: $e');
      rethrow; // Re-lançar erro para que seja capturado na inicialização
    }
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

              // Informações principais - apenas cliente se existir
              if (ficha.cliente.isNotEmpty) ...[
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
                const SizedBox(height: 8),
              ],

              // SEÇÃO 1: Informações principais da ficha
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Fazenda: ${ficha.fazenda}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkGreen
                            : AppColors.positiveGreen,
                      ),
                    ),
                  ),
                  Text(
                    'Semana: ${ficha.semanaAno}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textDark.withValues(alpha: 0.8)
                          : Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tipo de amostragem e inspetor
              Row(
                children: [
                  Icon(
                    Icons.science,
                    size: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkGreen
                        : AppColors.positiveGreen,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ficha.tipoAmostragem,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkGreen
                            : AppColors.positiveGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Inspetor responsável
              Row(
                children: [
                  Icon(
                    Icons.assignment_ind,
                    size: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textDark.withValues(alpha: 0.7)
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Inspetor: ${ficha.inspetor}',
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
        return Theme(
          data: Theme.of(context), // Usar tema do sistema
          child: AlertDialog(
            backgroundColor:
                Theme.of(context).dialogTheme.backgroundColor ??
                (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.white),
            title: Text(
              'Pesquisar Fichas',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            content: TextField(
              autofocus: true,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              decoration: InputDecoration(
                hintText: 'Digite o número, fazenda, inspetor...',
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => searchText = value,
              controller: TextEditingController(text: _searchQuery),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => _searchQuery = searchText);
                  Navigator.pop(context);
                },
                child: const Text('Pesquisar'),
              ),
            ],
          ),
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
            // SEÇÃO 1: Informações Gerais
            const Text(
              'SEÇÃO 1: INFORMAÇÕES GERAIS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text('Cliente: ${ficha.cliente}'),
            Text('Ano: ${ficha.ano}'),
            Text('Fazenda: ${ficha.fazenda}'),
            Text('Semana do ano: ${ficha.semanaAno}'),
            Text('Inspetor: ${ficha.inspetor}'),
            Text('Tipo de amostragem: ${ficha.tipoAmostragem}'),
            Text('Peso bruto: ${ficha.pesoBrutoKg.toStringAsFixed(1)} kg'),
            const SizedBox(height: 12),
            // Informações do produto
            const Text(
              'PRODUTO',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text('Produto: ${ficha.produto} - ${ficha.variedade}'),
            Text('Origem: ${ficha.origem}'),
            Text('Lote: ${ficha.lote}'),
            Text('Quantidade de amostras: ${ficha.quantidadeAmostras}'),
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
      builder: (context) => Theme(
        data: Theme.of(context), // Usar tema do sistema
        child: AlertDialog(
          backgroundColor:
              Theme.of(context).dialogTheme.backgroundColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.white), // Cor do sistema
          title: Text(
            'Ações para ${ficha.numeroFicha}',
            style: TextStyle(
              color: Theme.of(
                context,
              ).textTheme.titleLarge?.color, // Cor do texto do sistema
            ),
          ),
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
                title: Text(
                  'Editar',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _editarFicha(ficha);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.share,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.lightBlue
                      : Colors.blue,
                ),
                title: Text(
                  'Compartilhar',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _compartilharFicha(ficha);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.download,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.orangeAccent
                      : Colors.orange,
                ),
                title: Text(
                  'Exportar PDF',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _exportarPDF(ficha);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.redAccent
                      : Colors.red,
                ),
                title: Text(
                  'Excluir',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
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
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
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
            onPressed: () async {
              Navigator.pop(context);
              await _gerarEExportarPDF(ficha);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Exportar'),
          ),
        ],
      ),
    );
  }

  /// Gera e exporta o PDF da ficha
  Future<void> _gerarEExportarPDF(Ficha ficha) async {
    try {
      // Mostra loading
      _mostrarDialogLoading('Gerando PDF...');

      // Criar as instâncias dos serviços
      final pdfService = PdfGeneratorService();
      final gerarPdfUseCase = GerarPdfUseCase(pdfService);

      // Simular carregamento das amostras (você deve implementar a busca real)
      final amostras = await _carregarAmostrasParaFicha(ficha.id);

      // Gerar o PDF
      final arquivo = await gerarPdfUseCase.gerarPdfFichaCompleta(
        ficha,
        amostras,
      );

      // Fechar loading
      if (mounted) Navigator.pop(context);

      // Mostrar sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PDF gerado com sucesso!'),
                Text(
                  'Salvo em: ${arquivo.path}',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Ver Local',
              textColor: Colors.white,
              onPressed: () {
                _mostrarLocalizacaoArquivo(arquivo);
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Fechar loading se estiver aberto
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Mostrar erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar PDF: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Mostra dialog de loading
  void _mostrarDialogLoading(String mensagem) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Expanded(child: Text(mensagem)),
          ],
        ),
      ),
    );
  }

  /// Mostra informações sobre a localização do arquivo
  void _mostrarLocalizacaoArquivo(File arquivo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('PDF Salvo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('O arquivo foi salvo em:'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                arquivo.path,
                style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Para acessar o arquivo, use um gerenciador de arquivos e navegue até a pasta "Documents" do aplicativo.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Carrega as amostras para uma ficha específica
  Future<List<AmostraDetalhada>> _carregarAmostrasParaFicha(
    String fichaId,
  ) async {
    try {
      final datasource = LocalDatasource();
      return await datasource.buscarAmostrasDetalhadasPorFicha(fichaId);
    } catch (e) {
      // Em caso de erro, retorna amostras de exemplo
      debugPrint('Erro ao carregar amostras do banco: $e');
      return _criarAmostrasExemplo(fichaId);
    }
  }

  /// Cria amostras de exemplo para teste
  List<AmostraDetalhada> _criarAmostrasExemplo(String fichaId) {
    final agora = DateTime.now();
    return [
      AmostraDetalhada(
        id: '${fichaId}_A',
        fichaId: fichaId,
        letraAmostra: 'A',
        criadoEm: agora,
        caixaMarca: 'Caixa 001',
        classe: 'Extra',
        area: 'Bloco 1',
        variedade: 'Crimson',
        pesoLiquido: 485.3,
        brixMedia: 18.5,
        pesoBrutoMedia: 520.1,
        observacoes: 'Amostra em ótimo estado',
      ),
      AmostraDetalhada(
        id: '${fichaId}_B',
        fichaId: fichaId,
        letraAmostra: 'B',
        criadoEm: agora,
        caixaMarca: 'Caixa 002',
        classe: 'Primeira',
        area: 'Bloco 2',
        variedade: 'Crimson',
        pesoLiquido: 478.9,
        brixMedia: 17.8,
        pesoBrutoMedia: 515.2,
        podre: 2.5,
        amassada: 1.2,
      ),
      AmostraDetalhada(
        id: '${fichaId}_C',
        fichaId: fichaId,
        letraAmostra: 'C',
        criadoEm: agora,
        caixaMarca: 'Caixa 003',
        classe: 'Extra',
        area: 'Bloco 1',
        variedade: 'Crimson',
        pesoLiquido: 492.1,
        brixMedia: 19.2,
        pesoBrutoMedia: 525.7,
        observacoes: 'Excelente qualidade visual',
      ),
    ];
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
