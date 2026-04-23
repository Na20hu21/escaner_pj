import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_controller.dart';

/// Botón de cerrar sesión para usar en AppBars.
class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Cerrar sesión',
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content:
                const Text('¿Estás seguro que querés cerrar la sesión?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(dialogContext, rootNavigator: true)
                        .pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.of(dialogContext, rootNavigator: true)
                        .pop(true),
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await ref.read(authControllerProvider.notifier).logout();
        }
      },
    );
  }
}
