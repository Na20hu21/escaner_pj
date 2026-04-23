import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/widgets/loading_view.dart';
import '../../scanner/data/captured_document.dart';
import '../providers/notes_provider.dart';

/// Paso 2 del flujo de creación de nota.
/// Recibe [CapturedDocument] via GoRouter extra.
class NoteCreateScreen extends ConsumerStatefulWidget {
  const NoteCreateScreen({super.key, required this.document});

  final CapturedDocument document;

  @override
  ConsumerState<NoteCreateScreen> createState() => _NoteCreateScreenState();
}

class _NoteCreateScreenState extends ConsumerState<NoteCreateScreen> {
  final _observationsCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _observationsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);
    try {
      final note = await ref.read(noteControllerProvider.notifier).create(
            document: widget.document,
            observations: _observationsCtrl.text.trim(),
          );

      if (mounted) {
        context.goNamed('note-detail', pathParameters: {'id': note.id});
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
      body: Column(
        children: [
          // Paso indicator
          _StepBanner(),

          Expanded(
            child: _isSaving
                ? const LoadingView()
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Documento escaneado
                        _DocumentCard(document: widget.document),
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
                            hintText: 'Ingresá una observación…',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Botón crear
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

                        const SizedBox(height: 8),
                        Text(
                          'La nota quedará en estado Pendiente',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.muted),
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
// Step banner
// ---------------------------------------------------------------------------

class _StepBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.06),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _StepDot(label: '1', done: true),
          const SizedBox(width: 6),
          const Text('Escanear',
              style:
                  TextStyle(fontSize: 12, color: AppColors.statusDelivered)),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Divider(thickness: 1.5, color: AppColors.statusDelivered),
            ),
          ),
          _StepDot(label: '2', done: false, active: true),
          const SizedBox(width: 6),
          Text(
            'Completar datos',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.done,
    this.active = false,
  });

  final String label;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    if (done) {
      return const CircleAvatar(
        radius: 11,
        backgroundColor: AppColors.statusDelivered,
        child: Icon(Icons.check, size: 14, color: Colors.white),
      );
    }
    return CircleAvatar(
      radius: 11,
      backgroundColor:
          active ? AppColors.primary : AppColors.muted.withValues(alpha: 0.3),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
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
// Document card
// ---------------------------------------------------------------------------

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});

  final CapturedDocument document;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.statusDelivered.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Documento escaneado',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.statusDelivered),
                ),
                Text(
                  '${document.pageCount} página${document.pageCount != 1 ? 's' : ''} · PDF listo',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.statusDelivered),
                ),
              ],
            ),
          ),
          if (File(document.thumbnailPath).existsSync())
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(
                File(document.thumbnailPath),
                width: 44,
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
