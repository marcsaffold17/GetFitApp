import 'package:flutter/material.dart';
import '../presenter/login_presenter.dart';
import '../presenter/global_presenter.dart';
import 'HomePage.dart';

class LoginButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('')),
      body: Container(
        decoration: const BoxDecoration(
          // color: Color.fromARGB(255, 29, 28, 28)
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 4, 222, 138), Color.fromARGB(255, 2, 154, 80), Color.fromARGB(255, 1, 50, 34)],
            // colors: [Color.fromARGB(255, 67, 66, 66), Color.fromARGB(255, 189, 172, 172), Color.fromARGB(255, 60, 60, 61)], 
            begin: Alignment.centerLeft,
            end: Alignment.centerRight, 
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 230),
            RichText(
              text: TextSpan(
                style: TextStyle(fontFamily: 'Voguella', fontSize: 80, color: const Color.fromARGB(255, 255, 255, 255)),
                children: const <TextSpan>[
                  TextSpan(text: 'Get FIT'),
                ],
              ),
            ),
            const Divider(height: 20, thickness: 7, indent: 30, endIndent: 30, color: Color.fromARGB(255, 255, 255, 255)),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const MyCreateAccountPage(
                          title: 'Create Account Page',
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50), 
                // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              ),
              child: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Mirage', fontSize: 25),),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const MyLoginPage(title: 'Login Page'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50),
                // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              ),
              child: const Text('Login',style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Mirage', fontSize: 25) ),
            ),
            SizedBox(height: 100),
            // Image.asset(
            //   'assets/images/Dumbell.png',
            //   height: 300,
            //   width: 300,
            //   ),
          ],
        ),
      ),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});
  final String title;

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<MyLoginPage> implements LoginView {
  late LoginPresenter presenter;
  final userNameText = TextEditingController();
  final passWordText = TextEditingController();

  @override
  void initState() {
    super.initState();
    presenter = LoginPresenter(this);
  }

  @override
  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.green)),
      ),
    );
  }

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 4, 222, 138),
              Color.fromARGB(255, 2, 154, 80),
              Color.fromARGB(255, 1, 50, 34),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    ),
      body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 4, 222, 138),
                Color.fromARGB(255, 2, 154, 80),
                Color.fromARGB(255, 1, 50, 34),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Voguella',
                fontSize: 40,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              children: const <TextSpan>[
                TextSpan(text: '   Login\n'),
              ],
            ),
          ),
        ),
        Positioned(
          left: -5,
          right: -5,
          top: 200,
          bottom: -15,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 5.0, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: SingleChildScrollView( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: userNameText,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: passWordText,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: () async {
                bool isValid = await presenter.CheckAccountInfo(
                  userNameText.text,
                  passWordText.text,
                );
                if (isValid) {
                  globalUsername = userNameText.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MyHomePage(
                            title: 'Home Page',
                            username: userNameText.text,
                          ),
                    ),
                  );
                }
              },
              child: const Text('Check Login Info'),
            ),
          ],
        ),
      ),
          )
        )
      ]
      )
    );
  }
}

class MyCreateAccountPage extends StatefulWidget {
  const MyCreateAccountPage({super.key, required this.title});
  final String title;

  @override
  CreateAccountPage createState() => CreateAccountPage();
}

class CreateAccountPage extends State<MyCreateAccountPage>
    implements LoginView {
  late LoginPresenter presenter;
  final userNameText = TextEditingController();
  final passWordText = TextEditingController();
  final confirmPassWordText = TextEditingController();
  final emailText = TextEditingController();


  @override
  void initState() {
    super.initState();
    presenter = LoginPresenter(this);
  }

  @override
  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.green)),
      ),
    );
  }

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  void handleCreateAccount() {
    if (passWordText.text != confirmPassWordText.text) {
      showError("Passwords do not match");
      return;
    }
    presenter.createAccount(userNameText.text, passWordText.text);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 4, 222, 138),
              Color.fromARGB(255, 2, 154, 80),
              Color.fromARGB(255, 1, 50, 34),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    ),
    body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 4, 222, 138),
                Color.fromARGB(255, 2, 154, 80),
                Color.fromARGB(255, 1, 50, 34),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Voguella',
                fontSize: 40,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              children: const <TextSpan>[
                TextSpan(text: '   Create\n   Account'),
              ],
            ),
          ),
        ),
        Positioned(
          left: -5,
          right: -5,
          top: 200,
          bottom: -15,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 5.0, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: SingleChildScrollView( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 20),
                  TextField(
                    controller: userNameText,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: emailText,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: passWordText,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: confirmPassWordText,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 400, 
                    height: 60, 
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromARGB(255, 4, 222, 138), Color.fromARGB(255, 2, 154, 80), Color.fromARGB(255, 1, 50, 34)],
                        //colors: [Color.fromARGB(255, 67, 66, 66), Color.fromARGB(255, 189, 172, 172), Color.fromARGB(255, 60, 60, 61)], 
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight, 
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: handleCreateAccount,
                      child: const Text(
                        'Create Account',
                        style: TextStyle(fontFamily: 'Mirage', fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
    }