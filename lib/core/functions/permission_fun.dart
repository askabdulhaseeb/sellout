import 'package:permission_handler/permission_handler.dart';

class PermissionFun {
  static Future<bool> hasPermission(Permission value) async {
    final PermissionStatus status = await value.request();
    if (status.isGranted || status.isLimited) {
      return true;
    } else if (status.isPermanentlyDenied || status.isDenied) {
      await openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  static Future<bool> hasPermissions(List<Permission> values) async {
    final Map<Permission, PermissionStatus> statuses = await values.request();
    if (statuses.values.every((PermissionStatus status) => status.isGranted)) {
      return true;
    } else if (statuses.values.any((PermissionStatus status) =>
        status.isPermanentlyDenied || status.isDenied)) {
      await openAppSettings();
      return false;
    } else {
      return false;
    }
  }
}
