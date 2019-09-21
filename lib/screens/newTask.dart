import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:done/components/newCategory.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:done/components/TASK.dart';
import 'package:done/screens/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class newTask extends StatefulWidget {
  static var flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  _newTaskState createState() => _newTaskState(flutterLocalNotificationsPlugin);
}

class _newTaskState extends State<newTask> {
  TextEditingController controller;
  FocusNode focusNode;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  _newTaskState(this.flutterLocalNotificationsPlugin);

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
    getCurrentUser();
    //TODO begin
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));
    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
    //TODO end
  }

  FirebaseUser loggedInUser;
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String userUid;
  TASK newTask;

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
    }
    userUid = loggedInUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    String task = ' ';
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
                      var id = taskRef.document().documentID;
                      List<int> nums = id.codeUnits;
                      String str = '';
                      for (int i = 0; i <= 3; i++) {
                        str = str + nums[i].toString();
                      }
                      String smallerString = str.substring(0, 6);
                      int replaced = int.parse(smallerString);

                      print(
                          '===========================$replaced========================================');
                      newTask = new TASK(
                          replaced, task, category, color, false, pickedTime);

                      taskRef
                          .document(id)
                          .setData(newTask.toJson())
                          .then((val) {
                        print("document Id ----------------------: $id");
                      }).whenComplete(() {
                        _scheduleNotification(
                            pickedTime, task, category, replaced);
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
    );
  }

  //TODO begin
  Future onSelectNotification(String payload) async =>
      await Navigator.pushNamed(context, home.id);

  Future _scheduleNotification(
      pickedTime, String task, String category, int id) async {
    print('id:::::::::::::::::::::::::::::::::::::::::::::::::::$id');
    var scheduledNotificationDateTime = pickedTime;
//    DateTime.now().add(Duration(seconds: 5));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'app_icon',
        largeIcon: 'app_icon',
        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(id, category, task,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }
//TODO end
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
