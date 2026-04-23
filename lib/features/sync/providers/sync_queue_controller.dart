import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/pending_sync_entry.dart';
import '../data/sync_queue_repository.dart';
import 'connectivity_service.dart';

part 'sync_queue_controller.g.dart';

@riverpod
class SyncQueueController extends _$SyncQueueController {
  bool _processing = false;

  @override
  Future<List<PendingSyncEntry>> build() async {
    // Cuando vuelve internet, procesar automáticamente
    ref.listen(connectivityStreamProvider, (_, next) {
      next.whenData((online) {
        if (online) processQueue();
      });
    });
    return SyncQueueRepository().getPending();
  }

  Future<void> enqueue(PendingSyncEntry entry) async {
    await SyncQueueRepository().enqueue(entry);
    ref.invalidateSelf();
  }

  /// Procesa todos los pendientes. Devuelve cuántos se sincronizaron.
  Future<int> processQueue() async {
    if (_processing) return 0;
    _processing = true;
    var synced = 0;
    try {
      final repo = SyncQueueRepository();
      final pending = await repo.getPending();
      for (final entry in pending) {
        try {
          // TODO: reemplazar con llamada al backend real
          await Future.delayed(const Duration(milliseconds: 200));
          await repo.markSynced(entry.id);
          synced++;
        } catch (_) {
          await repo.incrementRetry(entry.id);
        }
      }
    } finally {
      _processing = false;
      ref.invalidateSelf();
    }
    return synced;
  }
}
