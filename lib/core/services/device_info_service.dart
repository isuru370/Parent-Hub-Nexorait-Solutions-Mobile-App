import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoService {
  DeviceInfoService._();

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Device Name
  static Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;

      return '${info.manufacturer} ${info.model}';
    }

    if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;

      return info.name;
    }

    return 'Unknown Device';
  }

  /// Device Type
  static String getDeviceType() {
    if (Platform.isAndroid) {
      return 'android';
    }

    if (Platform.isIOS) {
      return 'ios';
    }

    return 'unknown';
  }

  /// App Version
  static Future<String> getAppVersion() async {
    final package = await PackageInfo.fromPlatform();

    return package.version;
  }

  /// Build Number
  static Future<String> getBuildNumber() async {
    final package = await PackageInfo.fromPlatform();

    return package.buildNumber;
  }
}
