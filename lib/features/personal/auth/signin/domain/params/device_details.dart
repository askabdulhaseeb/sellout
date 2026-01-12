import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import '../../../../../../services/firebase_messaging_service.dart';

class DeviceInfoUtil {
  static Future<Map<String, dynamic>> getLoginDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final String? fcmToken = FirebaseMessagingService().fcmToken;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return <String, dynamic>{
        'device_id': androidInfo.id,
        'device_name': androidInfo.model,
        'device_type': 'Mobile',
        'os': 'Android ${androidInfo.version.release}',
        'app_version': 1.0,
        'platform': 'Android',
        'language': Intl.getCurrentLocale(),
        'device_token': fcmToken ?? '',
      };
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return <String, dynamic>{
        'device_id': iosInfo.identifierForVendor,
        'device_name': iosInfo.name,
        'device_type': 'Mobile',
        'os': '${iosInfo.systemName} ${iosInfo.systemVersion}',
        'app_version': 1.0,
        'platform': 'iOS',
        'language': Intl.getCurrentLocale(),
        'device_token': fcmToken ?? '',
      };
    } else {
      return <String, dynamic>{
        'device_id': 'unknown',
        'device_name': 'Unknown',
        'device_type': 'Unknown',
        'os': 'Unknown',
        'app_version': 1.0,
        'platform': 'Unknown',
        'language': Intl.getCurrentLocale(),
        'device_token': fcmToken ?? '',
      };
    }
  }

  static Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown';
    } else {
      return 'unknown';
    }
  }
}
