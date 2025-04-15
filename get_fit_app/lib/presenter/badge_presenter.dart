import '../model/badge_model.dart';
import '../view/badge_screen.dart';

class BadgePresenter {
  final BadgeView view;
  final BadgeRepository repository;

  BadgePresenter({required this.view, required this.repository});

  void loadBadges() {
    // 🚫 Comment this out for now:
    // repository.getBadges().listen((badges) {
    //   debugPrint('Total fetched: ${badges.length}');
    //   view.displayBadges(badges);
    // });

    // ✅ Add this for testing:
    view.displayBadges([
      Badge(
        id: 'test1',
        Title: 'First Badge',
        description: 'You did something cool!',
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/1828/1828884.png',
        isUnlocked: true,
      ),
      Badge(
        id: 'test2',
        Title: 'Locked Badge',
        description: 'Still locked!',
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/1828/1828884.png',
        isUnlocked: false,
      ),
    ]);
  }

  void unlockBadge(String badgeId) {
    repository.unlockBadge(badgeId);
  }
}
