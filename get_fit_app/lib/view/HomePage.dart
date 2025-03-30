import 'package:flutter/material.dart';
import '../view/login_view.dart';
import 'nav_bar.dart';
import '../presenter/global_presenter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.username});
  final String title;
  final String username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String UserName;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() {
    UserName = globalUsername ?? widget.username;
  }

  void _logout() {
    setState(() {
      globalUsername = null;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MyLoginPage(title: 'Login Page'),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      drawer: const NavBar(),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              "Welcome Back, $UserName",
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }
}
