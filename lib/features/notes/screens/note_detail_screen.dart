import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snack_bar.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../auth/providers/auth_controller.dart';
import '../data/note.dart';
import '../data/note_history_entry.dart';
import '../data/note_status.dart';
import '../data/permission_guard.dart';
import '../providers/notes_provider.dart';
import 'note_edit_screen.dart';

class NoteDetailScreen extends ConsumerWidget {
  const NoteDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteByIdProvider(id));

    return noteAsync.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(message: e.toString()),
      ),
      data: (note) {
        if (note == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const EmptyView(
              icon: Icons.description_outlined,
              title: 'Nota no encontrada',
            ),
          );
        }

        final user = ref.watch(authControllerProvider).asData?.value;

        final canEdit = user != null;

        Future<void> deleteNote() async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Eliminar nota'),
              content: const Text(
                '¿Seguro que querés eliminar esta nota? Esta acción no se puede deshacer.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          );
          if (confirmed != true || !context.mounted) return;
          try {
            await ref.read(noteControllerProvider.notifier).delete(id);
            if (context.mounted) context.go('/home/notes');
          } catch (e) {
            if (context.mounted) AppSnackBar.error(context, 'Error: $e');
          }
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) context.go('/home/notes');
          },
          child: Scaffold(
          appBar: AppBar(
            title: const Text('Detalle de nota'),
            actions: [
              if (canEdit)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Editar nota',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NoteEditScreen(note: note),
                    ),
                  ),
                ),
              if (canEdit)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Eliminar nota',
                  onPressed: deleteNote,
                ),
              _ShareButton(note: note),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              // Documento
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: File(note.thumbnailPath).existsSync()
                            ? Image.file(
                                File(note.thumbnailPath),
                                width: 56,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 56,
                                  height: 64,
                                  color: AppColors.border,
                                  child: const Icon(Icons.description_outlined,
                                      color: AppColors.muted),
                                ),
                              )
                            : Container(
                                width: 56,
                                height: 64,
                                color: AppColors.border,
                                child: const Icon(Icons.description_outlined,
                                    color: AppColors.muted),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${note.pageCount} página${note.pageCount != 1 ? 's' : ''}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat(
                                      "d 'de' MMMM 'de' yyyy · HH:mm", 'es')
                                  .format(note.createdAt),
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.muted),
                            ),
                            if (note.updatedAt != null)
                              Text(
                                'Editada: ${DateFormat("d/MM/yy · HH:mm", 'es').format(note.updatedAt!)}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.muted,
                                    fontStyle: FontStyle.italic),
                              ),
                          ],
                        ),
                      ),
                      _StatusBadge(status: note.status),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Código de expediente
              if (note.codigoBarras.isNotEmpty)
                _InfoSection(
                  title: 'Código de expediente',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.qr_code_outlined,
                            size: 18, color: AppColors.muted),
                        const SizedBox(width: 8),
                        Text(
                          note.codigoBarras,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              if (note.codigoBarras.isNotEmpty) const SizedBox(height: 12),

              // Observaciones
              if (note.observations.isNotEmpty)
                _InfoSection(
                  title: 'Observaciones',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(note.observations),
                  ),
                ),
              if (note.observations.isNotEmpty) const SizedBox(height: 12),

              // Historial
              _InfoSection(
                title: 'Historial',
                child: _HistoryList(
                  entries: note.history,
                  note: note,
                  canEdit: user != null &&
                      PermissionGuard.canEditHistory(user),
                ),
              ),
            ],
          ),
          bottomNavigationBar: user != null
              ? _ActionBar(
                  noteId: id,
                  status: note.status,
                  user: user,
                  onStatusChanged: () => context.go('/home/notes'),
                )
              : null,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Share button
