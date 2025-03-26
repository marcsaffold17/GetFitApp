import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/firebase_auth_service.dart';
import '../model/user_model.dart';

class AuthPresenter {
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Sign up method
  Future<void> signUp(
    BuildContext context,
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      _showError(context, "Passwords do not match.");
      return;
    }
    try {
      User? user = await _authService.signUp(email, password);
      if (user != null) {
        _showSuccess(context, "Account created successfully!");
      }
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  // Sign in method
  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      User? user = await _authService.signIn(email, password);
      if (user != null) {
        _showSuccess(context, "Logged in successfully!");
      }
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  // Show success message
  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Show error message
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
