import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/utils/validate.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(Function(String? payload) onTap) async {
    const android = AndroidInitializationSettings('@drawable/launcher_icon');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onTap(response.payload);
      },
    );

    // (Optional) Manually request iOS permissions – safe to call here again
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
     String? payload,
  })
  async {
    final bigTextStyle = BigTextStyleInformation(
      body,
      contentTitle: title,
      summaryText: null,
    );
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'com_shishughar_creche',
        CustomText.ShishuGhar,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/launcher_icon',
        enableVibration: true,
        styleInformation: bigTextStyle,
      ),
    );

    await _notificationsPlugin.show(
       Validate().currentDateTimeMillisecoud()%1000000,
      title,
      body,
      details,payload: payload
    );
  }

  static Future<bool> checkAndroidNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) { // Android 13+
      final result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      return result ?? false;
    }
    return true;
  }

  static Future requestPermission() async {
    if (!Platform.isAndroid) return true;

    if (await Permission.notification.isGranted) {
      return true;
    }

    final status = await Permission.notification.request();
    return status.isGranted;
  }

}
