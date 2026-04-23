// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryReceipt _$DeliveryReceiptFromJson(Map<String, dynamic> json) =>
    _DeliveryReceipt(
      signaturePngPath: json['signaturePngPath'] as String,
      receiverName: json['receiverName'] as String,
      receiverDni: json['receiverDni'] as String,
      isThirdParty: json['isThirdParty'] as bool,
      capturedAt: DateTime.parse(json['capturedAt'] as String),
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DeliveryReceiptToJson(_DeliveryReceipt instance) =>
    <String, dynamic>{
      'signaturePngPath': instance.signaturePngPath,
      'receiverName': instance.receiverName,
      'receiverDni': instance.receiverDni,
      'isThirdParty': instance.isThirdParty,
      'capturedAt': instance.capturedAt.toIso8601String(),
      'lat': instance.lat,
      'lng': instance.lng,
    };
