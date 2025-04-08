import '../model/badge_model.dart';
import '../view/badge_screen.dart';

class BadgePresenter {
  late BadgeView view;
  final BadgeRepository repository;

  BadgePresenter({required this.view, required this.repository});

  void loadBadges() {
    repository.getBadges().listen((badges) {
      view.displayBadges(badges);
    });
  }

  void unlockBadge(String badgeId) {
    repository.unlockBadge(badgeId).then((_) {
      view.showBadgeUnlocked(badgeId);
    });
  }
}