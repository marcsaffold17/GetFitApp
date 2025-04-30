import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/checklist_item.dart';
import 'global_presenter.dart';

class ChecklistPresenter {
  final _checklistRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalUsername)
      .collection('checklist');

  Future<List<ChecklistItem>> loadItems() async {
    final snapshot = await _checklistRef.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ChecklistItem(
        text: data['text'] ?? '',
        isChecked: data['isChecked'] ?? false,
      );
    }).toList();
  }

  Future<void> saveItems(List<ChecklistItem> items) async {
    // First, clear the current checklist
    final batch = FirebaseFirestore.instance.batch();
    final currentDocs = await _checklistRef.get();
    for (final doc in currentDocs.docs) {
      batch.delete(doc.reference);
    }

    // Then, write all current items
    for (final item in items) {
      final docRef = _checklistRef.doc(); // auto ID
      batch.set(docRef, {'text': item.text, 'isChecked': item.isChecked});
    }

    await batch.commit();
  }
}