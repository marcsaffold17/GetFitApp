import 'package:flutter/material.dart';
import '../model/badge_model.dart' as badge_model;
import '../presenter/badge_presenter.dart'; // ✅ this path must be correct

class BadgeGrid extends StatelessWidget {
  final List<badge_model.Badge> badges;
  final BadgePresenter presenter;

  const BadgeGrid({super.key, required this.badges, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: badges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final badge = badges[index];
        return GestureDetector(
          onTap: badge.isUnlocked
              ? () => presenter.unlockBadge(badge.id) // ✅ should now work
              : null,
          child: Card(
            child: Column(
              children: [
                Image.network(badge.iconUrl, width: 40, height: 40),
                Text(badge.title),
              ],
            ),
          ),
        );
      },
    );
  }
}
