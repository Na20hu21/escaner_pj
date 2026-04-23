// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Note _$NoteFromJson(Map<String, dynamic> json) => _Note(
  id: json['id'] as String,
  recipientId: json['recipientId'] as String? ?? '',
  pdfPath: json['pdfPath'] as String,
  thumbnailPath: json['thumbnailPath'] as String,
  pageCount: (json['pageCount'] as num).toInt(),
  status: $enumDecode(_$NoteStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  observations: json['observations'] as String? ?? '',
  codigoBarras: json['codigoBarras'] as String? ?? '',
  history:
      (json['history'] as List<dynamic>?)
          ?.map((e) => NoteHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  imagePaths:
      (json['imagePaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isOfflineDraft: json['isOfflineDraft'] as bool? ?? false,
  deliveryReceipt: json['deliveryReceipt'] == null
      ? null
      : DeliveryReceipt.fromJson(
          json['deliveryReceipt'] as Map<String, dynamic>,
        ),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$NoteToJson(_Note instance) => <String, dynamic>{
  'id': instance.id,
  'recipientId': instance.recipientId,
  'pdfPath': instance.pdfPath,
  'thumbnailPath': instance.thumbnailPath,
  'pageCount': instance.pageCount,
  'status': _$NoteStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'observations': instance.observations,
  'codigoBarras': instance.codigoBarras,
  'history': instance.history.map((e) => e.toJson()).toList(),
  'imagePaths': instance.imagePaths,
  'isOfflineDraft': instance.isOfflineDraft,
  'deliveryReceipt': instance.deliveryReceipt?.toJson(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$NoteStatusEnumMap = {
  NoteStatus.pendiente: 'pendiente',
  NoteStatus.entregado: 'entregado',
  NoteStatus.fijado: 'fijado',
  NoteStatus.informado: 'informado',
};
