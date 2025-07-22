import '../domain/entities/ficha.dart';

/// Exemplo de como criar e usar Fichas com campo fazenda explícito
class FichaExample {
  /// Exemplo básico de criação de ficha com fazenda
  static Ficha criarFichaComFazenda() {
    return Ficha(
      id: 'ficha-001',
      numeroFicha: 'QF-2025-001',
      dataAvaliacao: DateTime.now(),
      cliente: 'Exportadora São Paulo',
      fazenda: 'Fazenda São José - Franca/SP', // Campo obrigatório
      ano: 2025, // Campo obrigatório da planilha
      produto: 'Manga',
      variedade: 'Tommy Atkins',
      origem: 'São Paulo - Brasil',
      lote: 'SP-2025-001',
      pesoTotal: 1500.5,
      quantidadeAmostras: 50,
      responsavelAvaliacao: 'João Silva',
      observacoes: 'Primeira avaliação do lote',
      criadoEm: DateTime.now(),
    );
  }

  /// Exemplo de edição de ficha mantendo fazenda
  static Ficha editarFicha(Ficha fichaOriginal) {
    return fichaOriginal.copyWith(
      observacoes: 'Avaliação revisada - qualidade excelente',
      atualizadoEm: DateTime.now(),
      // fazenda é mantida automaticamente do original
    );
  }

  /// Exemplo de criação de nova ficha baseada em outra, mudando fazenda
  static Ficha criarFichaNoveFazenda(Ficha fichaBase) {
    return fichaBase.copyWith(
      id: 'ficha-002',
      numeroFicha: 'QF-2025-002',
      fazenda: 'Fazenda Nossa Senhora - Ribeirão Preto/SP', // Nova fazenda
      lote: 'RP-2025-001',
      criadoEm: DateTime.now(),
      atualizadoEm: null,
    );
  }

  /// Demonstra a importância do campo fazenda no salvamento
  static void demonstrarSalvamentoComFazenda() {
    final ficha = criarFichaComFazenda();

    // O campo fazenda é obrigatório e será sempre incluído
    print('ID: ${ficha.id}');
    print('Número: ${ficha.numeroFicha}');
    print('Cliente: ${ficha.cliente}');
    print('Fazenda: ${ficha.fazenda}'); // Sempre presente
    print('Produto: ${ficha.produto}');

    // No salvamento, fazenda sempre estará explícita
    print('\n--- DADOS DE SALVAMENTO ---');
    print('Fazenda para salvamento: ${ficha.fazenda}');
    print('Data de criação: ${ficha.criadoEm}');
  }

  /// Exemplo de validação de fazenda
  static bool validarFazenda(String fazenda) {
    // Fazenda não pode estar vazia
    if (fazenda.trim().isEmpty) {
      return false;
    }

    // Deve ter pelo menos 5 caracteres
    if (fazenda.trim().length < 5) {
      return false;
    }

    return true;
  }

  /// Exemplo de criação segura com validação
  static Ficha? criarFichaSegura({
    required String numeroFicha,
    required String cliente,
    required String fazenda,
    required String produto,
  }) {
    // Valida fazenda antes de criar
    if (!validarFazenda(fazenda)) {
      print('Erro: Fazenda inválida - deve ter pelo menos 5 caracteres');
      return null;
    }

    return Ficha(
      id: 'auto-generated-id',
      numeroFicha: numeroFicha,
      dataAvaliacao: DateTime.now(),
      cliente: cliente,
      fazenda: fazenda,
      ano: DateTime.now().year,
      produto: produto,
      variedade: '',
      origem: '',
      lote: '',
      pesoTotal: 0.0,
      quantidadeAmostras: 0,
      responsavelAvaliacao: '',
      observacoes: '',
      criadoEm: DateTime.now(),
    );
  }
}

/// Exemplo de uso prático
void exemploUso() {
  // Criando ficha com fazenda explícita
  final ficha = FichaExample.criarFichaComFazenda();
  print('Ficha criada para fazenda: ${ficha.fazenda}');

  // Editando ficha (fazenda é preservada)
  final fichaEditada = FichaExample.editarFicha(ficha);
  print('Ficha editada - fazenda mantida: ${fichaEditada.fazenda}');

  // Criando nova ficha com fazenda diferente
  final novaFicha = FichaExample.criarFichaNoveFazenda(ficha);
  print('Nova ficha criada para fazenda: ${novaFicha.fazenda}');

  // Demonstração do salvamento
  FichaExample.demonstrarSalvamentoComFazenda();
}
