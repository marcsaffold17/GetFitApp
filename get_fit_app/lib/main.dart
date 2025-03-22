import 'package:flutter/material.dart';
import 'view/view.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key : key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context,snapshot)
      {
        if(snapshot.hasError)
        {
          print("Couldn't Connect");
        }
        if(snapshot.connectionState == ConnectionState.done)
        {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }
        Widget loading = MaterialApp();
        return loading;
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /*Access Firestrore collecion of Login-Info and then made a createAccount Function to set the document name to the username
    and then save the password in that document for that username*/
  final databaseReference = FirebaseFirestore.instance.collection("Login-Info");

  void createAccount(String username, String password)
  {
    databaseReference.doc(username).set({"Password": password});
  }
  final textController = TextEditingController();
  int _counter = 0;
  

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Title',
                  ),
                ),
              ],
          // children: <Widget>[
          //   const Text('You have pushed the button this many times:'),
          //   Text(
          //     '$_counter',
          //     style: Theme.of(context).textTheme.headlineMedium,
          //   ),
          // ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Entered text: ${textController.text}"); // Print the text from the TextField
          //Sets the Username and Password to the text entered in the textbox for testing
          createAccount(textController.text,textController.text);
          _incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
