import 'package:flutter/material.dart';
import '../model/badge_model.dart' as badge_model;
import '../presenter/badge_presenter.dart';

class BadgeGrid extends StatelessWidget {
  final List<badge_model.Badge> badges;
  final BadgePresenter presenter;

  const BadgeGrid({super.key, required this.badges, required this.presenter});

  @override
  Widget build(BuildContext context) {
    // 🔍 Debugging: Print how many badges we're showing
    print("🟡 BadgeGrid received ${badges.length} badges");

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: badges.length, // ✅ Important: specify how many items to show
      itemBuilder: (context, index) {
        final badge = badges[index];
        return GestureDetector(
          onTap:
              badge.isUnlocked ? () => presenter.unlockBadge(badge.id) : null,
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  badge.iconUrl,
                  width: 50,
                  height: 50,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 50),
                ),
                const SizedBox(height: 8),
                Text(
                  badge.Title, // ✅ Corrected casing
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(badge.description, textAlign: TextAlign.center),
                if (!badge.isUnlocked)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text("Locked", style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
