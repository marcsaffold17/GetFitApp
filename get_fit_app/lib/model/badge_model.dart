import 'package:cloud_firestore/cloud_firestore.dart';

class Badge {
  final String id;
  final String Title;
  final String description;
  final String iconUrl;
  final bool isUnlocked;

  Badge({
    required this.id,
    required this.Title,
    required this.description,
    required this.iconUrl,
    required this.isUnlocked,
  });

  factory Badge.fromFirestore(Map<String, dynamic> data) {
    return Badge(
      id: data['id'] ?? '',
      Title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconUrl: data['iconUrl'] ?? '',
      isUnlocked: data['isUnlocked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': Title,
      'description': description,
      'iconUrl': iconUrl,
      'isUnlocked': isUnlocked,
    };
  }
}

class BadgeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  BadgeRepository({required this.userId});

  Stream<List<Badge>> getBadges() {
    return _firestore
        .collection('Login_Info')
        .doc(userId)
        .collection('Badges')
        .snapshots()
        .map((snapshot) {
      final badges = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // ensure id is included
        print("Fetched badge: ${data['title']}, unlocked: ${data['isUnlocked']}");
        return Badge.fromFirestore(data);
      }).toList();

      print("Total fetched: ${badges.length}");
      return badges;
    });
  }


  Future<void> unlockBadge(String badgeId) async {
    print("Unlocking badge: $badgeId for user: $userId");

    await _firestore
        .collection('Login_Info')
        .doc(userId)
        .collection('Badges')
        .doc(badgeId)
        .update({'isUnlocked': true});

    print("Badge $badgeId unlocked");
  }
}
