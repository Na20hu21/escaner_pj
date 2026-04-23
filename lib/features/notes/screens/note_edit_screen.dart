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
import '../data/note.dart';
import '../providers/notes_provider.dart';

/// Pantalla para editar los datos de una nota existente:
/// código de expediente, imágenes y observaciones.
class NoteEditScreen extends ConsumerStatefulWidget {
  const NoteEditScreen({super.key, required this.note});

  final Note note;

  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  late final TextEditingController _barcodeCtrl;
  late final TextEditingController _observationsCtrl;
  late List<String> _imagePaths;
  bool _isSaving = false;

  final _picker = ImagePicker();
  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _barcodeCtrl = TextEditingController(text: widget.note.codigoBarras);
    _observationsCtrl =
        TextEditingController(text: widget.note.observations);
    _imagePaths = List<String>.from(widget.note.imagePaths);
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _observationsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);
    try {
      String? newPdfPath;
      String? newThumbnailPath;
      int? newPageCount;

      final imagesChanged = !_listsEqual(_imagePaths, widget.note.imagePaths);
      if (imagesChanged && _imagePaths.isNotEmpty) {
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

        newPdfPath = '${notesDir.path}/$id.pdf';
        newThumbnailPath = '${notesDir.path}/${id}_thumb.jpg';
        await File(newPdfPath).writeAsBytes(await doc.save());
        await File(_imagePaths.first).copy(newThumbnailPath);
        newPageCount = _imagePaths.length;
      }

      await ref.read(noteControllerProvider.notifier).updateNote(
            widget.note,
            observations: _observationsCtrl.text.trim(),
            codigoBarras: _barcodeCtrl.text.trim(),
            imagePaths: _imagePaths,
            pdfPath: newPdfPath,
            thumbnailPath: newThumbnailPath,
            pageCount: newPageCount,
          );

      if (mounted) {
        AppSnackBar.success(context, 'Nota actualizada');
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Error al guardar: $e');
        setState(() => _isSaving = false);
      }
    }
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) setState(() => _imagePaths.add(picked.path));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar nota'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: const Text(
              'Guardar',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: _isSaving
          ? const LoadingView()
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Código de expediente
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
                      hintText: 'Número de expediente (opcional)',
                      prefixIcon: Icon(Icons.tag_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Imágenes
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
                    GestureDetector(
                      onTap: _showImageSourceSheet,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Text(
                            'Tocá para agregar imágenes',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.muted),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 96,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imagePaths.length + 1,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          if (i == _imagePaths.length) {
                            return GestureDetector(
                              onTap: _showImageSourceSheet,
                              child: Container(
                                width: 80,
                                height: 96,
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.06),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  border:
                                      Border.all(color: AppColors.border),
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
                                child: Image.file(
                                  File(_imagePaths[i]),
                                  width: 80,
                                  height: 96,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () => _removeImage(i),
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        size: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
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
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Ingresá una observación…',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  FilledButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text(
                      'Guardar cambios',
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
