class ChecklistItem {
  String text;
  bool isChecked;

  ChecklistItem({required this.text, required this.isChecked});

  Map<String, dynamic> toJson() => {'text': text, 'isChecked': isChecked};

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(text: json['text'], isChecked: json['isChecked']);
  }
}
