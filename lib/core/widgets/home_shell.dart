import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/sync/providers/sync_queue_controller.dart';
import '../utils/app_snack_bar.dart';
import 'sync_status_banner.dart';

/// Shell con BottomNavigationBar compartido entre Notas y Destinatarios.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  @override
  void initState() {
    super.initState();
    // Intentar sincronizar pendientes al abrir la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncQueueControllerProvider.notifier).processQueue();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Snackbar cuando la cola se vacía tras una sync
    ref.listen(syncQueueControllerProvider, (prev, next) {
      final prevCount = prev?.asData?.value.length ?? 0;
      final nextCount = next.asData?.value.length ?? 0;
      if (prevCount > 0 && nextCount == 0) {
        AppSnackBar.success(context, 'Entregas sincronizadas');
      }
    });

    return Scaffold(
      body: Column(
        children: [
          const SyncStatusBanner(),
          Expanded(child: widget.navigationShell),
        ],
      ),
    );
  }
}
