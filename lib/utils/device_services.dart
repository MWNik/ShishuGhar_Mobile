import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  static Future<String?> gteDeviceInfo() async {
    // return 'UP1A.231005.007-23124RN87I-mt6835';
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      String rawId = '${androidInfo.id}-${androidInfo.model}-${androidInfo.hardware}';
      print("rawId $rawId");
      return rawId;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return '${iosInfo.identifierForVendor}-${iosInfo.model}-${iosInfo.systemName}-${iosInfo.systemVersion}';
    } else {
      return null;
    }
  } 
}
