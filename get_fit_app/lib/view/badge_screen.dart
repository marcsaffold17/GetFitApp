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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 🔐 Use the actual user ID from auth, for now we hardcode
    String userId = "Daniel"; // match your Firestore doc ID under Login_Info
    final repository = badge_model.BadgeRepository(userId: userId);
    presenter = BadgePresenter(repository: repository, view: this);
    presenter.loadBadges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Badges', style: TextStyle(color: Color(0xFFF4EEE3))),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(233, 20, 50, 31),
        iconTheme: const IconThemeData(color: Color(0xFFF4EEE3)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFD9D6CF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _badges.isEmpty
            ? const Center(child: Text("No badges found."))
            : BadgeGrid(badges: _badges, presenter: presenter),
      ),
    );
  }

  @override
  void displayBadges(List<badge_model.Badge> badges) {
    print("Display called with ${badges.length} badges");
    setState(() {
      _badges = badges;
      _isLoading = false;
    });
  }

  @override
  void showBadgeUnlocked(String badgeId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🎉 Badge "$badgeId" unlocked!')),
    );
  }
}
