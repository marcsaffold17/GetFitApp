import 'package:flutter/material.dart';
import '../model/checklist_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/checklist_presenter.dart';
import '../presenter/global_presenter.dart';
import '../view/nav_bar.dart';

class ChecklistPage extends StatefulWidget {
  final bool isFromNavbar;

  const ChecklistPage({Key? key, required this.isFromNavbar}) : super(key: key);

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  List<ChecklistItem> items = [];
  final _textController = TextEditingController();
  final ChecklistPresenter presenter = ChecklistPresenter();

  final favoritesRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalUsername)
      .collection('checklist');

  @override
  void initState() {
    super.initState();
    presenter.loadItems().then((loadedItems) {
      setState(() {
        items = loadedItems;
      });
    });
  }

  void _save() => presenter.saveItems(items);

  void _addItem(String text) {
    setState(() {
      items.add(ChecklistItem(text: text, isChecked: false));
    });
    _textController.clear();
    _save();
  }

  void _toggleItem(int index) {
    setState(() {
      items[index].isChecked = !items[index].isChecked;
    });
    _save();
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 244, 238, 227)),
        centerTitle: true,
        title: const Text(
          'My Checklist',
          style: TextStyle(
            color: Color.fromARGB(255, 244, 238, 227),
            fontFamily: 'MontserratB',
          ),
        ),
        backgroundColor: Color.fromARGB(255, 20, 50, 31),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      drawer: widget.isFromNavbar ? const NavBar() : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                    255,
                    229,
                    221,
                    212,
                  ), // full background color
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Add a new item',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(200, 46, 105, 70),
                            fontFamily: 'RubikL',
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (text) {
                          if (text.isNotEmpty) _addItem(text);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_rounded,
                        color: Color.fromARGB(255, 46, 105, 70),
                      ),
                      onPressed: () {
                        if (_textController.text.isNotEmpty) {
                          _addItem(_textController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  items.isEmpty
                      ? Center(
                        child: Text(
                          'No items yet. Add something!',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                      : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Dismissible(
                            key: Key(item.text + index.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _removeItem(index),
                            background: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Add curved edges
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: const Color.fromARGB(238, 202, 59, 59),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color:
                                    item.isChecked
                                        ? Colors.green.withOpacity(0.1)
                                        : Color.fromARGB(255, 229, 221, 212),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CheckboxListTile(
                                activeColor: Color.fromARGB(255, 46, 105, 70),
                                title: Text(
                                  item.text,
                                  style: TextStyle(
                                    fontFamily: 'RubikL',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration:
                                        item.isChecked
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                    color:
                                        item.isChecked
                                            ? Colors.grey
                                            : Color.fromARGB(255, 46, 105, 70),
                                  ),
                                ),
                                value: item.isChecked,
                                onChanged: (_) => _toggleItem(index),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: const Color.fromARGB(255, 46, 105, 70),
                                  width: 2,
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
