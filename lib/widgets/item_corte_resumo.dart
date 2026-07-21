// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class ItemCorteResumo {
  final String tipo;
  final String codigo;
  final String cor;
  final String pesoFormatado;

  ItemCorteResumo({
    required this.tipo,
    required this.codigo,
    required this.cor,
    required this.pesoFormatado,
  });
}
class CorteResumoPdf {
  Future<Uint8List> gerarPdfPedido({
    required String codPedido,
    required List<ItemCorteResumo> itens,
  }) async {
    final pdf = pw.Document();
    final horario = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Pedido $codPedido',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Emitido em: $horario',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: ['Tipo', 'Ref', 'Cor', 'Peso Total'],
                data: itens
                    .map((i) => [i.tipo, i.codigo, i.cor, i.pesoFormatado])
                    .toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
                border: pw.TableBorder.all(color: PdfColors.grey400),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
/* 
 String _formatarPesoComPonto(double valor) {
    final inteiro = valor.round();
    final str = inteiro.toString();
    final digitos = str.length;

    // Menos de 4 dígitos: sem ponto, mostra como está
    if (digitos <= 3) {
      return str;
    }

    final posicaoPonto = digitos - 3;
    final parteInteira = str.substring(0, posicaoPonto);
    final parteDecimal = str.substring(posicaoPonto);

    return '$parteInteira.$parteDecimal';
  }
 */