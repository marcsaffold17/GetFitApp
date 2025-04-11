import 'package:flutter/material.dart';
import '../model/badge_model.dart' as badge_model;
import '../presenter/badge_presenter.dart';

class BadgeGrid extends StatelessWidget {
  final List<badge_model.Badge> badges;
  final BadgePresenter presenter;

  const BadgeGrid({super.key, required this.badges, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final badge = badges[index];
        return GestureDetector(
          onTap: badge.isUnlocked
              ? () => presenter.unlockBadge(badge.id)
              : null,
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                badge.iconUrl,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40),
                ),
                const SizedBox(height: 8),
                Text(badge.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(badge.description),
                Image.network(
                    badge.iconUrl,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40),
                ),

                const SizedBox(height: 8),
                Text(badge.title, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(badge.description),
                if (!badge.isUnlocked)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text("Locked", style: TextStyle(color: Colors.red))
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
