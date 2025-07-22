import '../domain/entities/ficha.dart';
import '../domain/entities/amostra_detalhada.dart';

/// Exemplo atualizado demonstrando compatibilidade com a ficha física
/// Baseado na planilha de controle de qualidade real
class FichaFisicaExample {
  /// Cria uma ficha seguindo o formato da planilha física
  static Ficha criarFichaComPlanilhaFisica() {
    return Ficha(
      id: 'ficha-001',
      numeroFicha: 'QF-2025-001',
      dataAvaliacao: DateTime.now(),
      cliente: 'Exportadora São Paulo',
      fazenda: 'Fazenda São José - Franca/SP',
      ano: 2025, // Campo obrigatório da planilha
      produto: 'Uva',
      variedade: 'Thompson Seedless',
      origem: 'São Paulo - Brasil',
      lote: 'SP-2025-001',
      pesoTotal: 1500.5,
      quantidadeAmostras: 7, // A, B, C, D, E, F, G
      responsavelAvaliacao: 'João Silva (Inspetor)',
      produtorResponsavel: 'Carlos Mendes (Produtor)',
      observacoes: 'Primeira avaliação da safra 2025',
      // Observações específicas por letra (como na planilha)
      observacaoA: 'Amostra representativa do lote principal',
      observacaoB: 'Segunda coleta da mesma área',
      observacaoC: 'Amostra de controle',
      observacaoD: 'Área com irrigação diferenciada',
      observacaoF: 'Lote separado para exportação',
      observacaoG: 'Amostra final de validação',
      criadoEm: DateTime.now(),
    );
  }

  /// Cria amostras detalhadas seguindo as colunas da planilha
  static List<AmostraDetalhada> criarAmostrasDetalhadas(String fichaId) {
    final amostras = <AmostraDetalhada>[];
    final letras = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

    for (int i = 0; i < letras.length; i++) {
      amostras.add(
        AmostraDetalhada(
          id: 'amostra-${letras[i]}-001',
          fichaId: fichaId,
          letraAmostra: letras[i],
          data: DateTime.now(),
          caixaMarca: 'Marca${i + 1}',
          classe: 'Classe A',
          area: 'Área ${i + 1}',
          variedade: 'Thompson Seedless',
          pesoBrutoKg: 15.0 + (i * 0.5),

          // Campos com validação específica
          sacolaCumbuca: i % 2 == 0 ? 'C' : 'E', // C=certa, E=errada
          caixaCumbucaAlta: i < 4 ? 'S' : 'N', // S=sim, N=não
          aparenciaCalibro0a7: '${(i % 8)}', // 0-7
          corUMD: ['U', 'M', 'D'][i % 3], // U=uniforme, M=média, D=desuniforme

          pesoEmbalagem: 1.2,
          pesoLiquidoKg: 13.8 + (i * 0.5),
          bagaMm: 18.0 + (i * 0.2),
          brix: 16.5 + (i * 0.3),
          brixMedia: 16.8,

          // Defeitos (percentuais) - alguns com valores para demonstração
          teiaAranha: i == 0 ? 2.5 : null,
          aranha: i == 1 ? 1.0 : null,
          amassada: i == 2 ? 3.2 : null,
          aquosaCorBaga: i == 3 ? 1.5 : null,
          podre: i == 4 ? 0.8 : null,
          oidio: i == 5 ? 1.2 : null,

          observacoes: i % 2 == 0 ? 'Amostra em boas condições' : null,
          criadoEm: DateTime.now(),
        ),
      );
    }

    return amostras;
  }

  /// Demonstra validação flexível (permite salvar com dados incompletos)
  static void demonstrarValidacaoFlexivel() {
    // Ficha com apenas dados mínimos - PERMITIDO salvar
    final fichaMinima = Ficha(
      id: 'ficha-min-001',
      numeroFicha: 'QF-MIN-001',
      dataAvaliacao: DateTime.now(),
      cliente: '', // VAZIO - mas permite salvar
      fazenda: 'Fazenda São José', // OBRIGATÓRIO
      ano: 2025,
      produto: '', // VAZIO - mas permite salvar
      variedade: '',
      origem: '',
      lote: '',
      pesoTotal: 0.0, // ZERO - mas permite salvar
      quantidadeAmostras: 0,
      responsavelAvaliacao: '', // VAZIO - mas permite salvar
      observacoes: '',
      criadoEm: DateTime.now(),
    );

    print('=== VALIDAÇÃO FLEXÍVEL ===');
    print('Pode salvar com dados mínimos: ${fichaMinima.temDadosMinimos}');
    print(
      'Percentual preenchido: ${fichaMinima.percentualPreenchimento.toStringAsFixed(1)}%',
    );

    // Mostra avisos dos campos importantes não preenchidos
    final avisos = fichaMinima.avisosCamposFaltantes;
    if (avisos.isNotEmpty) {
      print('\n⚠️  AVISOS (mas ainda permite salvar):');
      for (final aviso in avisos) {
        print('• $aviso');
      }
    }

    print('\n✅ Salvamento permitido mesmo com avisos!\n');
  }

