import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/logout_button.dart';
import '../../scanner/widgets/barcode_scan_button.dart';
import '../../../core/theme/app_colors.dart';
import 'note_create_from_barcode_screen.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../data/note.dart';
import '../data/note_status.dart';
import '../providers/notes_provider.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  NoteStatus? _filter; // null = todas

  Future<void> _openScanner() async {
    final value = await scanBarcode(context);
    if (value == null || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteCreateFromBarcodeScreen(barcodeValue: value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
        actions: const [LogoutButton()],
      ),
      body: Column(
        children: [
          // Banner de borradores offline pendientes
          if (notesAsync.asData?.value.any((n) => n.isOfflineDraft) == true)
            Builder(builder: (_) {
              final count = notesAsync.asData!.value
                  .where((n) => n.isOfflineDraft)
                  .length;
              return Container(
                width: double.infinity,
                color: Colors.amber.shade50,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_off_outlined,
                        size: 18, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$count borrador${count == 1 ? '' : 'es'} offline sin asociar — iniciá sesión para vincularl${count == 1 ? 'o' : 'os'}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ),
              );
            }),
          _FilterBar(
            selected: _filter,
            onSelected: (s) => setState(() => _filter = s),
          ),
          Expanded(
            child: notesAsync.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(message: e.toString()),
              data: (notes) {
                final filtered = _filter == null
                    ? notes
                    : notes.where((n) => n.status == _filter).toList();

                if (filtered.isEmpty) {
                  return EmptyView(
                    icon: Icons.description_outlined,
                    title: _filter == null
                        ? 'No hay notas aún'
                        : 'Sin notas con ese estado',
                    subtitle: _filter == null
                        ? 'Tocá Escanear para crear la primera'
                        : null,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox.shrink(),
                  itemBuilder: (context, i) => _NoteTile(note: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'notes-scan-fab',
        onPressed: _openScanner,
        icon: const Icon(Icons.camera_alt_outlined),
        label: const Text('Escanear'),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter bar
// ---------------------------------------------------------------------------

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelected});

  final NoteStatus? selected;
  final ValueChanged<NoteStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _Chip(
            label: 'Todas',
            selected: selected == null,
            onTap: () => onSelected(null),
            color: AppColors.primary,
          ),
          ...NoteStatus.values.map(
            (s) => _Chip(
              label: s.label,
              selected: selected == s,
              onTap: () => onSelected(s),
              color: s.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? color : AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Note tile
// ---------------------------------------------------------------------------

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(
      "d 'de' MMMM · HH:mm",
      'es',
    ).format(note.createdAt);

    final title = note.codigoBarras.isNotEmpty
        ? note.codigoBarras
        : 'Sin código';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: File(note.thumbnailPath).existsSync()
            ? Image.file(
                File(note.thumbnailPath),
                width: 48,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 48,
                  height: 56,
                  color: AppColors.border,
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppColors.muted,
                  ),
                ),
              )
            : Container(
                width: 48,
                height: 56,
                color: AppColors.border,
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.muted,
                ),
              ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            dateStr,
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
          const SizedBox(height: 4),
          _StatusChip(status: note.status),
        ],
      ),
      trailing: Text(
        '${note.pageCount} pág.',
        style: const TextStyle(fontSize: 12, color: AppColors.muted),
      ),
      onTap: () =>
          context.pushNamed('note-detail', pathParameters: {'id': note.id}),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final NoteStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}
