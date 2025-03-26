import 'package:flutter/material.dart';
import 'Services/notification_service.dart';
import 'view/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Get Fit App',
        theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Fit App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NotificationService.showInstantNotification(
                  title: 'Workout Reminder',
                  body: 'Time to do your workout!',
                );
              },
              child: const Text('Show Instant Notification'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                NotificationService.scheduleNotification(
                  title: 'Scheduled Workout',
                  body: 'Don’t forget to work out!',
                  seconds: 10, // Notification will appear in 10 seconds
                );
              },
              child: const Text('Schedule Notification in 10 sec'),
            ),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                var workouts = snapshot.data!.docs;
                return Column(
                  children: workouts.map((doc) {
                    return ListTile(
                      title: Text(doc['name']),
                      subtitle: Text('Duration: ${doc['duration']} min'),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}