import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:done/components/newCategory.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:done/components/TASK.dart';
import 'package:done/screens/home.dart';

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
    Color color = Colors.grey;
    return SingleChildScrollView(
      child: Column(
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
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      margin: EdgeInsets.only(top: 10, bottom: 20.0),
                      height: 70.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          newCategory('Work', Colors.green, () {
                            category = 'work';
                            color = Colors.green;
                          }),
                          newCategory('Meeting', Colors.purple, () {
                            category = 'meeting';
                            color = Colors.purple;
                          }),
                          newCategory('Study', Colors.blue, () {
                            category = 'study';
                            color = Colors.blue;
                          }),
                          newCategory('Shopping', Colors.orange, () {
                            category = 'shopping';
                            color = Colors.orange;
                          }),
                          newCategory('Other', Colors.grey, () {
                            category = 'other';
                            color = Colors.grey;
                          }),
                        ],
                      ),
                    ),
                  ),

                  Column(
                    children: <Widget>[
                      Container(
                          padding:
                              EdgeInsets.only(bottom: 20, right: 20, left: 20),
                          child: BasicDateTimeField()),
                    ],
                  ),
                  FlatButton(
                    onPressed: () {
                      print('clicked');
                      TASK newTask =
                          new TASK(task, category, color, false, pickedTime);
                      taskRef.add(newTask.toJson());

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
    );
  }
}

var pickedTime;

class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        decoration: InputDecoration(
          labelText: "Choose Date",
          border: OutlineInputBorder(),
        ),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            pickedTime = DateTimeField.combine(date, time);
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    ]);
  }
}
