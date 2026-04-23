import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_controller.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/notes/screens/note_create_screen.dart';
import '../../features/notes/screens/note_detail_screen.dart';
import '../../features/notes/screens/notes_list_screen.dart';
import '../../features/scanner/data/captured_document.dart';
import '../../features/scanner/screens/barcode_scanner_screen.dart';
import '../widgets/home_shell.dart';

/// R3: rutas centralizadas. Nada de Navigator.push en features (excepto modales).
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const notes = '/home/notes';
  static const scanner = '/scanner';

  static String noteDetailPath(String id) => '/home/notes/$id';
}

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(authControllerProvider, (previous, next) => notifyListeners());
  }
  final Ref _ref;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final isSplash = location == AppRoutes.splash;
      final isLogin = location == AppRoutes.login;

      // Mientras carga: mostrar splash
      if (authState.isLoading) {
        return isSplash ? null : AppRoutes.splash;
      }

      final isLoggedIn = authState.asData?.value != null;

      // Auth resolvió: salir del splash al destino correcto
      if (isSplash) {
        return isLoggedIn ? AppRoutes.notes : AppRoutes.login;
      }

      // Guard de rutas protegidas
      if (!isLoggedIn && !isLogin) return AppRoutes.login;
      if (isLoggedIn && isLogin) return AppRoutes.notes;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.scanner,
        name: 'scanner',
        builder: (context, state) => const BarcodeScannerScreen(),
      ),

      // Shell: Notas
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.notes,
                name: 'notes',
                builder: (context, state) => const NotesListScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: 'note-create',
                    builder: (context, state) => NoteCreateScreen(
                      document: state.extra! as CapturedDocument,
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    name: 'note-detail',
                    builder: (context, state) => NoteDetailScreen(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
