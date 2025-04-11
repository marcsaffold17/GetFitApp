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
    // Replace with actual logic to get the current user's ID
    String userId = "exampleUserId";

    final repository = BadgeRepository(userId: userId);
    presenter = BadgePresenter(repository: repository);
    presenter.view = this;
    presenter.loadBadges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badges')),
      body: _badges.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : BadgeGrid(badges: _badges),
    );
  }

  @override
  void displayBadges(List<badge_model.Badge> badges) {
    setState(() {
      _badges = badges;
    });
  }

  @override
  void showBadgeUnlocked(String badgeId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Badge $badgeId unlocked!')),
    );
  }
}
