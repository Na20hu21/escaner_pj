import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'note.dart';
import 'note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  static const _boxName = 'notes';

  Future<Box<String>> get _box async => Hive.openBox<String>(_boxName);

  @override
  Future<List<Note>> getAll() async {
    final box = await _box;
    return box.values
        .map((raw) => Note.fromJson(jsonDecode(raw) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Note?> getById(String id) async {
    final box = await _box;
    final raw = box.get(id);
    if (raw == null) return null;
    return Note.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<List<Note>> getByRecipientId(String recipientId) async {
    final all = await getAll();
    return all.where((n) => n.recipientId == recipientId).toList();
  }

  @override
  Future<void> save(Note note) async {
    final box = await _box;
    await box.put(note.id, jsonEncode(note.toJson()));
  }

  @override
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }
}
