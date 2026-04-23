import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'recipient.dart';
import 'recipient_repository.dart';

/// Implementación con Hive. Almacena cada Recipient como JSON string.
/// R9: cuando haya backend, se reemplaza esta clase sin tocar providers ni UI.
class RecipientRepositoryImpl implements RecipientRepository {
  static const _boxName = 'recipients';

  Future<Box<String>> get _box async => Hive.openBox<String>(_boxName);

  @override
  Future<List<Recipient>> getAll() async {
    final box = await _box;
    return box.values
        .map((raw) => Recipient.fromJson(jsonDecode(raw) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<Recipient?> getById(String id) async {
    final box = await _box;
    final raw = box.get(id);
    if (raw == null) return null;
    return Recipient.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(Recipient recipient) async {
    final box = await _box;
    await box.put(recipient.id, jsonEncode(recipient.toJson()));
  }

  @override
  Future<void> delete(String id) async {
    final box = await _box;
    await box.delete(id);
  }
}
