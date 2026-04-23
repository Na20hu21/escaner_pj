// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_sync_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PendingSyncEntry _$PendingSyncEntryFromJson(Map<String, dynamic> json) =>
    _PendingSyncEntry(
      id: json['id'] as String,
      noteId: json['noteId'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      capturedAt: DateTime.parse(json['capturedAt'] as String),
      retries: (json['retries'] as num?)?.toInt() ?? 0,
      syncedAt: json['syncedAt'] == null
          ? null
          : DateTime.parse(json['syncedAt'] as String),
    );

Map<String, dynamic> _$PendingSyncEntryToJson(_PendingSyncEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'lat': instance.lat,
      'lng': instance.lng,
      'capturedAt': instance.capturedAt.toIso8601String(),
      'retries': instance.retries,
      'syncedAt': instance.syncedAt?.toIso8601String(),
    };