// ---------------------------------------------------------------------------

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share_outlined),
      tooltip: 'Compartir PDF',
      onPressed: () async {
        try {
          await Share.shareXFiles(
            [XFile(note.pdfPath)],
            subject: 'PDF notificación',
          );
        } catch (e) {
          if (context.mounted) AppSnackBar.error(context, 'Error: $e');
        }
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Action bar
// ---------------------------------------------------------------------------

class _ActionBar extends ConsumerWidget {
  const _ActionBar({
    required this.noteId,
    required this.status,
    required this.user,
    required this.onStatusChanged,
  });

  final String noteId;
  final NoteStatus status;
  final dynamic user; // User
  final VoidCallback onStatusChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteByIdProvider(noteId));
    final note = noteAsync.asData?.value;
    if (note == null) return const SizedBox.shrink();

    if (!PermissionGuard.canChangeNoteStatus(user, status, NoteStatus.entregado)) {
      return const SizedBox.shrink();
    }

    Future<void> setStatus(NoteStatus newStatus) async {
      try {
        await ref.read(noteControllerProvider.notifier).changeStatus(note, newStatus);
        onStatusChanged();
      } catch (e) {
        if (context.mounted) AppSnackBar.error(context, 'Error: $e');
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.help_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Estados de la nota'),
                    ],
                  ),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HelpItem(
                        icon: Icons.check_circle_outline,
                        label: 'Entregado',
                        description: 'Nota enviada con éxito.',
                      ),
                      SizedBox(height: 12),
                      _HelpItem(
                        icon: Icons.push_pin_outlined,
                        label: 'Fijado',
                        description: 'No había nadie en el domicilio.',
                      ),
                      SizedBox(height: 12),
                      _HelpItem(
                        icon: Icons.info_outline,
                        label: 'Informado',
                        description: 'Domicilio incorrecto.',
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.help_outline, size: 16, color: AppColors.muted),
                    SizedBox(width: 4),
                    Text(
                      '¿Qué significa cada estado?',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Entregado',
                    icon: Icons.check_circle_outline,
                    color: AppColors.statusDelivered,
                    selected: status == NoteStatus.entregado,
                    onTap: () => setStatus(NoteStatus.entregado),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    label: 'Fijado',
                    icon: Icons.push_pin_outlined,
                    color: AppColors.statusNotDelivered,
                    selected: status == NoteStatus.fijado,
                    onTap: () => setStatus(NoteStatus.fijado),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    label: 'Informado',
                    icon: Icons.info_outline,
                    color: AppColors.statusRejected,
                    selected: status == NoteStatus.informado,
                    onTap: () => setStatus(NoteStatus.informado),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 13)),
      );
    }
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared widgets
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final NoteStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 13, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.muted,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.entries,
    required this.note,
    required this.canEdit,
  });

  final List<NoteHistoryEntry> entries;
  final dynamic note; // Note
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('Sin registros', style: TextStyle(color: AppColors.muted)),
      );
    }

    final sorted = [...entries]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return Column(
      children: [
        for (int i = 0; i < sorted.length; i++)
          _HistoryEntry(
            entry: sorted[i],
            isLast: i == sorted.length - 1,
            note: note,
            canEdit: canEdit,
          ),
      ],
    );
  }
}

class _HistoryEntry extends ConsumerWidget {
  const _HistoryEntry({
    required this.entry,
    required this.isLast,
    required this.note,
    required this.canEdit,
  });

  final NoteHistoryEntry entry;
  final bool isLast;
  final dynamic note; // Note
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr =
        DateFormat("d 'de' MMMM HH:mm", 'es').format(entry.timestamp);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 4 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$dateStr — ${entry.event.label}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (canEdit)
                        Semantics(
                          label: 'Editar entrada de historial',
                          button: true,
                          child: InkWell(
                            onTap: () => _showEditDialog(context, ref),
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.edit_outlined,
                                  size: 16, color: AppColors.muted),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    entry.userName,
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  if (entry.reason != null)
                    Text(
                      'Motivo: ${entry.reason}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.muted),
                    ),
                  if (entry.observations != null)
                    Text(
                      'Obs: ${entry.observations}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.muted),
                    ),
                  if (entry.editedAt != null)
                    Text(
                      'Editado por ${entry.editedByName} · '
                      '${DateFormat("d/MM HH:mm", 'es').format(entry.editedAt!)}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                          fontStyle: FontStyle.italic),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog<_HistoryEditResult>(
      context: context,
      builder: (_) => _HistoryEditDialog(entry: entry),
    ).then((result) async {
      if (result == null || !context.mounted) return;
      try {
        await ref.read(noteControllerProvider.notifier).editHistoryEntry(
              note,
              entry.id,
              reason: result.reason.isEmpty ? null : result.reason,
              observations:
                  result.observations.isEmpty ? null : result.observations,
            );
        if (context.mounted) {
          AppSnackBar.success(context, 'Entrada editada');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    });
  }
}

// ---------------------------------------------------------------------------
// History edit dialog
// ---------------------------------------------------------------------------

class _HistoryEditResult {
  const _HistoryEditResult({required this.reason, required this.observations});
  final String reason;
  final String observations;
}

class _HistoryEditDialog extends StatefulWidget {
  const _HistoryEditDialog({required this.entry});

  final NoteHistoryEntry entry;

  @override
  State<_HistoryEditDialog> createState() => _HistoryEditDialogState();
}

class _HistoryEditDialogState extends State<_HistoryEditDialog> {
  late final TextEditingController _reasonCtrl;
  late final TextEditingController _obsCtrl;

  @override
  void initState() {
    super.initState();
    _reasonCtrl = TextEditingController(text: widget.entry.reason ?? '');
    _obsCtrl = TextEditingController(text: widget.entry.observations ?? '');
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _obsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar entrada de historial'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _reasonCtrl,
            decoration: const InputDecoration(
              labelText: 'Motivo',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _obsCtrl,
            decoration: const InputDecoration(
              labelText: 'Observaciones',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            _HistoryEditResult(
              reason: _reasonCtrl.text.trim(),
              observations: _obsCtrl.text.trim(),
            ),
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Help item
// ---------------------------------------------------------------------------

class _HelpItem extends StatelessWidget {
  const _HelpItem({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.muted),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
