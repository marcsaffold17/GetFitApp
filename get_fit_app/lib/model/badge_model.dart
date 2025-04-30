// badge_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_fit_app/presenter/global_presenter.dart';

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

    print("Fetched \${snapshot.docs.length} badge documents");

    return snapshot.docs
        .map((doc) => Badge.fromFirestore(doc.data(), doc.id))
        .toList();
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

  Future<void> checkAndUnlockBadge({
    required String badgeId,
    required String badgeTitle,
    required String badgeDescription,
    required String badgeIconUrl,
    required bool badgeisUnlocked,
  }) async {
    try {
      final badgeDoc = await _firestore
          .collection('Login-Info')
          .doc(globalUsername)
          .collection('badges')
          .doc(badgeId)
          .get();

      if (!badgeDoc.exists || !(badgeDoc.data()?['isUnlocked'] ?? false)) {
        await _firestore
            .collection('Login-Info')
            .doc(globalUsername)
            .collection('badges')
            .doc(badgeId)
            .set({
          'badgeId': badgeId,
          'badgeTitle': badgeTitle,
          'badgeDescription': badgeDescription,
          'badgeIconUrl': badgeIconUrl,
          'isUnlocked': true,
        });

        print('Badge unlocked: \$badgeTitle');
      }
    } catch (e) {
      print('Error checking and unlocking badge: \$e');
    }
  }
}
