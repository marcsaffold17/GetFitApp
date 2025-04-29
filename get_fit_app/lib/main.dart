import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/login_view.dart';
import '../view/spashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Program',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 46, 105, 70),
          selectionColor: Color.fromARGB(100, 81, 163, 108),
          selectionHandleColor: Color.fromARGB(255, 46, 105, 70),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: const Color.fromARGB(255, 46, 105, 70),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
