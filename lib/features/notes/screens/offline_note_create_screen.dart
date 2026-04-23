import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/widgets/loading_view.dart';
import '../../scanner/data/captured_document.dart';
import '../../scanner/widgets/barcode_scan_button.dart';
import '../providers/notes_provider.dart';

/// Pantalla de creación de nota sin sesión activa.
/// La nota se guarda como borrador offline y se asocia al usuario cuando inicia sesión.
class OfflineNoteCreateScreen extends ConsumerStatefulWidget {
  const OfflineNoteCreateScreen({super.key});

  @override
  ConsumerState<OfflineNoteCreateScreen> createState() =>
      _OfflineNoteCreateScreenState();
}

class _OfflineNoteCreateScreenState
    extends ConsumerState<OfflineNoteCreateScreen> {
  final _barcodeCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final List<String> _imagePaths = [];
  CapturedDocument? _scannedDocument;
  bool _isSaving = false;

  final _picker = ImagePicker();
  static const _uuid = Uuid();

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _observationsCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Documento / imágenes
  // ---------------------------------------------------------------------------

  Future<void> _scanDocument() async {
    final value = await scanBarcode(context);
    if (value != null && mounted) {
      setState(() => _barcodeCtrl.text = value);
    }
  }

Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _scannedDocument = null; // si agrega imágenes sueltas, limpiamos doc
        _imagePaths.add(picked.path);
      });
    }
  }

  void _removeImage(int index) => setState(() => _imagePaths.removeAt(index));

  Future<void> _showImageSourceSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Guardar
  // ---------------------------------------------------------------------------

  Future<CapturedDocument> _buildDocument() async {
    // Caso 1: se usó el scanner de documentos
    if (_scannedDocument != null) return _scannedDocument!;

    // Caso 2: imágenes sueltas → armar PDF
    if (_imagePaths.isNotEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final notesDir = Directory('${dir.path}/notes');
      await notesDir.create(recursive: true);
      final id = _uuid.v4();

      final doc = pw.Document();
      for (final path in _imagePaths) {
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

      final pdfPath = '${notesDir.path}/$id.pdf';
      final thumbnailPath = '${notesDir.path}/${id}_thumb.jpg';
      await File(pdfPath).writeAsBytes(await doc.save());
      await File(_imagePaths.first).copy(thumbnailPath);

      return CapturedDocument(
        pdfPath: pdfPath,
        thumbnailPath: thumbnailPath,
        pageCount: _imagePaths.length,
      );
    }

    // Caso 3: solo código de barras, sin imágenes
    final dir = await getApplicationDocumentsDirectory();
    final notesDir = Directory('${dir.path}/notes');
    await notesDir.create(recursive: true);
    final id = _uuid.v4();
    final codigo = _barcodeCtrl.text.trim();

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Center(
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text('Código de expediente',
                  style: pw.TextStyle(
                      fontSize: 14, color: PdfColors.grey700)),
              pw.SizedBox(height: 12),
              pw.Text(codigo,
                  style: pw.TextStyle(
                      fontSize: 32, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
      ),
    );

    final pdfPath = '${notesDir.path}/$id.pdf';
    final thumbnailPath = '${notesDir.path}/${id}_thumb.jpg';
    await File(pdfPath).writeAsBytes(await doc.save());
    await File(pdfPath).copy(thumbnailPath);

    return CapturedDocument(
      pdfPath: pdfPath,
      thumbnailPath: thumbnailPath,
      pageCount: 1,
    );
  }

  Future<void> _save() async {
    if (_isSaving) return;
    if (_scannedDocument == null &&
        _imagePaths.isEmpty &&
        _barcodeCtrl.text.trim().isEmpty) {
      AppSnackBar.error(
          context, 'Agregá un documento, imágenes o código de expediente');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final document = await _buildDocument();
      await ref.read(noteControllerProvider.notifier).createOfflineDraft(
            document: document,
            observations: _observationsCtrl.text.trim(),
            codigoBarras: _barcodeCtrl.text.trim(),
            imagePaths: _imagePaths,
          );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Error al guardar: $e');
        setState(() => _isSaving = false);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva nota (sin sesión)'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: const Text('Guardar',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: _isSaving
          ? const LoadingView()
          : Column(
              children: [
                // Banner informativo
                Container(
                  width: double.infinity,
                  color: Colors.amber.shade50,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 18, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Esta nota se guardará localmente. '
                          'Al iniciar sesión quedará asociada a tu usuario.',
                          style: TextStyle(
                              fontSize: 12, color: Colors.amber.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Documento
                        _SectionLabel(
                          icon: Icons.description_outlined,
                          text: 'Documento',
                        ),
                        const SizedBox(height: 8),
                        _DocumentSection(
                          scannedDocument: _scannedDocument,
                          imagePaths: _imagePaths,
                          onScanDocument: _scanDocument,
                          onAddImage: _showImageSourceSheet,
                          onRemoveImage: _removeImage,
                        ),
                        const SizedBox(height: 24),

                        // Código de expediente
                        _SectionLabel(
                          icon: Icons.qr_code_outlined,
                          text: 'Código de expediente (opcional)',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _barcodeCtrl,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Número de expediente',
                                  prefixIcon: Icon(Icons.tag_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            BarcodeScanButton(
                              onScanned: (value) =>
                                  setState(() => _barcodeCtrl.text = value),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Observaciones
                        _SectionLabel(
                          icon: Icons.notes_outlined,
                          text: 'Observaciones (opcional)',
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _observationsCtrl,
                          maxLines: 3,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Ej: El destinatario no estaba…',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 32),

                        FilledButton.icon(
                          onPressed: _isSaving ? null : _save,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Guardar borrador',
                              style: TextStyle(fontSize: 16)),
                          style: FilledButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Document section
// ---------------------------------------------------------------------------

class _DocumentSection extends StatelessWidget {
  const _DocumentSection({
    required this.scannedDocument,
    required this.imagePaths,
    required this.onScanDocument,
    required this.onAddImage,
    required this.onRemoveImage,
  });

  final CapturedDocument? scannedDocument;
  final List<String> imagePaths;
  final VoidCallback onScanDocument;
  final VoidCallback onAddImage;
  final void Function(int) onRemoveImage;

  @override
  Widget build(BuildContext context) {
    if (scannedDocument != null) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.statusDelivered.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: AppColors.statusDelivered.withValues(alpha: 0.4)),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.check_circle,
                color: AppColors.statusDelivered, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${scannedDocument!.pageCount} página${scannedDocument!.pageCount != 1 ? 's' : ''} escaneadas',
                style: const TextStyle(
                    color: AppColors.statusDelivered,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onScanDocument,
                icon: const Icon(Icons.document_scanner_outlined, size: 18),
                label: const Text('Escanear documento'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onAddImage,
                icon: const Icon(Icons.add_photo_alternate_outlined,
                    size: 18),
                label: const Text('Agregar imagen'),
              ),
            ),
          ],
        ),
        if (imagePaths.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: imagePaths.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == imagePaths.length) {
                  return GestureDetector(
                    onTap: onAddImage,
                    child: Container(
                      width: 80,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: AppColors.primary),
                    ),
                  );
                }
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(imagePaths[i]),
                          width: 80, height: 96, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () => onRemoveImage(i),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section label
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

