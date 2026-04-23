import 'package:freezed_annotation/freezed_annotation.dart';

import 'note_event.dart';
import 'note_status.dart';

part 'note_history_entry.freezed.dart';
part 'note_history_entry.g.dart';

@freezed
abstract class NoteHistoryEntry with _$NoteHistoryEntry {
  const factory NoteHistoryEntry({
    required String id,
    required DateTime timestamp,
    required String userId,
    required String userName,
    required NoteEvent event,
    NoteStatus? fromStatus,
    NoteStatus? toStatus,
    String? reason,
    String? observations,
    // Auditoría de edición (solo supervisores pueden editar entradas)
    DateTime? editedAt,
    String? editedByName,
  }) = _NoteHistoryEntry;

  factory NoteHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$NoteHistoryEntryFromJson(_migrateNoteHistoryJson(json));
}

/// Renombres de valores de NoteStatus que existieron en versiones anteriores.
const _statusMigrations = <String, String>{
  'entregada': 'entregado', // renombrado de femenino a masculino
};

Map<String, dynamic> _migrateNoteHistoryJson(Map<String, dynamic> json) {
  String? migrate(dynamic v) =>
      v is String ? (_statusMigrations[v] ?? v) : v as String?;

  return {
    ...json,
    if (json.containsKey('fromStatus')) 'fromStatus': migrate(json['fromStatus']),
    if (json.containsKey('toStatus')) 'toStatus': migrate(json['toStatus']),
  };
}
