import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../recipients/data/recipient.dart';
import 'note.dart';

class PdfExportService {
  const PdfExportService._();

  /// Genera un PDF con metadata de la nota (destinatario, estado, historial,
  /// recibo de entrega) y lo guarda en el directorio de documentos de la app.
  /// Retorna el path del archivo generado.
  static Future<String> generateNoteReport(
      Note note, Recipient recipient) async {
    final pdf = pw.Document();
    final dateFmt = DateFormat("d 'de' MMMM 'de' yyyy · HH:mm", 'es');

    // Firma (si existe)
    pw.MemoryImage? signatureImage;
    final receipt = note.deliveryReceipt;
    if (receipt != null) {
      final sigFile = File(receipt.signaturePngPath);
      if (sigFile.existsSync()) {
        signatureImage = pw.MemoryImage(await sigFile.readAsBytes());
      }
    }

    final sortedHistory = [...note.history]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Constancia de Notificación',
              style: pw.TextStyle(
                  fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              'Generado: ${dateFmt.format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
            pw.Divider(color: PdfColors.grey400),
            pw.SizedBox(height: 4),
          ],
        ),
        build: (context) => [
          // Destinatario
          _sectionTitle('Destinatario'),
          _row('Nombre', recipient.name),
          _row('DNI', recipient.dni),
          _row('Dirección', recipient.address),
          if (recipient.phone.isNotEmpty) _row('Teléfono', recipient.phone),
          if (recipient.observations.isNotEmpty)
            _row('Observaciones', recipient.observations),
          pw.SizedBox(height: 14),

          // Estado
          _sectionTitle('Estado de la notificación'),
          _row('Estado', note.status.label),
          _row('Creada', dateFmt.format(note.createdAt)),
          if (note.observations.isNotEmpty)
            _row('Observaciones', note.observations),
          pw.SizedBox(height: 14),

          // Recibo de entrega
          if (receipt != null) ...[
            _sectionTitle('Recibo de entrega'),
            _row('Receptor', receipt.receiverName),
            _row('DNI receptor', receipt.receiverDni),
            _row('Tercero', receipt.isThirdParty ? 'Sí' : 'No'),
            _row('Fecha de entrega', dateFmt.format(receipt.capturedAt)),
            if (signatureImage != null) ...[
              pw.SizedBox(height: 6),
              pw.Text('Firma:',
                  style: const pw.TextStyle(
                      fontSize: 9, color: PdfColors.grey700)),
              pw.SizedBox(height: 4),
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(4)),
                ),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Image(signatureImage, height: 80),
              ),
            ],
            pw.SizedBox(height: 14),
          ],

          // Historial
          _sectionTitle('Historial de eventos'),
          ...sortedHistory.map(
            (e) {
              final parts = <String>[
                '${dateFmt.format(e.timestamp)} — ${e.event.label}',
                '(${e.userName})',
                if (e.reason != null) 'Motivo: ${e.reason}',
                if (e.observations != null) 'Obs: ${e.observations}',
                if (e.editedAt != null)
                  '[Editado por ${e.editedByName}]',
              ];
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('• ',
                        style: const pw.TextStyle(fontSize: 10)),
                    pw.Expanded(
                      child: pw.Text(
                        parts.join(' '),
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/constancia_${note.id}.pdf';
    await File(path).writeAsBytes(await pdf.save());
    return path;
  }

  static pw.Widget _sectionTitle(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Text(
          text.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
            letterSpacing: 0.6,
          ),
        ),
      );

  static pw.Widget _row(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 3),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 110,
              child: pw.Text(
                '$label:',
                style: const pw.TextStyle(
                    fontSize: 10, color: PdfColors.grey700),
              ),
            ),
            pw.Expanded(
              child: pw.Text(value,
                  style: const pw.TextStyle(fontSize: 10)),
            ),
          ],
        ),
      );
}
