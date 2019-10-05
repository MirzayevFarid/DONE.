import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/components/inputField.dart';
import 'package:done/components/roundButton.dart';
import 'package:done/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

final _fireStore = Firestore.instance;
List<categoryCard> categoryList = [];

class _CategoriesState extends State<Categories> {
  final CollectionReference categoryRef =
      _fireStore.document('Userss').collection('$userUid/Categories');

  @override
  void initState() {
    super.initState();
    MessagesStream().build(context);
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    var categoryName = '';
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              categoryStream(devWidth),
            ],
          ),
        ),
      ),
    );
  }
}

final db = Firestore.instance;
editCategory(String categoryName, int color, String id) async {
  await db
      .document('Userss')
      .collection('$userUid/Categories')
      .document(id)
      .updateData(
    {
      'Category': categoryName,
      'Color': color,
    },
  );
}

addCategory(String category, Color color) {
  categoryRef.add(
    {
      'Category': category,
      'Color': color.value,
    },
  );
}

class categoryStream extends StatelessWidget {
  categoryStream(this.devWidth);
  double devWidth;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .document('Userss')
          .collection('$userUid/Categories')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data.documents;
        List<categoryCard> messageBubbles = [];

        final addNewCategoryCardd = categoryCard(
            'Add New', devWidth, Icons.add, Colors.grey.value, 'Add new', true);
        messageBubbles.add(addNewCategoryCardd);
        for (var message in messages) {
          final category = message.data['Category'];
          final color = message.data['Color'];

          final newCategoryCard = categoryCard(message.documentID, devWidth,
              Icons.check, color, category, false);
          messageBubbles.add(newCategoryCard);
        }

        return Expanded(
          child: messageBubbles.length == 0
              ? noTask()
              : SingleChildScrollView(
                  child: Wrap(
                    children: messageBubbles,
                  ),
                ),
        );
      },
    );
  }
}

class categoryCard extends StatelessWidget {
  categoryCard(
      this.id, this.devWidth, this.icon, this.color, this.category, this.isNew);
  String id;
  double devWidth;
  String category;
  int color;
  IconData icon;
  bool isNew;
  Color currentColor = Colors.amber;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Select a color'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: inputField(
                          TextInputAction.next,
                          TextInputType.multiline,
                          'Enter Category',
                          false, (value) {
                        category = value;
                      }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BlockPicker(
                      pickerColor: currentColor,
                      onColorChanged: (selectedColor) {
                        currentColor = selectedColor;
                      },
                    ),
                    SingleChildScrollView(
                      child: Wrap(
                        children: <Widget>[
                          roundButton('Save', () {
                            if (isNew) {
                              addCategory(category, currentColor);
                            } else {
                              editCategory(category, currentColor.value, id);
                            }
                            Navigator.pop(context);
                          }, Colors.blueAccent,
                              MediaQuery.of(context).size.width / 2 - 20),
                          roundButton('Cancel', () {
                            Navigator.pop(context);
                          }, Colors.blueAccent,
                              MediaQuery.of(context).size.width / 2 - 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Color(color),
              size: 40,
            ),
            Text(
              category,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        height: 200,
        width: devWidth / 2 - 30,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
