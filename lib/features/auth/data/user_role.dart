enum UserRole {
  notificador,
  supervisor;

  String get displayName {
    return switch (this) {
      UserRole.notificador => 'Notificador',
      UserRole.supervisor => 'Supervisor',
    };
  }
}
