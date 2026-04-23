import '../../auth/data/user.dart';
import '../../auth/data/user_role.dart';
import 'note_status.dart';

class PermissionGuard {
  const PermissionGuard._();

  /// Devuelve true si [user] puede cambiar el estado de una nota de [from] a [to].
  ///
  /// Reglas:
  /// - Supervisor: puede hacer cualquier transición.
  /// - Notificador: solo puede cambiar desde [NoteStatus.pendiente].
  static bool canChangeNoteStatus(User user, NoteStatus from, NoteStatus to) {
    if (from == to) return false;
    return switch (user.role) {
      UserRole.supervisor => true,
      UserRole.notificador => from == NoteStatus.pendiente,
    };
  }

  /// Solo supervisores pueden editar entradas del historial.
  static bool canEditHistory(User user) =>
      user.role == UserRole.supervisor;

  /// Puede editar datos de una nota (código, observaciones, imágenes).
  /// - Notificador: solo notas en estado pendiente.
  /// - Supervisor: siempre.
  static bool canEditNote(User user, NoteStatus status) {
    return switch (user.role) {
      UserRole.supervisor => true,
      UserRole.notificador => status == NoteStatus.pendiente,
    };
  }
}
