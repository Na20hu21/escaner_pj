import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth_repository.dart';
import 'user.dart';
import 'user_role.dart';

/// Implementación mock del repositorio de auth.
/// R9: devuelve Futures simulados con delay. Al tener backend real, solo
/// se reemplaza esta clase sin tocar providers ni UI.
class AuthRepositoryMock implements AuthRepository {
  static const _userKey = 'auth_user';

  // Usuarios disponibles en el mock
  static final _users = <String, ({String password, User user})>{
    'notificador@test.com': (
      password: '1234',
      user: const User(
        id: 'u1',
        name: 'Juan Notificador',
        email: 'notificador@test.com',
        role: UserRole.notificador,
      ),
    ),
    'supervisor@test.com': (
      password: '1234',
      user: const User(
        id: 'u2',
        name: 'María Supervisora',
        email: 'supervisor@test.com',
        role: UserRole.supervisor,
      ),
    ),
  };

  @override
  Future<User> login(String email, String password) async {
    await _simulateDelay();

    final entry = _users[email.toLowerCase().trim()];
    if (entry == null || entry.password != password) {
      throw const AuthException('Email o contraseña incorrectos.');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(entry.user.toJson()));

    return entry.user;
  }

  @override
  Future<void> logout() async {
    await _simulateDelay();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<User?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> _simulateDelay() async {
    final ms = 500 + Random().nextInt(300); // 500–800ms
    await Future<void>.delayed(Duration(milliseconds: ms));
  }
}
