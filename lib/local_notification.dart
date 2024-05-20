import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static late final FlutterLocalNotificationsPlugin _notificationsPlugin;

  static Future<void> initialize() async {
    // Initialize notifications plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    await _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {},
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@mipmap/ic_launcher", //<-- Add this parameter
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
