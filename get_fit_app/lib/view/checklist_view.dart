import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Checklist',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChecklistPage(),
    );
  }
}

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  List<ChecklistItem> items = [];
  final TextEditingController _textController = TextEditingController();

  void _addItem(String text) {
    setState(() {
      items.add(ChecklistItem(text: text, isChecked: false));
    });
    _textController.clear();
  }

  void _toggleItem(int index) {
    setState(() {
      items[index].isChecked = !items[index].isChecked;
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Checklist')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'Add a new item'),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        _addItem(text);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _addItem(_textController.text);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(items[index].text),
                  value: items[index].isChecked,
                  onChanged: (bool? value) {
                    _toggleItem(index);
                  },
                  secondary: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeItem(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChecklistItem {
  String text;
  bool isChecked;

  ChecklistItem({required this.text, required this.isChecked});
}
