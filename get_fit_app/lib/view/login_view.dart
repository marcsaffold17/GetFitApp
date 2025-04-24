import 'package:flutter/material.dart';
import '../presenter/login_presenter.dart';
import '../presenter/global_presenter.dart';
import 'HomePage.dart';

class LoginButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/UMDGYM.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(160, 20, 50, 31),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: 30),
                Image.asset(
                  'assets/images/MachoMuscleMania.png',
                  height: 300,
                  width: 400,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'MontserratB',
                      fontSize: 80,
                      color: const Color.fromARGB(255, 244, 238, 227),
                    ),
                    children: const <TextSpan>[TextSpan(text: 'BEAST Mode')],
                  ),
                ),
                const Divider(
                  height: 20,
                  thickness: 7,
                  indent: 30,
                  endIndent: 30,
                  color: Color.fromARGB(255, 244, 238, 227),
                ),
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
                    backgroundColor: Color.fromARGB(255, 244, 238, 227),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Color.fromARGB(255, 20, 50, 31),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RubikL',
                      fontSize: 25,
                    ),
                  ),
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
                    backgroundColor: Color.fromARGB(255, 244, 238, 227),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Color.fromARGB(255, 20, 50, 31),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RubikL',
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
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
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SizedBox(height: 100),
              Container(
                height: constraints.maxHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/UMDGYM.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: constraints.maxHeight,
                color: const Color.fromARGB(160, 20, 50, 31),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 20, 50, 31),
                          ),
                        ),
                        SizedBox(height: 160),
                        Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'MontserratB',
                                fontSize: 40,
                                color: const Color.fromARGB(255, 244, 238, 227),
                              ),
                              children: const <TextSpan>[
                                TextSpan(text: '\n  Login'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 80),
                        Positioned(
                          left: -5,
                          right: -5,
                          top: 200,
                          bottom: -15,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 244, 238, 227),
                              border: Border.all(
                                width: 5.0,
                                color: Color.fromARGB(255, 244, 238, 227),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 20),
                                  LoginTextField(
                                    userNameText: userNameText,
                                    hintText: 'Username',
                                    obscure: false,
                                  ),
                                  SizedBox(height: 12),
                                  LoginTextField(
                                    userNameText: passWordText,
                                    hintText: 'Password',
                                    obscure: true,
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: 400,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 20, 50, 31),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 16.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        bool isValid =
                                            await presenter.CheckAccountInfo(
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
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'RubikL',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                            255,
                                            244,
                                            238,
                                            227,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              backButton(context),
            ],
          );
        },
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
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SizedBox(height: 100),
              Container(
                height: constraints.maxHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/UMDGYM.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: constraints.maxHeight,
                color: const Color.fromARGB(160, 20, 50, 31),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 160),
                        Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'MontserratB',
                                fontSize: 40,
                                color: const Color.fromARGB(255, 244, 238, 227),
                              ),
                              children: const <TextSpan>[
                                TextSpan(text: '  Create\n  Account'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 80),
                        Positioned(
                          left: -5,
                          right: -5,
                          top: 200,
                          bottom: -15,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 244, 238, 227),
                              border: Border.all(
                                width: 5.0,
                                color: Color.fromARGB(255, 244, 238, 227),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 30),
                                  LoginTextField(
                                    userNameText: userNameText,
                                    hintText: 'Username',
                                    obscure: false,
                                  ),
                                  SizedBox(height: 12),
                                  LoginTextField(
                                    userNameText: emailText,
                                    hintText: 'Email',
                                    obscure: false,
                                  ),
                                  SizedBox(height: 12),
                                  LoginTextField(
                                    userNameText: passWordText,
                                    hintText: 'Password',
                                    obscure: true,
                                  ),
                                  SizedBox(height: 12),
                                  LoginTextField(
                                    userNameText: confirmPassWordText,
                                    hintText: 'Confirm Password',
                                    obscure: true,
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                    width: 400,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 20, 50, 31),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 16.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: handleCreateAccount,
                                      child: const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          fontFamily: 'RubikL',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                            255,
                                            244,
                                            238,
                                            227,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //container
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              backButton(context),
            ],
          );
        },
      ),
    );
  }
}

// Credit: Eva Elvarsdottir from BIG sleeperzzz
Widget backButton(BuildContext context) {
  return Stack(
    children: [
      Positioned(
        top: 35,
        left: 10,
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 35,
          color: Color.fromARGB(255, 244, 238, 227),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ],
  );
}

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.userNameText,
    required this.hintText,
    required this.obscure,
  });

  final TextEditingController userNameText;
  final String hintText;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        // color: Color.fromARGB(255, 46, 105, 70),
        fontFamily: 'RubikL',
        fontWeight: FontWeight.bold,
      ),
      controller: userNameText,
      obscureText: obscure,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 20, 50, 31),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(width: 3.0, color: Colors.blue),
        ),
        hintText: hintText,
      ),
    );
  }
}
