import 'package:flutter/material.dart';
import '../model/badge_model.dart' as badge_model;
import '../presenter/badge_presenter.dart';
import 'badge_grid.dart';

abstract class BadgeView {
  void displayBadges(List<badge_model.Badge> badges);
  void showBadgeUnlocked(String badgeId);
}

class BadgeScreen extends StatefulWidget {
  const BadgeScreen({super.key});

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> implements BadgeView {
  late BadgePresenter presenter;
  List<badge_model.Badge> _badges = [];

  @override
  void initState() {
    super.initState();
    const String userId = "Daniel"; // Make sure this matches your Firestore
    final repository = badge_model.BadgeRepository(userId: userId);
    presenter = BadgePresenter(repository: repository, view: this);
    presenter.loadBadges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🧠 AppBar with styling
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 244, 238, 227),
        ),
        title: const Text(
          'My Badges',
          style: TextStyle(color: Color.fromARGB(255, 244, 238, 227)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(233, 20, 50, 31),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),

      // 🖼️ Background with optional image or color
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE7EFE9),
          // Uncomment below to use a background image instead
          // image: DecorationImage(
          //   image: AssetImage('assets/images/badge_bg.jpg'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: _badges.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : BadgeGrid(badges: _badges, presenter: presenter),
      ),
    );
  }

  // MVP method: called when presenter loads badges
  @override
  void displayBadges(List<badge_model.Badge> badges) {
    setState(() {
      _badges = badges;
    });
  }

  // MVP method: shows a toast/snackbar when a badge is unlocked
  @override
  void showBadgeUnlocked(String badgeId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Badge $badgeId unlocked!')),
    );
  }
}
