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
          onTap: () {
            if (badge.id == "foundscug" && badge.isUnlocked) {
              presenter.unlockFoundScugBadge();
            }
            showDialog(
              context: context,
                builder: (_) => AlertDialog(
                  title: Text(badge.title),
                  content: Text(badge.description),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                   ],
                ),
               );
            },
          child: Card(
            color: const Color(0xFFDBD7D2),
            child: Column(
              children: [
                Image.network(badge.iconUrl, width: 100, height: 100),
                Text(badge.title),
                if (badge.isUnlocked)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        );
      },
    );
  }
}
