import 'package:flutter/material.dart';
import '../model/badge_model.dart' as badge_model;

class BadgeItem extends StatelessWidget {
  final badge_model.Badge badge;
  final VoidCallback? onTap;

  const BadgeItem({super.key, required this.badge, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: badge.isUnlocked ? onTap : null,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                badge.iconUrl,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, size: 50),
              ),
              const SizedBox(height: 8),
              Text(badge.title,
                  style: const TextStyle(fontFamily: "Montserrat")),
              Text(badge.description,
                  style: const TextStyle(color: Colors.grey)),
              if (!badge.isUnlocked)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child:
                  Text("Locked", style: TextStyle(color: Colors.redAccent)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
