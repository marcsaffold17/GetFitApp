import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/login_view.dart';
import 'view/exercise_view.dart';

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
      title: 'Flutter Program',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginButtonPage(),
    );
  }
}
