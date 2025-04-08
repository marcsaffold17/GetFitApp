import 'package:flutter/material.dart';
import '../model/badge_model.dart' as model;
import '../presenter/badge_presenter.dart';

class BadgeItem extends StatelessWidget {
  final model.Badge badge;
  final BadgePresenter presenter;

  const BadgeItem({required this.badge, required this.presenter, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!badge.isUnlocked) {
          presenter.unlockBadge(badge.id);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(badge.iconUrl, height: 60, width: 60),
          SizedBox(height: 4),
          Text(badge.name, style: TextStyle(fontSize: 12)),
          Icon(
            badge.isUnlocked ? Icons.check_circle : Icons.lock,
            color: badge.isUnlocked ? Colors.green : Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }
}
