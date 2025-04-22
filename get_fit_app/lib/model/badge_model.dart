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

  factory Badge.fromFirestore(Map<String, dynamic> data, String id) {
    return Badge(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconUrl: data['iconUrl'] ?? '',
      isUnlocked: data['isUnlocked'] ?? false,
    );
  }
}

class BadgeRepository {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BadgeRepository({required this.userId});

  Future<List<Badge>> fetchBadges() async {
    final snapshot = await _firestore
        .collection('Login-Info')
        .doc(userId)
        .collection('badges')
        .get();

    print("Fetched ${snapshot.docs.length} badge documents");

    return snapshot.docs.map((doc) => Badge.fromFirestore(doc.data(), doc.id)).toList();
  }

  Future<void> unlockBadge(String badgeId) async {
    final badgeRef = _firestore
        .collection('Login-Info')
        .doc(userId)
        .collection('badges')
        .doc(badgeId);

    await badgeRef.update({'isUnlocked': true});
  }

  Future<void> markBadgeUnlocked(String badgeId) async {
    final badgeRef = FirebaseFirestore.instance
        .collection('Login-Info')
        .doc(userId)
        .collection('badges')
        .doc(badgeId);

    await badgeRef.update({'isUnlocked': true});
  }

}
