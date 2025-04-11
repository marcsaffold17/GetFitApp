import '../model/badge_model.dart';
import '../view/badge_screen.dart';

class BadgePresenter {
  final BadgeRepository repository;
  BadgeView? view;

  BadgePresenter({required this.repository, required this.view});

  void loadBadges() {
    repository.getBadges().listen((badges) {
      view?.displayBadges(badges);
    });
  }

  void unlockBadge(String badgeId) {
    repository.unlockBadge(badgeId);
    view?.showBadgeUnlocked(badgeId);
  }
}