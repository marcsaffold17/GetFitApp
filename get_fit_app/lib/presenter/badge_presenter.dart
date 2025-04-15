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
        description: 'You have not completed a streak yet!',
        iconUrl: 'https://images.icon-icons.com/4018/PNG/512/prohibition_signaling_flame_fireplace_allowed_fire_no_icon_255686.png',
        isUnlocked: false,
      ),
      Badge(
        id: 'test3',
        Title: 'Gym Bros',
        description: 'You made your first friend!',
        iconUrl: 'https://i.kym-cdn.com/entries/icons/mobile/000/012/468/shakeee.jpg',
        isUnlocked: true,
      ),
      Badge(
        id: 'test4',
        Title: 'I ❤️ Pain',
        description: 'You did a grueling workout!',
        iconUrl: 'https://i.pinimg.com/736x/a1/44/f4/a144f4ab354485029bd7ba8f8cf696cb--weight-lifting-first-day.jpg',
        isUnlocked: true,

      )]);
  }

  void unlockBadge(String badgeId) {
    repository.unlockBadge(badgeId);
  }
}
