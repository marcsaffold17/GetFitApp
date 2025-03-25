import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initialize notifications
  static Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _localNotificationsPlugin.initialize(initializationSettings);

    // Initialize Firebase Messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showInstantNotification(
          title: message.notification!.title ?? 'No Title',
          body: message.notification!.body ?? 'No Body',
        );
      }
    });
  }

  /// Show an instant notification
  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_notification_channel',
        'Instant Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _localNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
    );
  }

  /// Schedule a notification
  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required int seconds,
  }) async {
    // Initialize time zones
    tz.initializeTimeZones();
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    final tz.TZDateTime scheduledDate =
    tz.TZDateTime.now(tz.getLocation(timeZone)).add(Duration(seconds: seconds));

    // Schedule the notification
    await _localNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      title, // Title
      body, // Body
      scheduledDate, // Scheduled time
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_reminder_channel', // Channel ID
          'Workout Reminders', // Channel Name
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
