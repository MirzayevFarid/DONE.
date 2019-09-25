import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/components/inputField.dart';
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
        body: Column(
          children: <Widget>[
            categoryStream(devWidth),
          ],
        ),
      ),
    );
  }
}

addCategories(String category, Color color) {
  final CollectionReference categoryRef =
      _fireStore.document('Userss').collection('$userUid/Categories');
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

        final addNewCategoryCardd = categoryCard(devWidth, Icons.add,
            Colors.grey.value, 'Add new', 'add new task', true);
        messageBubbles.add(addNewCategoryCardd);
        for (var message in messages) {
          final category = message.data['Category'];
          final color = message.data['Color'];

          final newCategoryCard = categoryCard(devWidth, Icons.check, color,
              category, '5 tasks remaining', false);
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

class buildAlert extends StatelessWidget {
  String text;
  String category;
  bool isNew;
  var devWidth;
  buildAlert(
    this.text,
    this.category,
    this.isNew,
    this.devWidth,
  );
  @override
  Widget build(BuildContext context) {
    var currentColor;
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
                ),
                MaterialButton(
                  color: Colors.blueAccent,
                  child: Text('DONE'),
                  onPressed: () {
                    addCategories(category, currentColor.value);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class categoryCard extends StatelessWidget {
  categoryCard(this.devWidth, this.icon, this.color, this.category,
      this.subText, this.isNew);
  double devWidth;
  String category;
  String subText;
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
                    MaterialButton(
                      color: Colors.blueAccent,
                      child: Text('DONE'),
                      onPressed: () {
                        if (isNew) {
                          addCategories(category, currentColor);
                        }
                        Navigator.pop(context);
                      },
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
            Text(
              subText,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: Colors.grey,
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
