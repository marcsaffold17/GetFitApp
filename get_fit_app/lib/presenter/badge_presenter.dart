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
}