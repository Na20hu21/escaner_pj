import 'package:flutter/material.dart';

/// Paleta central de la app. R5: nada de colores hardcodeados fuera de aquí.
class AppColors {
  AppColors._();

  // Primarios — azul oscuro + blanco
  static const Color primary = Color(0xFF0D2B57);
  static const Color primaryDark = Color(0xFF071B3A);
  static const Color primaryLight = Color(0xFF1E4A8C);
  static const Color onPrimary = Colors.white;

  // Neutros
  static const Color background = Color(0xFFF5F6F8);
  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color border = Color(0xFFE1E4EA);
  static const Color muted = Color(0xFF6B7280);

  // Semánticos por estado de nota
  static const Color statusPending = Color(0xFFB48A00);   // ámbar oscuro
  static const Color statusDelivered = Color(0xFF1B7F3A); // verde
  static const Color statusNotDelivered = Color(0xFFB45309); // naranja oscuro
  static const Color statusRejected = Color(0xFFB3261E);  // rojo
  static const Color error = Color(0xFFB3261E);
}
