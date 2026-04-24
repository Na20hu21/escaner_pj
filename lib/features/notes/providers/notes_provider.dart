import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../auth/providers/auth_controller.dart';
import '../../scanner/data/captured_document.dart';
import '../data/note.dart';
import '../data/note_event.dart';
import '../data/note_history_entry.dart';
import '../data/note_repository.dart';
import '../data/note_repository_impl.dart';
import '../data/note_status.dart';
import '../data/permission_guard.dart';

part 'notes_provider.g.dart';

const _uuid = Uuid();

@riverpod
NoteRepository noteRepository(Ref ref) => NoteRepositoryImpl();

@riverpod
Future<List<Note>> notes(Ref ref) =>
    ref.read(noteRepositoryProvider).getAll();

@riverpod
Future<Note?> noteById(Ref ref, String id) =>
    ref.read(noteRepositoryProvider).getById(id);

@riverpod
Future<List<Note>> notesByRecipient(Ref ref, String recipientId) =>
    ref.read(noteRepositoryProvider).getByRecipientId(recipientId);

@Riverpod(keepAlive: true)
class NoteController extends _$NoteController {
  @override
  void build() {}

  Future<Note> create({
    required CapturedDocument document,
    String observations = '',
    String codigoBarras = '',
  }) async {
    final user = ref.read(authControllerProvider).asData?.value;
    if (user == null) throw StateError('No hay usuario autenticado');

    final now = DateTime.now();
    final note = Note(
      id: _uuid.v4(),
      pdfPath: document.pdfPath,
      thumbnailPath: document.thumbnailPath,
      pageCount: document.pageCount,
      status: NoteStatus.pendiente,
      createdAt: now,
      observations: observations,
      codigoBarras: codigoBarras,
      history: [
        NoteHistoryEntry(
          id: _uuid.v4(),
          timestamp: now,
          userId: user.id,
          userName: user.name,
          event: NoteEvent.creada,
        ),
      ],
    );

    await ref.read(noteRepositoryProvider).save(note);
    ref.invalidate(notesProvider);
    return note;
  }

  Future<void> updateNote(
    Note note, {
    String? observations,
    String? codigoBarras,
    List<String>? imagePaths,
    String? pdfPath,
    String? thumbnailPath,
    int? pageCount,
  }) async {
    final user = ref.read(authControllerProvider).asData?.value;
    if (user == null) throw StateError('No hay usuario autenticado');

    final now = DateTime.now();
    final updated = note.copyWith(
      observations: observations ?? note.observations,
      codigoBarras: codigoBarras ?? note.codigoBarras,
      imagePaths: imagePaths ?? note.imagePaths,
      pdfPath: pdfPath ?? note.pdfPath,
      thumbnailPath: thumbnailPath ?? note.thumbnailPath,
      pageCount: pageCount ?? note.pageCount,
      updatedAt: now,
      history: [
        ...note.history,
        NoteHistoryEntry(
          id: _uuid.v4(),
          timestamp: now,
          userId: user.id,
          userName: user.name,
          event: NoteEvent.editada,
        ),
      ],
    );

    await ref.read(noteRepositoryProvider).save(updated);
    ref.invalidate(notesProvider);
    ref.invalidate(noteByIdProvider(note.id));
  }

  Future<void> updateObservations(Note note, String observations) async {
    final user = ref.read(authControllerProvider).asData?.value;
    if (user == null) throw StateError('No hay usuario autenticado');

    final now = DateTime.now();
    final updated = note.copyWith(
      observations: observations,
      history: [
        ...note.history,
        NoteHistoryEntry(
          id: _uuid.v4(),
          timestamp: now,
          userId: user.id,
          userName: user.name,
          event: NoteEvent.editada,
        ),
      ],
    );

    await ref.read(noteRepositoryProvider).save(updated);
    ref.invalidate(notesProvider);
  }

