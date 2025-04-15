import 'package:flutter/material.dart';
import 'package:get_fit_app/view/LeaderboardPage.dart';
import '../view/HomePage.dart';
import '../view/SettingsPage.dart';
import '../view/checklist_view.dart';
import '../view/login_view.dart';
import '../presenter/global_presenter.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  void _logout(BuildContext context) {
    globalUsername = null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginButtonPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      child: Column(
        children: [
          Container(
            color: Color.fromARGB(255, 20, 50, 31),
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 28,
                        color: Color.fromARGB(255, 244, 238, 227),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 244, 238, 227)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home_outlined, color: Color.fromARGB(255,46, 105, 70)),
                  title: const Text("Home", style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const MyHomePage(title: 'Home', username: ""),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.checklist_rounded,
                    color: Color.fromARGB(255, 46, 105, 70),
                  ),
                  title: const Text("Checklist", style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChecklistPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.auto_graph_outlined,
                    color: Color.fromARGB(255, 46, 105, 70),
                  ),
                  title: const Text("LeaderBoard", style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeaderboardPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Color.fromARGB(255, 46, 105, 70)),
                  title: const Text("Settings", style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Color.fromARGB(255, 46, 105, 70)),
            title: const Text("Logout", style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

// Credit for UI help and emotional support during UI work: Eva :>