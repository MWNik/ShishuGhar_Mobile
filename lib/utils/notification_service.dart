import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shishughar/custom_widget/custom_text.dart';
import 'package:shishughar/utils/constants.dart';
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



}
