import 'dart:io';
import '../entities/entities.dart';
import '../../core/services/services.dart';

/// Use case para gerar PDFs de fichas e amostras
class GerarPdfUseCase {
  final PdfGeneratorService _pdfService;

  const GerarPdfUseCase(this._pdfService);

  /// Gera PDF completo de uma ficha com todas as amostras
  Future<File> gerarPdfFichaCompleta(
    Ficha ficha,
    List<AmostraDetalhada> amostras,
  ) async {
    try {
      return await _pdfService.gerarPdfFicha(ficha, amostras);
    } catch (e) {
      throw Exception('Erro ao gerar PDF da ficha: $e');
    }
  }

  /// Gera PDF de uma amostra específica
  Future<File> gerarPdfAmostraEspecifica(
    Ficha ficha,
    AmostraDetalhada amostra,
  ) async {
    try {
      return await _pdfService.gerarPdfAmostra(ficha, amostra);
    } catch (e) {
      throw Exception('Erro ao gerar PDF da amostra: $e');
    }
  }

  /// Gera PDF resumido apenas com informações principais
  Future<File> gerarPdfResumo(
    Ficha ficha,
    List<AmostraDetalhada> amostras,
  ) async {
    try {
      // Filtra apenas amostras com dados completos
      final amostrasCompletas = amostras
          .where(
            (amostra) =>
                amostra.pesoLiquido != null &&
                amostra.classe != null &&
                amostra.area != null,
          )
          .toList();

      return await _pdfService.gerarPdfFicha(ficha, amostrasCompletas);
    } catch (e) {
      throw Exception('Erro ao gerar PDF resumido: $e');
    }
  }
}
