import 'package:flutter_test/flutter_test.dart';

import 'package:app_poder_judicial/features/auth/data/user.dart';
import 'package:app_poder_judicial/features/auth/data/user_role.dart';
import 'package:app_poder_judicial/features/notes/data/note_status.dart';
import 'package:app_poder_judicial/features/notes/data/permission_guard.dart';

User _user(UserRole role) => User(
      id: 'u1',
      name: 'Test',
      email: 'test@test.com',
      role: role,
    );

void main() {
  group('PermissionGuard.canChangeNoteStatus', () {
    group('notificador', () {
      final user = _user(UserRole.notificador);

      test('puede cambiar de pendiente a entregado', () {
        expect(
          PermissionGuard.canChangeNoteStatus(
              user, NoteStatus.pendiente, NoteStatus.entregado),
          isTrue,
        );
      });

      test('puede cambiar de pendiente a fijado', () {
        expect(
          PermissionGuard.canChangeNoteStatus(
              user, NoteStatus.pendiente, NoteStatus.fijado),
          isTrue,
        );
      });

      test('puede cambiar de pendiente a informado', () {
        expect(
          PermissionGuard.canChangeNoteStatus(
              user, NoteStatus.pendiente, NoteStatus.informado),
          isTrue,
        );
      });

      test('NO puede cambiar de entregado a pendiente', () {
        expect(
          PermissionGuard.canChangeNoteStatus(
              user, NoteStatus.entregado, NoteStatus.pendiente),
          isFalse,
        );
      });

      test('NO puede cambiar de fijado a pendiente', () {
        expect(
          PermissionGuard.canChangeNoteStatus(
              user, NoteStatus.fijado, NoteStatus.pendiente),
          isFalse,
        );
      });

      test('NO puede cambiar de informado a pendiente', () {
        expect(
          PermissionGuard.canChangeNoteStatus(
              user, NoteStatus.informado, NoteStatus.pendiente),
          isFalse,
        );
      });

      test('NO puede cambiar al mismo estado', () {
        expect(
          PermissionGuard.canChangeNoteStatus(
              user, NoteStatus.pendiente, NoteStatus.pendiente),
          isFalse,
        );
      });
    });

    group('supervisor', () {
      final user = _user(UserRole.supervisor);

      test('puede hacer cualquier transición de estado', () {
        final statuses = NoteStatus.values;
        for (final from in statuses) {
          for (final to in statuses) {
            if (from == to) continue;
            expect(
              PermissionGuard.canChangeNoteStatus(user, from, to),
              isTrue,
              reason: 'Supervisor debe poder cambiar de $from a $to',
            );
          }
        }
      });

      test('NO puede cambiar al mismo estado', () {
        for (final status in NoteStatus.values) {
          expect(
            PermissionGuard.canChangeNoteStatus(user, status, status),
            isFalse,
            reason: 'Mismo estado debe retornar false para $status',
          );
        }
      });
    });
  });

  group('PermissionGuard.canEditHistory', () {
    test('supervisor puede editar historial', () {
      expect(
        PermissionGuard.canEditHistory(_user(UserRole.supervisor)),
        isTrue,
      );
    });

    test('notificador NO puede editar historial', () {
      expect(
        PermissionGuard.canEditHistory(_user(UserRole.notificador)),
        isFalse,
      );
    });
  });
}
