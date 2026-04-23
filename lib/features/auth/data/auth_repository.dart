import 'user.dart';

abstract class AuthRepository {
  /// Intenta autenticar al usuario con email y password.
  /// Lanza [AuthException] si las credenciales son inválidas.
  Future<User> login(String email, String password);

  /// Cierra la sesión y limpia el almacenamiento local.
  Future<void> logout();

  /// Devuelve el usuario persistido localmente, o null si no hay sesión.
  Future<User?> getStoredUser();
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
