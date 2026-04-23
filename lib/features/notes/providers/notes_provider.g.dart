// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(noteRepository)
final noteRepositoryProvider = NoteRepositoryProvider._();

final class NoteRepositoryProvider
    extends $FunctionalProvider<NoteRepository, NoteRepository, NoteRepository>
    with $Provider<NoteRepository> {
  NoteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noteRepositoryHash();

  @$internal
  @override
  $ProviderElement<NoteRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NoteRepository create(Ref ref) {
    return noteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoteRepository>(value),
    );
  }
}

String _$noteRepositoryHash() => r'00e77446f803625187c97bc87b0c0449a236839e';

@ProviderFor(notes)
final notesProvider = NotesProvider._();

final class NotesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Note>>,
          List<Note>,
          FutureOr<List<Note>>
        >
    with $FutureModifier<List<Note>>, $FutureProvider<List<Note>> {
  NotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesHash();

  @$internal
  @override
  $FutureProviderElement<List<Note>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Note>> create(Ref ref) {
    return notes(ref);
  }
}

String _$notesHash() => r'34531b4c0dcc3cc99e0cb04c65d4e1ad1a48e7b6';

@ProviderFor(noteById)
final noteByIdProvider = NoteByIdFamily._();

final class NoteByIdProvider
    extends $FunctionalProvider<AsyncValue<Note?>, Note?, FutureOr<Note?>>
    with $FutureModifier<Note?>, $FutureProvider<Note?> {
  NoteByIdProvider._({
    required NoteByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'noteByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$noteByIdHash();

  @override
  String toString() {
    return r'noteByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Note?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Note?> create(Ref ref) {
    final argument = this.argument as String;
    return noteById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$noteByIdHash() => r'b53e1495d1f386b42ea2a565df5478c6dbb33285';

final class NoteByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Note?>, String> {
  NoteByIdFamily._()
    : super(
        retry: null,
        name: r'noteByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NoteByIdProvider call(String id) =>
      NoteByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'noteByIdProvider';
}

@ProviderFor(notesByRecipient)
final notesByRecipientProvider = NotesByRecipientFamily._();

final class NotesByRecipientProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Note>>,
          List<Note>,
          FutureOr<List<Note>>
        >
    with $FutureModifier<List<Note>>, $FutureProvider<List<Note>> {
  NotesByRecipientProvider._({
    required NotesByRecipientFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'notesByRecipientProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$notesByRecipientHash();

  @override
  String toString() {
    return r'notesByRecipientProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Note>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Note>> create(Ref ref) {
    final argument = this.argument as String;
    return notesByRecipient(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NotesByRecipientProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notesByRecipientHash() => r'97f5c10f5d1e0579c29cd7645e33ebaa2e4992a3';

final class NotesByRecipientFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Note>>, String> {
  NotesByRecipientFamily._()
    : super(
        retry: null,
        name: r'notesByRecipientProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NotesByRecipientProvider call(String recipientId) =>
      NotesByRecipientProvider._(argument: recipientId, from: this);

  @override
  String toString() => r'notesByRecipientProvider';
}

@ProviderFor(NoteController)
final noteControllerProvider = NoteControllerProvider._();

final class NoteControllerProvider
    extends $NotifierProvider<NoteController, void> {
  NoteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noteControllerHash();

  @$internal
  @override
  NoteController create() => NoteController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$noteControllerHash() => r'4501e82de9fa43855a316343ddbcf8a7d0575984';

abstract class _$NoteController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
