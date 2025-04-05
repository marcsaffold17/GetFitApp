import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/checklist_item.dart';

class ChecklistPresenter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save the entire checklist to Firestore under the user's document
  Future<void> saveChecklist(List<ChecklistItem> items) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final itemsMap = items.map((item) => item.toMap()).toList();

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('checklist')
        .doc('data')
        .set({'items': itemsMap});
  }

  /// Load the user's checklist from Firestore
  Future<List<ChecklistItem>> loadChecklist() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final doc =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('checklist')
            .doc('data')
            .get();

    if (!doc.exists || !doc.data()!.containsKey('items')) return [];

    final List<dynamic> itemsData = doc.data()!['items'];
    return itemsData
        .map((item) => ChecklistItem.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
