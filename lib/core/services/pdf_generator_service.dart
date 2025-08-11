import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../domain/entities/entities.dart';
import 'directory_manager_service.dart';

/// Serviço responsável pela geração de PDFs das fichas de qualidade
class PdfGeneratorService {
  /// Gera PDF de uma ficha completa com todas as amostras
  Future<File> gerarPdfFicha(
    Ficha ficha,
    List<AmostraDetalhada> amostras,
  ) async {
    final pdf = pw.Document();

    // Página principal com os dados da ficha
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (context) => _buildHeader(ficha),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildInfoGerais(ficha),
          pw.SizedBox(height: 20),
          _buildTabelaAmostras(amostras),
          pw.SizedBox(height: 20),
          _buildResumoEstatistico(amostras),
          pw.SizedBox(height: 20),
          _buildObservacoes(ficha),
        ],
      ),
    );

    return await _salvarPdf(pdf, 'ficha_${ficha.numeroFicha}');
  }

  /// Gera PDF apenas de uma amostra específica
  Future<File> gerarPdfAmostra(Ficha ficha, AmostraDetalhada amostra) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(ficha),
            pw.SizedBox(height: 20),
            _buildDetalhesAmostra(amostra),
            pw.SizedBox(height: 20),
            _buildDefeitosAmostra(amostra),
            pw.SizedBox(height: 20),
            _buildMedidasAmostra(amostra),
          ],
        ),
      ),
    );

    return await _salvarPdf(
      pdf,
      'amostra_${amostra.letraAmostra}_ficha_${ficha.numeroFicha}',
    );
  }

  /// Constrói o cabeçalho do PDF
  pw.Widget _buildHeader(Ficha ficha) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'FICHA DE QUALIDADE DE FRUTAS',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green800,
                ),
              ),
              pw.Text(
                'Ficha: ${ficha.numeroFicha}',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  'Cliente: ${ficha.cliente}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  'Data: ${DateFormat('dd/MM/yyyy').format(ficha.dataAvaliacao)}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Constrói o rodapé do PDF
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'Página ${context.pageNumber} de ${context.pagesCount} - Gerado em ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
      ),
    );
  }

  /// Constrói a seção de informações gerais
  pw.Widget _buildInfoGerais(Ficha ficha) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'INFORMAÇÕES GERAIS',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green700,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _buildInfoItem('Ano:', ficha.ano.toString()),
              _buildInfoItem('Fazenda:', ficha.fazenda),
              _buildInfoItem('Semana:', ficha.semanaAno.toString()),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem('Inspetor:', ficha.inspetor),
              _buildInfoItem('Tipo:', ficha.tipoAmostragem),
              _buildInfoItem('Peso Bruto:', '${ficha.pesoBrutoKg} kg'),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem('Produto:', ficha.produto),
              _buildInfoItem('Variedade:', ficha.variedade),
              _buildInfoItem('Origem:', ficha.origem),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper para criar itens de informação
  pw.Widget _buildInfoItem(String label, String value) {
    return pw.Expanded(
      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: '$label ',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: value, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  /// Constrói a tabela de amostras
  pw.Widget _buildTabelaAmostras(List<AmostraDetalhada> amostras) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'RESUMO DAS AMOSTRAS',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green700,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FixedColumnWidth(60),
            1: const pw.FixedColumnWidth(80),
            2: const pw.FixedColumnWidth(100),
            3: const pw.FixedColumnWidth(80),
            4: const pw.FixedColumnWidth(80),
            5: const pw.FlexColumnWidth(),
          },
          children: [
            // Cabeçalho
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.green100),
              children: [
                _buildTableCell('Amostra', isHeader: true),
                _buildTableCell('Peso (g)', isHeader: true),
                _buildTableCell('Classe', isHeader: true),
                _buildTableCell('Área', isHeader: true),
                _buildTableCell('Status', isHeader: true),
                _buildTableCell('Observações', isHeader: true),
              ],
            ),
            // Dados das amostras
            ...amostras.map(
              (amostra) => pw.TableRow(
                children: [
                  _buildTableCell(amostra.letraAmostra),
                  _buildTableCell(
                    amostra.pesoLiquido?.toStringAsFixed(1) ?? '-',
                  ),
                  _buildTableCell(amostra.classe ?? '-'),
                  _buildTableCell(amostra.area ?? '-'),
                  _buildTableCell(_getStatusAmostra(amostra)),
                  _buildTableCell(
                    amostra.observacoes?.isNotEmpty == true
                        ? amostra.observacoes!
                        : '-',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Helper para criar células da tabela
  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }

  /// Obtém o status visual da amostra
  String _getStatusAmostra(AmostraDetalhada amostra) {
    if (amostra.pesoLiquido != null &&
        amostra.classe != null &&
        amostra.area != null) {
      return 'Completa';
    } else if (amostra.pesoLiquido != null ||
        amostra.classe != null ||
        amostra.area != null) {
      return 'Parcial';
    }
    return 'Vazia';
  }

  /// Constrói resumo estatístico
  pw.Widget _buildResumoEstatistico(List<AmostraDetalhada> amostras) {
    final amostrasCompletas = amostras
        .where((a) => _getStatusAmostra(a) == 'Completa')
        .length;
    final pesoTotal = amostras
        .where((a) => a.pesoLiquido != null)
        .fold<double>(0, (sum, a) => sum + (a.pesoLiquido ?? 0));
    final pesoMedio = amostras.isNotEmpty ? pesoTotal / amostras.length : 0;

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'RESUMO ESTATÍSTICO',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _buildStatItem('Total de Amostras:', amostras.length.toString()),
              _buildStatItem(
                'Amostras Completas:',
                amostrasCompletas.toString(),
              ),
              _buildStatItem('Peso Total:', '${pesoTotal.toStringAsFixed(1)}g'),
              _buildStatItem('Peso Médio:', '${pesoMedio.toStringAsFixed(1)}g'),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper para itens estatísticos
  pw.Widget _buildStatItem(String label, String value) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// Constrói seção de observações
  pw.Widget _buildObservacoes(Ficha ficha) {
    final observacoes = [
      if (ficha.observacaoA?.isNotEmpty == true) 'A: ${ficha.observacaoA}',
      if (ficha.observacaoB?.isNotEmpty == true) 'B: ${ficha.observacaoB}',
      if (ficha.observacaoC?.isNotEmpty == true) 'C: ${ficha.observacaoC}',
      if (ficha.observacaoD?.isNotEmpty == true) 'D: ${ficha.observacaoD}',
      if (ficha.observacaoF?.isNotEmpty == true) 'F: ${ficha.observacaoF}',
      if (ficha.observacaoG?.isNotEmpty == true) 'G: ${ficha.observacaoG}',
      if (ficha.observacoes.isNotEmpty) 'Geral: ${ficha.observacoes}',
    ];

    if (observacoes.isEmpty) return pw.SizedBox();

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'OBSERVAÇÕES',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.orange700,
            ),
          ),
          pw.SizedBox(height: 10),
          ...observacoes.map(
            (obs) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: pw.Text(obs, style: const pw.TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói detalhes de uma amostra específica
  pw.Widget _buildDetalhesAmostra(AmostraDetalhada amostra) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DETALHES DA AMOSTRA ${amostra.letraAmostra}',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green700,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _buildInfoItem(
                'Peso:',
                '${amostra.pesoLiquido?.toStringAsFixed(1) ?? '-'}g',
              ),
              _buildInfoItem('Classe:', amostra.classe ?? '-'),
              _buildInfoItem('Área:', amostra.area ?? '-'),
            ],
          ),
          if (amostra.observacoes?.isNotEmpty == true) ...[
            pw.SizedBox(height: 8),
            pw.Text(
              'Observações: ${amostra.observacoes!}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ],
      ),
    );
  }

  /// Constrói seção de defeitos da amostra
  pw.Widget _buildDefeitosAmostra(AmostraDetalhada amostra) {
    final defeitos = amostra.defeitosEncontrados;

    if (defeitos.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(15),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Text(
          'Nenhum defeito registrado para esta amostra.',
          style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
        ),
      );
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DEFEITOS IDENTIFICADOS',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red700,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              // Cabeçalho
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.red100),
                children: [
                  _buildTableCell('Tipo de Defeito', isHeader: true),
                  _buildTableCell('Valor', isHeader: true),
                  _buildTableCell('Unidade', isHeader: true),
                ],
              ),
              // Dados dos defeitos
              ...defeitos.map(
                (defeito) => pw.TableRow(
                  children: [
                    _buildTableCell(defeito['tipo'].toString()),
                    _buildTableCell(defeito['valor'].toStringAsFixed(1)),
                    _buildTableCell('%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Constrói seção de medidas da amostra
  pw.Widget _buildMedidasAmostra(AmostraDetalhada amostra) {
    final medidas = <Map<String, dynamic>>[];

    // Adiciona medidas disponíveis
    if (amostra.pesoLiquido != null) {
      medidas.add({
        'tipo': 'Peso Líquido',
        'valor': amostra.pesoLiquido!,
        'unidade': 'g',
      });
    }

    if (amostra.brixMedia != null) {
      medidas.add({
        'tipo': 'Brix (Média)',
        'valor': amostra.brixMedia!,
        'unidade': '°Bx',
      });
    }

    if (amostra.pesoBrutoMedia != null) {
      medidas.add({
        'tipo': 'Peso Bruto (Média)',
        'valor': amostra.pesoBrutoMedia!,
        'unidade': 'g',
      });
    }

    if (amostra.pesoEmbalagem != null) {
      medidas.add({
        'tipo': 'Peso Embalagem',
        'valor': amostra.pesoEmbalagem!,
        'unidade': 'g',
      });
    }

    if (amostra.bagaMm != null) {
      medidas.add({
        'tipo': 'Calibre Baga',
        'valor': amostra.bagaMm!,
        'unidade': 'mm',
      });
    }

    if (medidas.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(15),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Text(
          'Nenhuma medida registrada para esta amostra.',
          style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
        ),
      );
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'MEDIDAS REGISTRADAS',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              // Cabeçalho
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                children: [
                  _buildTableCell('Tipo de Medida', isHeader: true),
                  _buildTableCell('Valor', isHeader: true),
                  _buildTableCell('Unidade', isHeader: true),
                ],
              ),
              // Dados das medidas
              ...medidas.map(
                (medida) => pw.TableRow(
                  children: [
                    _buildTableCell(medida['tipo'].toString()),
                    _buildTableCell(medida['valor'].toStringAsFixed(2)),
                    _buildTableCell(medida['unidade'].toString()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Salva o PDF no dispositivo
  Future<File> _salvarPdf(pw.Document pdf, String nomeArquivo) async {
    final directoryManager = DirectoryManagerService();
    final pdfsDir = await directoryManager.pdfsDirectory;
    final file = File('${pdfsDir.path}/$nomeArquivo.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
