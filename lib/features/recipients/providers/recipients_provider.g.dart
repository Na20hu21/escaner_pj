// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipients_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recipientRepository)
final recipientRepositoryProvider = RecipientRepositoryProvider._();

final class RecipientRepositoryProvider
    extends
        $FunctionalProvider<
          RecipientRepository,
          RecipientRepository,
          RecipientRepository
        >
    with $Provider<RecipientRepository> {
  RecipientRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipientRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipientRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecipientRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecipientRepository create(Ref ref) {
    return recipientRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipientRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipientRepository>(value),
    );
  }
}

String _$recipientRepositoryHash() =>
    r'ae45fabe0651321cb7dbc844a1196aae3c6dbb0d';

/// Lista completa de destinatarios ordenada por nombre.

@ProviderFor(recipients)
final recipientsProvider = RecipientsProvider._();

/// Lista completa de destinatarios ordenada por nombre.

final class RecipientsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipient>>,
          List<Recipient>,
          FutureOr<List<Recipient>>
        >
    with $FutureModifier<List<Recipient>>, $FutureProvider<List<Recipient>> {
  /// Lista completa de destinatarios ordenada por nombre.
  RecipientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipientsHash();

  @$internal
  @override
  $FutureProviderElement<List<Recipient>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Recipient>> create(Ref ref) {
    return recipients(ref);
  }
}

String _$recipientsHash() => r'9e8d1d883285d97e080be0121a56412b58fe69fc';

/// Un destinatario por ID.

@ProviderFor(recipientById)
final recipientByIdProvider = RecipientByIdFamily._();

/// Un destinatario por ID.

final class RecipientByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Recipient?>,
          Recipient?,
          FutureOr<Recipient?>
        >
    with $FutureModifier<Recipient?>, $FutureProvider<Recipient?> {
  /// Un destinatario por ID.
  RecipientByIdProvider._({
    required RecipientByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recipientByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipientByIdHash();

  @override
  String toString() {
    return r'recipientByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Recipient?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Recipient?> create(Ref ref) {
    final argument = this.argument as String;
    return recipientById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipientByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipientByIdHash() => r'00f322ba57651f6ce584bd131f55cfb15d41d901';

/// Un destinatario por ID.

final class RecipientByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Recipient?>, String> {
  RecipientByIdFamily._()
    : super(
        retry: null,
        name: r'recipientByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Un destinatario por ID.

  RecipientByIdProvider call(String id) =>
      RecipientByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'recipientByIdProvider';
}

/// Lista filtrada por query (nombre o DNI). Se aplica en memoria.

@ProviderFor(recipientsSearch)
final recipientsSearchProvider = RecipientsSearchFamily._();

/// Lista filtrada por query (nombre o DNI). Se aplica en memoria.

final class RecipientsSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipient>>,
          List<Recipient>,
          FutureOr<List<Recipient>>
        >
    with $FutureModifier<List<Recipient>>, $FutureProvider<List<Recipient>> {
  /// Lista filtrada por query (nombre o DNI). Se aplica en memoria.
  RecipientsSearchProvider._({
    required RecipientsSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recipientsSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipientsSearchHash();

  @override
  String toString() {
    return r'recipientsSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Recipient>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Recipient>> create(Ref ref) {
    final argument = this.argument as String;
    return recipientsSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipientsSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipientsSearchHash() => r'0af63987412887d0c9f0712c43a75fcd2e3a6f9e';

/// Lista filtrada por query (nombre o DNI). Se aplica en memoria.

final class RecipientsSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Recipient>>, String> {
  RecipientsSearchFamily._()
    : super(
        retry: null,
        name: r'recipientsSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lista filtrada por query (nombre o DNI). Se aplica en memoria.

  RecipientsSearchProvider call(String query) =>
      RecipientsSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'recipientsSearchProvider';
}

/// Controller para mutaciones: crear, editar, eliminar.

@ProviderFor(RecipientController)
final recipientControllerProvider = RecipientControllerProvider._();

/// Controller para mutaciones: crear, editar, eliminar.
final class RecipientControllerProvider
    extends $NotifierProvider<RecipientController, void> {
  /// Controller para mutaciones: crear, editar, eliminar.
  RecipientControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipientControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipientControllerHash();

  @$internal
  @override
  RecipientController create() => RecipientController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$recipientControllerHash() =>
    r'8439987f2888fc7043353185d1a25df62ef9e52c';

/// Controller para mutaciones: crear, editar, eliminar.

abstract class _$RecipientController extends $Notifier<void> {
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
