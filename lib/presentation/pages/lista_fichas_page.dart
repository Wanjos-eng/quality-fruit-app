import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    
    return _fichas.where((ficha) =>
      ficha.numeroFicha.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      ficha.cliente.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      ficha.produto.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      ficha.fazenda.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Minhas Fichas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4CAF50),
              ),
            )
          : _fichasFiltradas.isEmpty
              ? _buildEmptyState()
              : _buildListaFichas(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/criar-ficha'),
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
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
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/criar-ficha'),
              icon: const Icon(Icons.add),
              label: const Text('Criar Nova Ficha'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
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
        // Header com estatísticas
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatistic('Total', _fichas.length.toString()),
              _buildStatistic('Esta Semana', _contarFichasSemana().toString()),
              _buildStatistic('Este Mês', _contarFichasMes().toString()),
            ],
          ),
        ),
        
        // Barra de pesquisa
        if (_searchQuery.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pesquisando por: "$_searchQuery"',
                    style: GoogleFonts.poppins(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _searchQuery = ''),
                  icon: Icon(Icons.clear, color: Colors.orange[700]),
                ),
              ],
            ),
          ),

        // Lista de fichas
        Expanded(
          child: RefreshIndicator(
            onRefresh: _carregarFichas,
            color: const Color(0xFF4CAF50),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _abrirDetalhes(ficha),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do card
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(4),
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
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Informações principais
              Text(
                ficha.cliente,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ficha.fazenda,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),

              // Detalhes do produto
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.eco,
                    label: '${ficha.produto} - ${ficha.variedade}',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.inbox,
                    label: 'Lote: ${ficha.lote}',
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Informações técnicas
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.scale,
                    label: '${ficha.pesoTotal.toStringAsFixed(1)} kg',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.science,
                    label: '${ficha.quantidadeAmostras} amostras',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Rodapé com ações
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ficha.responsavelAvaliacao,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showOptionsMenu(ficha),
                    icon: const Icon(Icons.more_vert),
                    color: Colors.grey[600],
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2E7D32),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  int _contarFichasSemana() {
    final agora = DateTime.now();
    final inicioSemana = agora.subtract(Duration(days: agora.weekday - 1));
    return _fichas.where((ficha) => 
      ficha.criadoEm.isAfter(inicioSemana.subtract(const Duration(days: 1)))
    ).length;
  }

  int _contarFichasMes() {
    final agora = DateTime.now();
    final inicioMes = DateTime(agora.year, agora.month, 1);
    return _fichas.where((ficha) => 
      ficha.criadoEm.isAfter(inicioMes.subtract(const Duration(days: 1)))
    ).length;
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
        content: const Text('Funcionalidade de filtros será implementada em breve.'),
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF4CAF50)),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementar edição
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.blue),
                title: const Text('Compartilhar'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementar compartilhamento
                },
              ),
              ListTile(
                leading: const Icon(Icons.download, color: Colors.orange),
                title: const Text('Exportar PDF'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementar exportação
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
        );
      },
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
