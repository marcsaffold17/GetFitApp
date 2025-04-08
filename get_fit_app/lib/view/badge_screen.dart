import 'package:flutter/material.dart';
import '../model/badge_model.dart';
import '../presenter/badge_presenter.dart';
import 'badge_grid.dart';

abstract class BadgeView {
  void displayBadges(List<Badge> badges);
  void showBadgeUnlocked(String badgeId);
}

class BadgeScreen extends StatefulWidget {
  final BadgePresenter presenter;

  const BadgeScreen({required this.presenter, super.key});

  @override
  _BadgeScreenState createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> implements BadgeView {
  List<Badge> _badges = [];

  @override
  void initState() {
    super.initState();
    widget.presenter.view = this;
    widget.presenter.loadBadges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Badges')),
      body: BadgeGrid(badges: _badges, presenter: widget.presenter),
    );
  }

  @override
  void showBadgeUnlocked(String badgeId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Badge $badgeId unlocked!')),
    );
  }
}