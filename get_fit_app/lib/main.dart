import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// This is for branch showcase purposes
import '../view/workout_history_view.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MVP Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WorkoutHistoryScreen(),
    );
  }
}