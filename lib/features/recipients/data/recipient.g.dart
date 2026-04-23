// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipient _$RecipientFromJson(Map<String, dynamic> json) => _Recipient(
  id: json['id'] as String,
  name: json['name'] as String,
  dni: json['dni'] as String,
  address: json['address'] as String,
  phone: json['phone'] as String? ?? '',
  observations: json['observations'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RecipientToJson(_Recipient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dni': instance.dni,
      'address': instance.address,
      'phone': instance.phone,
      'observations': instance.observations,
      'createdAt': instance.createdAt.toIso8601String(),
    };
