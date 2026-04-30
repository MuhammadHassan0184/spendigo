import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:spendigo/controller/notification_controller.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings);

    // Android 13+ permission handling
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  static Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'wallet_alert_channel',
      'Wallet Alerts',
      channelDescription: 'Notifications for wallet alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      title,
      body,
      details,
    );

    // Persist to in-app notification history
    if (Get.isRegistered<NotificationController>()) {
      await Get.find<NotificationController>().addNotification(title, body);
    }
  }
}