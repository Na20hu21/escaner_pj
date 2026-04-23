import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_receipt.freezed.dart';
part 'delivery_receipt.g.dart';

@freezed
abstract class DeliveryReceipt with _$DeliveryReceipt {
  const factory DeliveryReceipt({
    required String signaturePngPath,
    required String receiverName,
    required String receiverDni,
    required bool isThirdParty,
    required DateTime capturedAt,
    double? lat,
    double? lng,
  }) = _DeliveryReceipt;

  factory DeliveryReceipt.fromJson(Map<String, dynamic> json) =>
      _$DeliveryReceiptFromJson(json);
}
