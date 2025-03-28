import 'package:flutter/material.dart';
import '../view/login_view.dart';
import 'nav_bar.dart';
import '../model/global_model.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title,required this.username});
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      drawer: const NavBar(),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              "Welcome Back, ${UserName}",
              style: TextStyle(fontSize: 30)
            ) 
            )
        ],
      ),
    );
  }
}