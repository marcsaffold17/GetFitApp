import 'package:flutter/material.dart';
import '../main.dart';
import '../view/favorites_page.dart';
import 'login_HomePage.dart';
import '../view/login_view.dart';
import '../view/SettingsPage.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

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
                                const MyHomePage(title: 'Home', username: ''),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.star_border_outlined,
                    color: Colors.black,
                  ),
                  title: const Text("Favorites"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritesPage(),
                      ),
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
        ],
      ),
    );
  }
}
