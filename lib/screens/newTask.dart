import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:done/components/newCategory.dart';
import 'package:done/homePage.dart';

class newTask extends StatefulWidget {
  @override
  _newTaskState createState() => _newTaskState();
}

class _newTaskState extends State<newTask> {
  TextEditingController controller;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
    getCurrentUser();
  }

  FirebaseUser loggedInUser;
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  String userUid;
  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
    }
    userUid = loggedInUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    String task = '';
    String category = 'Other';
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset('images/topBarBackground.png',
                  width: double.infinity, fit: BoxFit.fill),
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 80),
                    Icon(
                      Icons.add,
                      color: Colors.blue,
                      size: 50,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Add new task',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        onChanged: (value) {
                          task = value;
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter a task name'),
                        autofocus: true,
                        focusNode: focusNode,
                        controller: controller,
                      ),
                    ),
//                    SizedBox(height: 30),
                    Container(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 50.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            newCategory('Work', Colors.green, () {
                              category = 'work';
                            }),
                            newCategory('Meeting', Colors.purple, () {
                              category = 'meeting';
                            }),
                            newCategory('Study', Colors.blue, () {
                              category = 'study';
                            }),
                            newCategory('Shopping', Colors.orange, () {
                              category = 'shopping';
                            }),
                            newCategory('Other', Colors.grey, () {
                              category = 'other';
                            }),
                          ],
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        print('clicked');
                        _fireStore.document('Userss');
                        _fireStore.collection('Userss/$userUid/Tasks').add({
                          'Category': category,
                          'Task': task,
                        });
                        print('added');
                        final snackBar =
                            SnackBar(content: Text("Task Added Succesfully"));

                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child: Image.asset('images/addTaskButton.png'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
