import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/notification_service.dart'; // Import your notification service
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _firebaseToken;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  Future<void> _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get Firebase Token
    String? token = await messaging.getToken();
    setState(() {
      _firebaseToken = token;
    });

    print("Firebase Messaging Token: $_firebaseToken");

    // Listen for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        NotificationService.showInstantNotification(
          title: message.notification!.title ?? 'No Title',
          body: message.notification!.body ?? 'No Body',
        );

        // Save notification to Firestore
        saveNotificationToFirestore(
          message.notification!.title ?? 'No Title',
          message.notification!.body ?? 'No Body',
        );
      }
    });
  }

  // Save notification to Firestore
  Future<void> saveNotificationToFirestore(String title, String body) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Get notifications from Firestore
  Stream<QuerySnapshot> getNotifications() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await NotificationService.showInstantNotification(
                  title: "Test Notification",
                  body: "This is an instant notification",
                );
              },
              child: const Text('Show Instant Notification'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await NotificationService.scheduleNotification(
                  title: "Scheduled Notification",
                  body: "This will show after 5 seconds",
                  seconds: 5,
                );
              },
              child: const Text('Schedule Notification (5 sec)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await NotificationService.cancelAllNotifications();
              },
              child: const Text('Cancel All Notifications'),
            ),
            const SizedBox(height: 16),
            if (_firebaseToken != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SelectableText(
                  "Firebase Token:\n$_firebaseToken",
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
