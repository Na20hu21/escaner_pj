import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required UserRole role,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
