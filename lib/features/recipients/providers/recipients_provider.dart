import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/recipient.dart';
import '../data/recipient_repository.dart';
import '../data/recipient_repository_impl.dart';

part 'recipients_provider.g.dart';

@riverpod
RecipientRepository recipientRepository(Ref ref) => RecipientRepositoryImpl();

/// Lista completa de destinatarios ordenada por nombre.
@riverpod
Future<List<Recipient>> recipients(Ref ref) =>
    ref.read(recipientRepositoryProvider).getAll();

/// Un destinatario por ID.
@riverpod
Future<Recipient?> recipientById(Ref ref, String id) =>
    ref.read(recipientRepositoryProvider).getById(id);

/// Lista filtrada por query (nombre o DNI). Se aplica en memoria.
@riverpod
Future<List<Recipient>> recipientsSearch(Ref ref, String query) async {
  final all = await ref.watch(recipientsProvider.future);
  if (query.trim().isEmpty) return all;
  final q = query.toLowerCase();
  return all
      .where((r) => r.name.toLowerCase().contains(q) || r.dni.contains(q))
      .toList();
}

/// Controller para mutaciones: crear, editar, eliminar.
@riverpod
class RecipientController extends _$RecipientController {
  @override
  void build() {}

  Future<void> save(Recipient recipient) async {
    await ref.read(recipientRepositoryProvider).save(recipient);
    ref.invalidate(recipientsProvider);
  }

  Future<void> delete(String id) async {
    await ref.read(recipientRepositoryProvider).delete(id);
    ref.invalidate(recipientsProvider);
  }
}
