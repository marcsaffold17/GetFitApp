import 'package:flutter/material.dart';
import '../view/login_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title,required this.username});
  final String title;
  final String username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              "Welcome Back, ${widget.username}",
              style: TextStyle(fontSize: 30)
            ) 
            )
        ],
      ),
    );
  }
}