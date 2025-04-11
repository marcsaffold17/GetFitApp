import 'package:cloud_firestore/cloud_firestore.dart';

class Badge {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final bool isUnlocked;

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.isUnlocked,
  });

  // Convert from Firestore DocumentSnapshot to Badge
  factory Badge.fromFirestore(Map<String, dynamic> data) {
    return Badge(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconUrl: data['iconUrl'] ?? '',
      isUnlocked: data['isUnlocked'] ?? false,
    );
  }

  // Convert Badge to a Map for Firestore updates
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
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
        .collection('Login_Info')
        .doc(userId)
        .collection('Badges')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Badge.fromFirestore(doc.data()..['id'] = doc.id))
        .toList());
  }

  // Unlock a badge in Firestore
  Future<void> unlockBadge(String badgeId) async {
    await _firestore
        .collection('Login_Info')
        .doc(userId)
        .collection('Badges')
        .doc(badgeId)
        .update({'isUnlocked': true});

  }
}
