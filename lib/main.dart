import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'features/sync/data/sync_queue_repository.dart';

const _syncTaskName = 'sync_queue';

/// Callback que corre en un isolate separado (background).
/// No puede usar Riverpod; accede directamente al repositorio.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, _) async {
    if (task != _syncTaskName) return true;
    await Hive.initFlutter();
    final repo = SyncQueueRepository();
    final pending = await repo.getPending();
    for (final entry in pending) {
      try {
        // TODO: reemplazar con llamada al backend real
        await Future.delayed(const Duration(milliseconds: 200));
        await repo.markSynced(entry.id);
      } catch (_) {
        await repo.incrementRetry(entry.id);
      }
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    _syncTaskName,
    _syncTaskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );

  runApp(const ProviderScope(child: App()));
}
