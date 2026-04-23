// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Estado global de autenticación.
/// - null  → no hay sesión activa
/// - User  → usuario logueado

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Estado global de autenticación.
/// - null  → no hay sesión activa
/// - User  → usuario logueado
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, User?> {
  /// Estado global de autenticación.
  /// - null  → no hay sesión activa
  /// - User  → usuario logueado
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'34b002b583080dad03e68cd6a01f1390fd94a016';

/// Estado global de autenticación.
/// - null  → no hay sesión activa
/// - User  → usuario logueado

abstract class _$AuthController extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
