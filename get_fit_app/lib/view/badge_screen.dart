import 'package:flutter/material.dart';
import '../model/badge_model.dart' as model;
import '../presenter/badge_presenter.dart';
import 'badge_grid.dart';

abstract class BadgeView {
  void displayBadges(List<model.Badge> badges);
  void showBadgeUnlocked(String badgeId);
}

class BadgeScreen extends StatefulWidget {
  final BadgePresenter presenter;

  const BadgeScreen({required this.presenter, super.key});

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> implements BadgeView {
  List<model.Badge> _badges = [];

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
  void displayBadges(List<model.Badge> badges) {
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