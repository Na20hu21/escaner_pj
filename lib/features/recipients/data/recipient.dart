import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipient.freezed.dart';
part 'recipient.g.dart';

@freezed
abstract class Recipient with _$Recipient {
  const factory Recipient({
    required String id,
    required String name,
    required String dni,
    required String address,
    @Default('') String phone,
    @Default('') String observations,
    required DateTime createdAt,
  }) = _Recipient;

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);
}
