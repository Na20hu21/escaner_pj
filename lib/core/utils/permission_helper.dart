import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  PermissionHelper._();

  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> isCameraGranted() async {
    return Permission.camera.isGranted;
  }

  /// Abre la configuración del sistema si el permiso fue denegado
  /// permanentemente.
  static Future<void> openSettings() => openAppSettings();
}
