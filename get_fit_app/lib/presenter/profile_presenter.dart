import 'dart:io';
import 'profile_model.dart';
import 'profile_page.dart';

class ProfilePresenter {
  final ProfileModel model;
  final ProfileView view;

  ProfilePresenter({required this.model, required this.view});

  void loadProfileData() async {
    try {
      view.showLoading(true);
      final data = await model.fetchProfileData();
      view.showBio(data['bio'] ?? '');
      view.showProfileImage(data['profileImageUrl']);
    } catch (e) {
      view.showError('Failed to load profile: $e');
    } finally {
      view.showLoading(false);
    }
  }

  void updateBio(String bio) async {
    try {
      await model.updateBio(bio);
    } catch (e) {
      view.showError('Failed to save bio');
    }
  }

  void uploadImage(File image) async {
    try {
      view.showLoading(true);
      final url = await model.uploadProfileImage(image);
      view.showProfileImage(url);
    } catch (e) {
      view.showError('Image upload failed');
    } finally {
      view.showLoading(false);
    }
  }
}
