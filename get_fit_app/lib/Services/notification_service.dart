import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize notifications (Local + Firebase)
  static Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await _localNotificationsPlugin.initialize(initializationSettings);

    // Request permission for Firebase notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Firebase push notifications listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showInstantNotification(
          title: message.notification!.title ?? 'No Title',
          body: message.notification!.body ?? 'No Body',
        );
      }
    });

    // Initialize timezone data
    tz.initializeTimeZones();
  }

  /// Show an instant notification
  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_notification_channel', // Channel ID
        'Instant Notifications', // Channel Name
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
    // Ensure time zones are initialized
    final String timeZone = await FlutterTimezone.getLocalTimezone();
    final tz.Location location = tz.getLocation(timeZone);
    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(location).add(Duration(seconds: seconds));

    await _localNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_reminder_channel', // Channel ID
          'Workout Reminders', // Channel Name
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }
}
