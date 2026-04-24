import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/widgets/loading_view.dart';
import '../../scanner/data/captured_document.dart';
import '../providers/notes_provider.dart';

/// Pantalla de creación de nota a partir de un código de barras.
/// Permite editar el código, adjuntar imágenes, elegir destinatario y agregar observaciones.
class NoteCreateFromBarcodeScreen extends ConsumerStatefulWidget {
  const NoteCreateFromBarcodeScreen({super.key, required this.barcodeValue});

  final String barcodeValue;

  @override
  ConsumerState<NoteCreateFromBarcodeScreen> createState() =>
      _NoteCreateFromBarcodeScreenState();
}

class _NoteCreateFromBarcodeScreenState
    extends ConsumerState<NoteCreateFromBarcodeScreen> {
  late final TextEditingController _barcodeCtrl;
  final _observationsCtrl = TextEditingController();
  final List<String> _imagePaths = [];
  bool _isSaving = false;

  final _picker = ImagePicker();
  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _barcodeCtrl = TextEditingController(text: widget.barcodeValue);
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _observationsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _imagePaths.add(picked.path));
    }
  }

  void _removeImage(int index) {
    setState(() => _imagePaths.removeAt(index));
  }

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

  /// Genera un PDF desde las imágenes adjuntas, o un PDF de texto si no hay imágenes.
  Future<CapturedDocument> _buildDocument() async {
    final dir = await getApplicationDocumentsDirectory();
    final notesDir = Directory('${dir.path}/notes');
    await notesDir.create(recursive: true);
    final id = _uuid.v4();

    if (_imagePaths.isNotEmpty) {
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
    } else {
      // Sin imágenes: PDF de una sola página con el código
      final codigo = _barcodeCtrl.text.trim();
      final doc = pw.Document();
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (_) => pw.Center(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  'Código de expediente',
                  style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  codigo,
                  style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );

      final pdfPath = '${notesDir.path}/$id.pdf';
      await File(pdfPath).writeAsBytes(await doc.save());

      return CapturedDocument(
        pdfPath: pdfPath,
        thumbnailPath: '',
        pageCount: 1,
      );
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);
    try {
      final document = await _buildDocument();
      final note = await ref.read(noteControllerProvider.notifier).create(
            document: document,
            observations: _observationsCtrl.text.trim(),
            codigoBarras: _barcodeCtrl.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop(note.id);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Error al guardar: $e');
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva nota')),
      body: _isSaving
          ? const LoadingView()
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Código de barras
                  const _SectionLabel(
                    icon: Icons.qr_code_outlined,
                    text: 'Código de expediente',
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _barcodeCtrl,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Número de expediente',
                      prefixIcon: Icon(Icons.tag_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Imágenes adjuntas
                  Row(
                    children: [
                      const _SectionLabel(
                        icon: Icons.photo_library_outlined,
                        text: 'Imágenes adjuntas',
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _showImageSourceSheet,
                        icon: const Icon(Icons.add_photo_alternate_outlined,
                            size: 18),
                        label: const Text('Agregar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_imagePaths.isEmpty)
                    _EmptyImagesHint(onTap: _showImageSourceSheet)
                  else
                    _ImageGrid(
                      paths: _imagePaths,
                      onRemove: _removeImage,
                      onAdd: _showImageSourceSheet,
                    ),
                  const SizedBox(height: 24),

                  // Observaciones
                  const _SectionLabel(
                    icon: Icons.notes_outlined,
                    text: 'Observaciones (opcional)',
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _observationsCtrl,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Ej: El destinatario no estaba presente…',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  FilledButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon: const Icon(Icons.check),
                    label: const Text(
                      'Crear nota',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

                ],
              ),
            ),
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

// ---------------------------------------------------------------------------
// Empty images hint
// ---------------------------------------------------------------------------

class _EmptyImagesHint extends StatelessWidget {
  const _EmptyImagesHint({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: AppColors.border,
              style: BorderStyle.solid),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 32, color: AppColors.muted),
            SizedBox(height: 6),
            Text(
              'Tocá para agregar imágenes (opcional)',
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Image grid
// ---------------------------------------------------------------------------

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({
    required this.paths,
    required this.onRemove,
    required this.onAdd,
  });

  final List<String> paths;
  final void Function(int index) onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: paths.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (i == paths.length) {
            return GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 80,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.add_photo_alternate_outlined,
                    color: AppColors.primary),
              ),
            );
          }
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(paths[i]),
                  width: 80,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () => onRemove(i),
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
    );
  }
}

