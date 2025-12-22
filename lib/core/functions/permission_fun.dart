import 'package:permission_handler/permission_handler.dart';

class PermissionFun {
  static Future<bool> hasPermission(Permission value) async {
    final PermissionStatus current = await value.status;
    if (current.isGranted || current.isLimited) return true;
    if (current.isPermanentlyDenied || current.isRestricted) return false;

    final PermissionStatus requested = await value.request();
    return requested.isGranted || requested.isLimited;
  }

  static Future<bool> hasPermissions(List<Permission> values) async {
    final Map<Permission, PermissionStatus> current = await <Permission>[
      ...values,
    ].request();

    if (current.values.every((PermissionStatus s) => s.isGranted)) return true;
    if (current.values.any(
      (PermissionStatus s) => s.isPermanentlyDenied || s.isRestricted,
    )) {
      return false;
    }

    // If some are denied (but requestable), try once more to ensure the system
    // prompt is shown where applicable.
    final Map<Permission, PermissionStatus> requested = await <Permission>[
      ...values,
    ].request();
    return requested.values.every((PermissionStatus s) => s.isGranted);
  }
}
