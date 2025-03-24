import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/insert_workout_model.dart';
import '../view/insert_workout_view.dart';
import '../presenter/insert_workout_presenter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repository = WorkoutRepository();
    final presenter = WorkoutPresenter(repository);

    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(presenter: presenter),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final WorkoutPresenter presenter;

  const HomeScreen({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutEntryScreen(
                    presenter: presenter,
                  )),
            );
          },
          child: Text('Add Workout'),
        ),
      ),
    );
  }
}