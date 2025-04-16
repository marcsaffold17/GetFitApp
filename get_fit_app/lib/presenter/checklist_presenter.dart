import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/checklist_item.dart';

class ChecklistPresenter {
  final String storageKey = 'checklist_items';

  Future<List<ChecklistItem>> loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString(storageKey);
    if (savedData != null) {
      List<dynamic> jsonList = jsonDecode(savedData);
      return jsonList.map((item) => ChecklistItem.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> saveItems(List<ChecklistItem> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList =
        items.map((item) => item.toJson()).toList();
    prefs.setString(storageKey, jsonEncode(jsonList));
  }
}
