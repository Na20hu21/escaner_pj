import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';

import 'captured_document.dart';

class PdfBuilder {
  PdfBuilder._();

  static const _uuid = Uuid();

  /// Genera un PDF con una página por imagen y guarda miniatura (copia de la
  /// primera imagen). Devuelve [CapturedDocument] con las rutas resultantes.
  static Future<CapturedDocument> build(List<String> imagePaths) async {
    assert(imagePaths.isNotEmpty, 'Se necesita al menos una imagen');

    final doc = pw.Document();

    for (final path in imagePaths) {
      final bytes = await File(path).readAsBytes();
      final image = pw.MemoryImage(bytes);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Image(image, fit: pw.BoxFit.contain),
        ),
      );
    }

    final dir = await getApplicationDocumentsDirectory();
    final notesDir = Directory('${dir.path}/notes');
    await notesDir.create(recursive: true);

    final id = _uuid.v4();
    final pdfPath = '${notesDir.path}/$id.pdf';
    final thumbnailPath = '${notesDir.path}/${id}_thumb.jpg';

    await File(pdfPath).writeAsBytes(await doc.save());
    await File(imagePaths.first).copy(thumbnailPath);

    return CapturedDocument(
      pdfPath: pdfPath,
      thumbnailPath: thumbnailPath,
      pageCount: imagePaths.length,
    );
  }
}
