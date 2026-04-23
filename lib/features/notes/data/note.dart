import 'package:freezed_annotation/freezed_annotation.dart';

import 'delivery_receipt.dart';
import 'note_history_entry.dart';
import 'note_status.dart';

part 'note.freezed.dart';
part 'note.g.dart';

const _noteStatusMigrations = <String, String>{
  'entregada': 'entregado',
};

Map<String, dynamic> _migrateNoteJson(Map<String, dynamic> json) {
  final status = json['status'];
  if (status is String && _noteStatusMigrations.containsKey(status)) {
    return {...json, 'status': _noteStatusMigrations[status]};
  }
  return json;
}

@freezed
abstract class Note with _$Note {
  const factory Note({
    required String id,
    @Default('') String recipientId,
    required String pdfPath,
    required String thumbnailPath,
    required int pageCount,
    required NoteStatus status,
    required DateTime createdAt,
    @Default('') String observations,
    @Default('') String codigoBarras,
    @Default([]) List<NoteHistoryEntry> history,
    @Default([]) List<String> imagePaths,
    @Default(false) bool isOfflineDraft,
    DeliveryReceipt? deliveryReceipt,
    DateTime? updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) =>
      _$NoteFromJson(_migrateNoteJson(json));
}
