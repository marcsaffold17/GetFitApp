import '../model/badge_model.dart';
import '../view/badge_screen.dart';

class BadgePresenter {
  final BadgeRepository repository;
  final BadgeView view;

  BadgePresenter({required this.repository, required this.view});

  void loadBadges() async {
    final badges = await repository.fetchBadges();
    view.displayBadges(badges);
  }

  void unlockBadge(String badgeId) async {
    print("unlockBadge called with $badgeId");
    await repository.markBadgeUnlocked(badgeId);
    view.showBadgeUnlocked(badgeId);
    loadBadges();
  }



  // All Unlock Logic Below This Point


  void unlockFirstWorkoutAddedBadge() {
    unlockBadge('first_workout_added');
  }
  void unlockFoundScugBadge() {
    unlockBadge('foundscug');
  }
}
