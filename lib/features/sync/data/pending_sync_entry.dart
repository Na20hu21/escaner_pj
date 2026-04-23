import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_sync_entry.freezed.dart';
part 'pending_sync_entry.g.dart';

@freezed
abstract class PendingSyncEntry with _$PendingSyncEntry {
  const factory PendingSyncEntry({
    required String id,
    required String noteId,
    double? lat,
    double? lng,
    required DateTime capturedAt,
    @Default(0) int retries,
    DateTime? syncedAt,
  }) = _PendingSyncEntry;

  factory PendingSyncEntry.fromJson(Map<String, dynamic> json) =>
      _$PendingSyncEntryFromJson(json);
}
