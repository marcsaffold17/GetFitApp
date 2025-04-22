import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get uid => _auth.currentUser?.uid ?? '';

  Future<Map<String, dynamic>> fetchProfileData() async {
    if (uid.isEmpty) throw Exception("User not logged in");
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  Future<void> updateBio(String bio) async {
    if (uid.isEmpty) return;
    await _firestore.collection('users').doc(uid).set({
      'bio': bio,
    }, SetOptions(merge: true));
  }

  Future<String> uploadProfileImage(File imageFile) async {
    if (uid.isEmpty) throw Exception("User not logged in");

    final ref = _storage.ref().child('profile_images/$uid.jpg');
    await ref.putFile(imageFile);
    final url = await ref.getDownloadURL();
    await _firestore.collection('users').doc(uid).set({
      'profileImageUrl': url,
    }, SetOptions(merge: true));
    return url;
  }
}
