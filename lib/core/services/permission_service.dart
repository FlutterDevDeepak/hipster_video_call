import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<Map<Permission, PermissionStatus>> checkCore() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.notification,
    ].request();
    return statuses;
  }

  static Future<bool> requestRequired() async {
    final current = await Future.wait([
      Permission.camera.status,
      Permission.microphone.status,
      Permission.notification.status,
    ]);

    final needsRequest = current.any((s) => !s.isGranted);
    if (!needsRequest) return true;

    final results = await [
      Permission.camera,
      Permission.microphone,
      Permission.notification,
    ].request();

    final cam = results[Permission.camera] ?? PermissionStatus.denied;
    final mic = results[Permission.microphone] ?? PermissionStatus.denied;
    final noti = results[Permission.notification] ?? PermissionStatus.denied;

    final allGranted = cam.isGranted && mic.isGranted && noti.isGranted;
    return allGranted;
  }

  static Future<bool> ensureCameraAndMic() async {
    final res = await [Permission.camera, Permission.microphone].request();
    final cam = res[Permission.camera]?.isGranted == true;
    final mic = res[Permission.microphone]?.isGranted == true;
    return cam && mic;
  }

  static Future<bool> ensureNotifications() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    final res = await Permission.notification.request();
    return res.isGranted;
  }

  static Future<bool> openAppSettingsIfPermanentlyDenied() async {
    final cam = await Permission.camera.status;
    final mic = await Permission.microphone.status;
    final noti = await Permission.notification.status;

    if (cam.isPermanentlyDenied ||
        mic.isPermanentlyDenied ||
        noti.isPermanentlyDenied) {
      return openAppSettings();
    }
    return false;
  }
}
