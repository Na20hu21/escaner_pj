import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'pending_sync_entry.dart';

class SyncQueueRepository {
  static const _boxName = 'pending_sync';

  Future<Box<String>> _box() => Hive.openBox<String>(_boxName);

  Future<void> enqueue(PendingSyncEntry entry) async {
    final box = await _box();
    await box.put(entry.id, jsonEncode(entry.toJson()));
  }

  Future<List<PendingSyncEntry>> getPending() async {
    final box = await _box();
    return box.values
        .map((v) => PendingSyncEntry.fromJson(jsonDecode(v)))
        .where((e) => e.syncedAt == null)
        .toList();
  }

  Future<void> markSynced(String id) async {
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) return;
    final entry = PendingSyncEntry.fromJson(jsonDecode(raw));
    await box.put(id, jsonEncode(entry.copyWith(syncedAt: DateTime.now()).toJson()));
  }

  Future<void> incrementRetry(String id) async {
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) return;
    final entry = PendingSyncEntry.fromJson(jsonDecode(raw));
    await box.put(id, jsonEncode(entry.copyWith(retries: entry.retries + 1).toJson()));
  }
}
