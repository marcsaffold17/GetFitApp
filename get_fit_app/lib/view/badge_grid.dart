import 'package:flutter/material.dart';
import '../model/badge_model.dart' as model;
import '../presenter/badge_presenter.dart';
import 'badge_item.dart';

class BadgeGrid extends StatelessWidget {
  final List<model.Badge> badges;
  final BadgePresenter presenter;

  const BadgeGrid({required this.badges, required this.presenter, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: badges.length,
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        return BadgeItem(badge: badges[index], presenter: presenter);
      },
    );
  }
}
