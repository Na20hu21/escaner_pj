import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth_repository.dart';
import '../data/user.dart';
import '../data/user_role.dart';

part 'auth_controller.g.dart';

// ---------------------------------------------------------------------------
// Credenciales mock
// ---------------------------------------------------------------------------
const _mockUsers = <String, ({String password, Map<String, dynamic> user})>{
  'notificador@test.com': (
    password: '1234',
    user: {
      'id': 'u1',
      'name': 'Juan Notificador',
      'email': 'notificador@test.com',
      'role': 'notificador',
    },
  ),
  'supervisor@test.com': (
    password: '1234',
    user: {
      'id': 'u2',
      'name': 'María Supervisora',
      'email': 'supervisor@test.com',
      'role': 'supervisor',
    },
  ),
};

const _userKey = 'auth_user';

// ---------------------------------------------------------------------------
// Controller
// ---------------------------------------------------------------------------

/// Estado global de autenticación.
/// - null  → no hay sesión activa
/// - User  → usuario logueado
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<User?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return _userFromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final entry = _mockUsers[email.toLowerCase().trim()];
      if (entry == null || entry.password != password) {
        throw const AuthException('Email o contraseña incorrectos.');
      }

      final user = _userFromJson(entry.user);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(entry.user));
      return user;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    state = const AsyncValue.data(null);
  }

  // -------------------------------------------------------------------------

  User _userFromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere((r) => r.name == json['role']),
    );
  }
}
