import '../repositories/repositories.dart';

/// Resultado do cálculo de qualidade
class ResultadoQualidade {
  final double pontuacaoGeral; // 0-100
  final double impactoDefeitos; // 0-100
  final int medidasDentroParametros;
  final int totalMedidas;
  final int defeitosCriticos;
  final int totalDefeitos;
  final String classificacao; // Excelente, Boa, Regular, Ruim
  final List<String> observacoes;

  const ResultadoQualidade({
    required this.pontuacaoGeral,
    required this.impactoDefeitos,
    required this.medidasDentroParametros,
    required this.totalMedidas,
    required this.defeitosCriticos,
    required this.totalDefeitos,
    required this.classificacao,
    required this.observacoes,
  });
}

/// Use case para calcular a qualidade geral de uma ficha
class CalcularQualidadeFichaUseCase {
  final AmostraRepository _amostraRepository;
  final MedidaRepository _medidaRepository;
  final DefeitoRepository _defeitoRepository;

  const CalcularQualidadeFichaUseCase(
    this._amostraRepository,
    this._medidaRepository,
    this._defeitoRepository,
  );

  /// Calcula a qualidade geral de uma ficha
  Future<ResultadoQualidade> call(String fichaId) async {
    final amostras = await _amostraRepository.listarPorFicha(fichaId);

    if (amostras.isEmpty) {
      throw Exception('Nenhuma amostra encontrada para a ficha');
    }

    int totalMedidas = 0;
    int medidasDentroParametros = 0;
    int totalDefeitos = 0;
    int defeitosCriticos = 0;
    double impactoDefeitosTotal = 0.0;
    List<String> observacoes = [];

    // Analisa cada amostra
    for (final amostra in amostras) {
      // Analisa medidas
      final medidas = await _medidaRepository.listarPorAmostra(amostra.id);
      totalMedidas += medidas.length;

      for (final medida in medidas) {
        if (medida.dentroParametros) {
          medidasDentroParametros++;
        } else {
          observacoes.add(
            '${medida.tipo.nome} fora do parâmetro: ${medida.valorFormatado}',
          );
        }
      }

      // Analisa defeitos
      final defeitos = await _defeitoRepository.listarPorAmostra(amostra.id);
      totalDefeitos += defeitos.length;

      for (final defeito in defeitos) {
        impactoDefeitosTotal += defeito.impactoQualidade;
        if (defeito.isCritico) {
          defeitosCriticos++;
          observacoes.add(
            'Defeito crítico: ${defeito.tipo.nome} (${defeito.gravidade.nome})',
          );
        }
      }
    }

    // Calcula pontuação das medidas (0-50 pontos)
    final pontuacaoMedidas = totalMedidas > 0
        ? (medidasDentroParametros / totalMedidas) * 50.0
        : 0.0;

    // Calcula penalização dos defeitos (0-50 pontos perdidos)
    final impactoMedio = amostras.isNotEmpty
        ? impactoDefeitosTotal / amostras.length
        : 0.0;
    final penalizacaoDefeitos = (impactoMedio * 2.5).clamp(0.0, 50.0);

    // Pontuação geral (máximo 100)
    final pontuacaoGeral = (50.0 + pontuacaoMedidas - penalizacaoDefeitos)
        .clamp(0.0, 100.0);

    // Determina classificação
    String classificacao;
    if (pontuacaoGeral >= 85) {
      classificacao = 'Excelente';
    } else if (pontuacaoGeral >= 70) {
      classificacao = 'Boa';
    } else if (pontuacaoGeral >= 50) {
      classificacao = 'Regular';
    } else {
      classificacao = 'Ruim';
    }

    // Adiciona observações gerais
    if (defeitosCriticos > 0) {
      observacoes.insert(
        0,
        '$defeitosCriticos defeito(s) crítico(s) encontrado(s)',
      );
    }

    if (totalMedidas == 0) {
      observacoes.insert(0, 'Nenhuma medida registrada');
    }

    return ResultadoQualidade(
      pontuacaoGeral: pontuacaoGeral,
      impactoDefeitos: impactoMedio,
      medidasDentroParametros: medidasDentroParametros,
      totalMedidas: totalMedidas,
      defeitosCriticos: defeitosCriticos,
      totalDefeitos: totalDefeitos,
      classificacao: classificacao,
      observacoes: observacoes,
    );
  }
}
