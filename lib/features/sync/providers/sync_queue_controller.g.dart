// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncQueueController)
final syncQueueControllerProvider = SyncQueueControllerProvider._();

final class SyncQueueControllerProvider
    extends
        $AsyncNotifierProvider<SyncQueueController, List<PendingSyncEntry>> {
  SyncQueueControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncQueueControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncQueueControllerHash();

  @$internal
  @override
  SyncQueueController create() => SyncQueueController();
}

String _$syncQueueControllerHash() =>
    r'003b5098b8c38bc2f1cfdbaaf837af0efd402aeb';

abstract class _$SyncQueueController
    extends $AsyncNotifier<List<PendingSyncEntry>> {
  FutureOr<List<PendingSyncEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<PendingSyncEntry>>, List<PendingSyncEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PendingSyncEntry>>,
                List<PendingSyncEntry>
              >,
              AsyncValue<List<PendingSyncEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
