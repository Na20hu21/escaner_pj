import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum NoteEvent {
  @JsonValue('creada')
  creada,
  @JsonValue('editada')
  editada,
  @JsonValue('estadoCambiado')
  estadoCambiado,
  @JsonValue('entregada')
  entregada,
  @JsonValue('rechazada')
  rechazada,
  @JsonValue('noEntregada')
  noEntregada,
  @JsonValue('reclamada')
  reclamada;

  String get label => switch (this) {
        NoteEvent.creada => 'Creada',
        NoteEvent.editada => 'Editada',
        NoteEvent.estadoCambiado => 'Estado cambiado',
        NoteEvent.entregada => 'Entregada',
        NoteEvent.rechazada => 'Rechazada',
        NoteEvent.noEntregada => 'No entregada',
        NoteEvent.reclamada => 'Reclamada al iniciar sesión',
      };
}
