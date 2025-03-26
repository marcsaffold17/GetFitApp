import 'package:flutter/material.dart';
import '../presenter/auth_presenter.dart';
import 'signup_view.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthPresenter presenter = AuthPresenter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                presenter.signIn(
                  context,
                  emailController.text,
                  passwordController.text,
                );
              },
              child: Text('Log In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupView()),
                );
              },
              child: Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}
