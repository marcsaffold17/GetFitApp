import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/login_view.dart';

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
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 111, 138, 183),
          selectionColor: Color.fromARGB(100, 46, 105, 70),
          selectionHandleColor: Color.fromARGB(255, 46, 105, 70),
        ),
      ),
      home: LoginButtonPage(),
    );
  }
}
