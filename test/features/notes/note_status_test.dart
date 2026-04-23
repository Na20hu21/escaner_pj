import 'package:flutter_test/flutter_test.dart';

import 'package:app_poder_judicial/features/notes/data/note_status.dart';

void main() {
  group('NoteStatus', () {
    test('todos los estados tienen label no vacío', () {
      for (final s in NoteStatus.values) {
        expect(s.label, isNotEmpty, reason: 'Estado $s sin label');
      }
    });

    test('todos los estados tienen icono', () {
      for (final s in NoteStatus.values) {
        expect(s.icon, isNotNull, reason: 'Estado $s sin icono');
      }
    });

    test('todos los estados tienen color', () {
      for (final s in NoteStatus.values) {
        expect(s.color, isNotNull, reason: 'Estado $s sin color');
      }
    });

    test('labels son los esperados', () {
      expect(NoteStatus.pendiente.label, 'Pendiente');
      expect(NoteStatus.entregado.label, 'Entregado');
      expect(NoteStatus.fijado.label, 'Fijado');
      expect(NoteStatus.informado.label, 'Informado');
    });
  });
}
