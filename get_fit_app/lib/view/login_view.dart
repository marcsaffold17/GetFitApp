import 'package:flutter/material.dart';
import '../presenter/login_presenter.dart';
import '../presenter/global_presenter.dart';
import 'HomePage.dart';

class LoginButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              child: const Text('Create Account'),
            ),
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
              child: const Text('Login'),
            ),
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: handleCreateAccount,
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
