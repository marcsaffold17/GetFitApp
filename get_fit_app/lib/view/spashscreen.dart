import "package:flutter/material.dart";
import 'package:get_fit_app/view/login_view.dart'; // Ensure this path is correct

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  void _navigateToHomePage() async {
    await Future.delayed(
      const Duration(seconds: 3),
    ); // Add a delay for the splash screen
    if (!mounted) return; // Ensure the widget is still in the widget tree
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginButtonPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 50, 31),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/BeastMode.png', width: 300),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 229, 221, 212),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
