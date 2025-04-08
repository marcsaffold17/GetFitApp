import 'package:cloud_firestore/cloud_firestore.dart';

class Badge {
  String id;
  String name;
  String description;
  String iconUrl;
  bool isUnlocked;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.isUnlocked,
  });

  // Convert from Firestore DocumentSnapshot to Badge
  factory Badge.fromFirestore(Map<String, dynamic> data) {
    return Badge(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      iconUrl: data['iconUrl'] ?? '',
      isUnlocked: data['isUnlocked'] ?? false,
    );
  }

  // Convert Badge to a Map for Firestore updates
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'isUnlocked': isUnlocked,
    };
  }
}

// =======================
// Repository for Badges
// =======================

class BadgeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  BadgeRepository({required this.userId});

  // Fetch badges from Firestore
  Stream<List<Badge>> getBadges() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('badges')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Badge.fromFirestore(doc.data()))
            .toList());
  }

  // Unlock a badge in Firestore
  Future<void> unlockBadge(String badgeId) async {
    await _firestore.collection('users').doc(userId).collection('badges').doc(badgeId)
        .update({'isUnlocked': true});

  }
}
