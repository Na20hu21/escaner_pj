enum RejectionReason {
  domicilioInexistente,
  personaAusente,
  direccionIncorrecta,
  seNegoARecibir,
  fueraDePlazo,
  otro;

  String get label => switch (this) {
        RejectionReason.domicilioInexistente => 'Domicilio inexistente',
        RejectionReason.personaAusente => 'Persona ausente',
        RejectionReason.direccionIncorrecta => 'Dirección incorrecta',
        RejectionReason.seNegoARecibir => 'Se negó a recibir',
        RejectionReason.fueraDePlazo => 'Fuera de plazo',
        RejectionReason.otro => 'Otro',
      };
}
