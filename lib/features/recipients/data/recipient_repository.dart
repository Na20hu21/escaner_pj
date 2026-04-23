import 'recipient.dart';

abstract class RecipientRepository {
  Future<List<Recipient>> getAll();
  Future<Recipient?> getById(String id);
  Future<void> save(Recipient recipient);
  Future<void> delete(String id);
}
