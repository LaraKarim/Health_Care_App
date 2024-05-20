import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    // Initialize timezone data
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Africa/Cairo"));

    // Request permission for receiving notifications (required on iOS)
    // await _firebaseMessaging.requestPermission();

    // Get FCM token
    final FCMToken = await _firebaseMessaging.getToken();
    print("Firebase token $FCMToken");

    // Initialize push notifications
    initPushNotification();

    // Configure the app to handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      _displayNotification(message); // Display local notification
    });

    // Configure the app to handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> scheduleDailyMedicationReminders(
      List<DateTime> medicationTimes) async {
    for (DateTime time in medicationTimes) {
      // Generate a unique notification ID within the valid range
      int notificationId = time.millisecondsSinceEpoch ~/ 1000;

      // Schedule a daily notification for each medication time
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Medication Reminder',
        'Don\'t forget your medication!',
        _nextInstanceOfTime(
            time), // Schedule for the next occurrence of this time
        NotificationDetails(
          android: AndroidNotificationDetails(
            'medication_channel_id',
            'Medication Channel',
            'Channel for daily medication reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void _displayNotification(RemoteMessage message) {
    // Display a local notification with FCM message content
    // You can customize this according to your app's requirements
    // Here's a simple example:
    flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your_other_channel_id',
          'Other Channel Name',
          'Other Channel Description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    String? title = message.notification?.title;
    if (title != null) {
      switch (title) {
        case 'Medication Reminder':
          Navigator.of(navigatorKey.currentContext!).pushNamed("/medication");
          break;
        case 'Water Reminder':
          Navigator.of(navigatorKey.currentContext!).pushNamed("/water");
          break;
        case 'Doctor Reminder':
          Navigator.of(navigatorKey.currentContext!).pushNamed("/appointment");
          break;
        // Add cases for other types of reminders if needed
        default:
          // Handle default case or unknown titles
          break;
      }
    }
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  // Function to handle background message
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Background message received: ${message.notification?.title}");
    handleMessage(message);

    // Handle background message
  }
}
