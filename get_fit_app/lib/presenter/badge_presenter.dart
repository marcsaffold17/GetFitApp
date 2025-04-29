import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/badge_model.dart';
import '../presenter/global_presenter.dart';
import '../view/badge_screen.dart';

class BadgePresenter {
  final BadgeView view;
  final BadgeRepository repository;

  BadgePresenter({required this.view, required this.repository});

  Future<void> loadBadges() async {
    try {
      final badges = await repository.fetchBadges();
      view.displayBadges(badges);
    } catch (e) {
      print("Error loading badges: $e");
    }
  }

  Future<void> unlockFirstWorkoutBadge() async {
    try {
      await repository.checkAndUnlockBadge(
        badgeId: 'firstworkoutadded',
        badgeTitle: 'First Workout Added',
        badgeDescription: 'Unlocked when you add your first workout',
        badgeIconUrl: 'https://i.kym-cdn.com/photos/images/original/000/685/444/c89.jpg',
        badgeisUnlocked: true,
      );
      await loadBadges(); // Refresh UI if needed
    } catch (e) {
      print('Error unlocking first workout badge: $e');
    }
  }

  Future<void> unlockFiveWorkoutsBadge() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Login-Info')
          .doc(globalUsername)
          .collection('Workout-Plan')
          .get();

      int workoutCount = 0;

      for (final doc in snapshot.docs) {
        final subCollection = await doc.reference.collection('Workout').get();
        workoutCount += subCollection.docs.length;
      }

      if (workoutCount >= 5) {
        await repository.checkAndUnlockBadge(
          badgeId: 'fiveworkouts',
          badgeTitle: '5 Workouts Complete',
          badgeDescription: 'Unlocked after completing 5 workouts',
          badgeIconUrl: 'https://static.thenounproject.com/png/1426512-200.png',
          badgeisUnlocked: true,
        );
        await loadBadges(); // Refresh UI if needed
      }
    } catch (e) {
      print('Error unlocking 5 workouts badge: $e');
    }
  }
}