  /// Demonstra ficha completa com alta qualidade de dados
  static void demonstrarFichaCompleta() {
    final fichaCompleta = criarFichaComPlanilhaFisica();

    print('=== FICHA COMPLETA ===');
    print(
      'Percentual preenchido: ${fichaCompleta.percentualPreenchimento.toStringAsFixed(1)}%',
    );
    print('Observações por letra: ${fichaCompleta.observacoesPreenchidas}');
    print(
      'Avisos: ${fichaCompleta.avisosCamposFaltantes.isEmpty ? "Nenhum" : fichaCompleta.avisosCamposFaltantes}',
    );
    print('Dados completos: ✅\n');
  }

  /// Demonstra análise de amostras detalhadas
  static void demonstrarAnaliseAmostras() {
    final fichaId = 'ficha-001';
    final amostras = criarAmostrasDetalhadas(fichaId);

    print('=== ANÁLISE DE AMOSTRAS DETALHADAS ===');

    for (final amostra in amostras) {
      print('Amostra ${amostra.letraAmostra}:');
      print(
        '  • Preenchimento: ${amostra.percentualPreenchimento.toStringAsFixed(1)}%',
      );
      print(
        '  • Sacola/Cumbuca: ${amostra.sacolaCumbuca} (${amostra.sacolaCumbuca == 'C' ? 'Certa' : 'Errada'})',
      );
      print('  • Cor UMD: ${amostra.corUMD}');
      print('  • Brix: ${amostra.brix ?? 'N/A'}');

      final defeitos = amostra.defeitosEncontrados;
      if (defeitos.isNotEmpty) {
        print('  • Defeitos encontrados:');
        for (final defeito in defeitos) {
          print('    - ${defeito['tipo']}: ${defeito['valor']}%');
        }
      }
      print('');
    }
  }

  /// Exemplo de uso com validação das opções da planilha
  static bool validarOpcoesPlanilha(AmostraDetalhada amostra) {
    // Valida Sacola/Cumbuca
    if (amostra.sacolaCumbuca != null &&
        !FichaFisicaConstants.opcoesSacolaCumbuca.contains(
          amostra.sacolaCumbuca,
        )) {
      print('⚠️  Erro: Sacola/Cumbuca deve ser C ou E');
      return false;
    }

    // Valida Caixa/Cumbuca Alta
    if (amostra.caixaCumbucaAlta != null &&
        !FichaFisicaConstants.opcoesCaixaCumbucaAlta.contains(
          amostra.caixaCumbucaAlta,
        )) {
      print('⚠️  Erro: Caixa/Cumbuca Alta deve ser S ou N');
      return false;
    }

    // Valida Cor UMD
    if (amostra.corUMD != null &&
        !FichaFisicaConstants.opcoesCorUMD.contains(amostra.corUMD)) {
      print('⚠️  Erro: Cor UMD deve ser U, M ou D');
      return false;
    }

    // Valida Calibre (0-7)
    if (amostra.aparenciaCalibro0a7 != null) {
      final calibre = int.tryParse(amostra.aparenciaCalibro0a7!);
      if (calibre == null || calibre < 0 || calibre > 7) {
        print('⚠️  Erro: Calibre deve estar entre 0 e 7');
        return false;
      }
    }

    return true;
  }
}

/// Exemplo de uso prático com a nova estrutura
void exemploUsoCompleto() {
  print('🍇 EXEMPLO DE USO - PLANILHA FÍSICA DIGITALIZADA\n');

  // 1. Demonstra validação flexível
  FichaFisicaExample.demonstrarValidacaoFlexivel();

  // 2. Demonstra ficha completa
  FichaFisicaExample.demonstrarFichaCompleta();

  // 3. Demonstra análise de amostras
  FichaFisicaExample.demonstrarAnaliseAmostras();

  // 4. Exemplo de como a ficha pode ser salva mesmo incompleta
  print('=== RESUMO DA FLEXIBILIDADE ===');
  print('✅ Permite salvar com apenas fazenda e número da ficha');
  print('⚠️  Mostra avisos para campos importantes não preenchidos');
  print('📊 Calcula percentual de preenchimento automaticamente');
  print('🔍 Valida opções específicas da planilha física (C/E, S/N, U/M/D)');
  print('📋 Suporta todas as colunas da planilha (A, B, C, D, E, F, G)');
  print(
    '🏷️  Inclui campos específicos: ano, produtor/responsável, observações por letra',
  );
}
