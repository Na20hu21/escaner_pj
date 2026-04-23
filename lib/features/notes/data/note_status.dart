import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/theme/app_colors.dart';

@JsonEnum()
enum NoteStatus {
  @JsonValue('pendiente')
  pendiente,
  @JsonValue('entregado')
  entregado,
  @JsonValue('fijado')
  fijado,
  @JsonValue('informado')
  informado;

  String get label => switch (this) {
        NoteStatus.pendiente => 'Pendiente',
        NoteStatus.entregado => 'Entregado',
        NoteStatus.fijado => 'Fijado',
        NoteStatus.informado => 'Informado',
      };

  Color get color => switch (this) {
        NoteStatus.pendiente => AppColors.statusPending,
        NoteStatus.entregado => AppColors.statusDelivered,
        NoteStatus.fijado => AppColors.statusNotDelivered,
        NoteStatus.informado => AppColors.statusRejected,
      };

  IconData get icon => switch (this) {
        NoteStatus.pendiente => Icons.schedule,
        NoteStatus.entregado => Icons.check_circle_outline,
        NoteStatus.fijado => Icons.push_pin_outlined,
        NoteStatus.informado => Icons.info_outline,
      };
}
