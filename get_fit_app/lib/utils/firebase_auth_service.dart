import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      // Store user info in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'password': password, // It is not recommended to store plain passwords.
      });
      return userCredential.user;
    } catch (e) {
      throw Exception("Failed to sign up: $e");
    }
  }

  // Sign in
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("Failed to sign in: $e");
    }
  }
}
