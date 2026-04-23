// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteHistoryEntry _$NoteHistoryEntryFromJson(Map<String, dynamic> json) =>
    _NoteHistoryEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      event: $enumDecode(_$NoteEventEnumMap, json['event']),
      fromStatus: $enumDecodeNullable(_$NoteStatusEnumMap, json['fromStatus']),
      toStatus: $enumDecodeNullable(_$NoteStatusEnumMap, json['toStatus']),
      reason: json['reason'] as String?,
      observations: json['observations'] as String?,
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      editedByName: json['editedByName'] as String?,
    );

Map<String, dynamic> _$NoteHistoryEntryToJson(_NoteHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'userId': instance.userId,
      'userName': instance.userName,
      'event': _$NoteEventEnumMap[instance.event]!,
      'fromStatus': _$NoteStatusEnumMap[instance.fromStatus],
      'toStatus': _$NoteStatusEnumMap[instance.toStatus],
      'reason': instance.reason,
      'observations': instance.observations,
      'editedAt': instance.editedAt?.toIso8601String(),
      'editedByName': instance.editedByName,
    };

const _$NoteEventEnumMap = {
  NoteEvent.creada: 'creada',
  NoteEvent.editada: 'editada',
  NoteEvent.estadoCambiado: 'estadoCambiado',
  NoteEvent.entregada: 'entregada',
  NoteEvent.rechazada: 'rechazada',
  NoteEvent.noEntregada: 'noEntregada',
  NoteEvent.reclamada: 'reclamada',
};

const _$NoteStatusEnumMap = {
  NoteStatus.pendiente: 'pendiente',
  NoteStatus.entregado: 'entregado',
  NoteStatus.fijado: 'fijado',
  NoteStatus.informado: 'informado',
};
