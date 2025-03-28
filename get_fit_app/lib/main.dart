import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Don't need in main
import '../view/insert_workout_view.dart';
import '../model/insert_workout_model.dart';
import '../presenter/insert_workout_presenter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Branch exclusive code to showcase screen
    final repository = WorkoutRepository();
    final presenter = WorkoutPresenter(repository);
    //
    return MaterialApp(
      title: 'Flutter MVP Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WorkoutEntryScreen(presenter: presenter),
    );
  }
}