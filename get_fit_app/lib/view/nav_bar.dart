import 'package:flutter/material.dart';
import 'package:get_fit_app/view/LeaderboardPage.dart';
import '../view/HomePage.dart';
import 'SettingsPage.dart';
import '../view/checklist_view.dart';
import '../view/login_view.dart';
import '../presenter/global_presenter.dart';
import '../view/badge_screen.dart';

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
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 244, 238, 227),
                    fontFamily: 'MontserratB',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Color.fromARGB(255, 229, 221, 212),
                  child: ListTile(
                    leading: const Icon(
                      Icons.home_outlined,
                      color: Color.fromARGB(255, 20, 50, 31),
                    ),
                    title: Text("Home", style: NavTextStyle()),
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
                ),
                ListTile(
                  leading: const Icon(
                    Icons.checklist_rounded,
                    color: Color.fromARGB(255, 20, 50, 31),
                  ),
                  title: Text("Checklist", style: NavTextStyle()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChecklistPage(isFromNavbar: true),
                      ),
                    );
                  },
                ),
                Container(
                  color: Color.fromARGB(255, 229, 221, 212),
                  child: ListTile(
                    leading: const Icon(
                      Icons.auto_graph_outlined,
                      color: Color.fromARGB(255, 20, 50, 31),
                    ),
                    title: Text("LeaderBoard", style: NavTextStyle()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => LeaderboardPage(
                                isFromNavbar: true,
                                chartColor: Colors.blue, // Corrected color
                              ),
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.badge_outlined,
                    color: Color.fromARGB(255, 20, 50, 31),
                  ),
                  title: Text("Introduction", style: NavTextStyle()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BadgeScreen(),
                      ),
                    );
                  },
                ),
                Container(
                  color: Color.fromARGB(255, 229, 221, 212),
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Color.fromARGB(255, 20, 50, 31),
                    ),
                    title: Text("Settings", style: NavTextStyle()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color.fromARGB(255, 20, 50, 31),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 244, 238, 227),
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Color.fromARGB(255, 244, 238, 227),
                  fontFamily: 'MontserratB',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle NavTextStyle() {
    return TextStyle(
      color: Color.fromARGB(255, 46, 105, 70),
      fontFamily: 'RubikL',
      fontWeight: FontWeight.bold,
    );
  }
}

// Credit for UI help and emotional support during UI work: Eva :>
// :(
