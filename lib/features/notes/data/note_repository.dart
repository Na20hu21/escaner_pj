import 'note.dart';

abstract class NoteRepository {
  Future<List<Note>> getAll();
  Future<Note?> getById(String id);
  Future<List<Note>> getByRecipientId(String recipientId);
  Future<void> save(Note note);
  Future<void> delete(String id);
}
