import 'package:flutter/material.dart';
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
      child: Column(
        children: [
          Container(
            color: Colors.deepPurple[200],
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
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home_outlined, color: Colors.black),
                  title: const Text("Home"),
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
                    color: Colors.black,
                  ),
                  title: const Text("Checklist"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChecklistPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.black),
                  title: const Text("Settings"),
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
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text("Logout"),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
