import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptService {
  static GlobalKey receiptKey = GlobalKey();

  static double total(double amount) {
    double total = amount - 2;
    return total;
  }

  static Future<void> downloadReceiptAsPDF() async {
    try {
      RenderRepaintBoundary boundary = receiptKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdfDoc = pw.Document();
      final imageProvider = pw.MemoryImage(pngBytes);

      pdfDoc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(imageProvider));
          },
        ),
      );

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfDoc.save());
    } catch (e) {
      print("Error generating PDF: $e");
    }
  }
}
