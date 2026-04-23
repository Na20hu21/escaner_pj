import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/sync/providers/sync_queue_controller.dart';
import '../theme/app_colors.dart';

class SyncStatusBanner extends ConsumerWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(syncQueueControllerProvider);
    final count = state.asData?.value.length ?? 0;
    if (count == 0) return const SizedBox.shrink();

    return Material(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                count == 1
                    ? '1 entrega pendiente de sincronizar'
                    : '$count entregas pendientes de sincronizar',
                style: const TextStyle(fontSize: 13, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
