import 'package:permission_handler/permission_handler.dart';

class PermissionFun {
  static Future<bool> hasPermission(Permission value) async {
    final PermissionStatus current = await value.status;
    if (current.isGranted || current.isLimited) return true;

    final PermissionStatus requested = await value.request();
    return requested.isGranted || requested.isLimited;
  }

  static Future<bool> hasPermissions(List<Permission> values) async {
    final Map<Permission, PermissionStatus> current = await <Permission>[
      ...values,
    ].request();

    return current.values.every(
      (PermissionStatus s) => s.isGranted || s.isLimited,
    );
  }
}