  Future<void> changeStatus(
    Note note,
    NoteStatus newStatus, {
    String? reason,
    String? observations,
  }) async {
    final user = ref.read(authControllerProvider).asData?.value;
    if (user == null) throw StateError('No hay usuario autenticado');

    if (!PermissionGuard.canChangeNoteStatus(user, note.status, newStatus)) {
      throw StateError('No tiene permisos para realizar este cambio de estado');
    }

    final now = DateTime.now();
    final event = switch (newStatus) {
      NoteStatus.entregado => NoteEvent.entregada,
      NoteStatus.fijado => NoteEvent.estadoCambiado,
      NoteStatus.informado => NoteEvent.estadoCambiado,
      NoteStatus.pendiente => NoteEvent.estadoCambiado,
    };

    final updated = note.copyWith(
      status: newStatus,
      history: [
        ...note.history,
        NoteHistoryEntry(
          id: _uuid.v4(),
          timestamp: now,
          userId: user.id,
          userName: user.name,
          event: event,
          fromStatus: note.status,
          toStatus: newStatus,
          reason: reason,
          observations: observations,
        ),
      ],
    );

    await ref.read(noteRepositoryProvider).save(updated);
    ref.invalidate(notesProvider);
  }


  Future<void> editHistoryEntry(
    Note note,
    String entryId, {
    String? reason,
    String? observations,
  }) async {
    final user = ref.read(authControllerProvider).asData?.value;
    if (user == null) throw StateError('No hay usuario autenticado');
    if (!PermissionGuard.canEditHistory(user)) {
      throw StateError('Solo supervisores pueden editar el historial');
    }

    final now = DateTime.now();
    final updatedHistory = note.history.map((e) {
      if (e.id != entryId) return e;
      return e.copyWith(
        reason: reason,
        observations: observations,
        editedAt: now,
        editedByName: user.name,
      );
    }).toList();

    final updated = note.copyWith(history: updatedHistory);
    await ref.read(noteRepositoryProvider).save(updated);
    ref.invalidate(notesProvider);
    ref.invalidate(noteByIdProvider(note.id));
  }

  /// Crea una nota sin sesión activa. Se guarda marcada como borrador offline.
  Future<Note> createOfflineDraft({
    required CapturedDocument document,
    String observations = '',
    String codigoBarras = '',
    List<String> imagePaths = const [],
  }) async {
    final now = DateTime.now();
    final note = Note(
      id: _uuid.v4(),
      pdfPath: document.pdfPath,
      thumbnailPath: document.thumbnailPath,
      pageCount: document.pageCount,
      status: NoteStatus.pendiente,
      createdAt: now,
      observations: observations,
      codigoBarras: codigoBarras,
      imagePaths: imagePaths,
      isOfflineDraft: true,
      history: [
        NoteHistoryEntry(
          id: _uuid.v4(),
          timestamp: now,
          userId: '__offline__',
          userName: 'Sin sesión',
          event: NoteEvent.creada,
        ),
      ],
    );

    await ref.read(noteRepositoryProvider).save(note);
    ref.invalidate(notesProvider);
    return note;
  }

  /// Al iniciar sesión, asocia todos los borradores offline al usuario real.
  /// Retorna la cantidad de notas reclamadas.
  Future<int> claimOfflineDrafts() async {
    final user = ref.read(authControllerProvider).asData?.value;
    if (user == null) return 0;

    final repo = ref.read(noteRepositoryProvider);
    final all = await repo.getAll();
    final drafts = all.where((n) => n.isOfflineDraft).toList();

    for (final draft in drafts) {
      final now = DateTime.now();
      final updated = draft.copyWith(
        isOfflineDraft: false,
        history: [
          ...draft.history,
          NoteHistoryEntry(
            id: _uuid.v4(),
            timestamp: now,
            userId: user.id,
            userName: user.name,
            event: NoteEvent.reclamada,
          ),
        ],
      );
      await repo.save(updated);
    }

    if (drafts.isNotEmpty) ref.invalidate(notesProvider);
    return drafts.length;
  }

  Future<void> delete(String id) async {
    await ref.read(noteRepositoryProvider).delete(id);
    ref.invalidate(notesProvider);
  }
}
