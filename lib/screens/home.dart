import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:done/components/taskCard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';

class home extends StatefulWidget {
  static const String id = 'home';
  @override
  _homeState createState() => _homeState();
}

bool _loading = false;
String userUid;
bool isDataLoaded = false;
final _fireStore = Firestore.instance;
final _auth = FirebaseAuth.instance;
final CollectionReference taskRef =
    _fireStore.document('Userss').collection('$userUid/Tasks');

FirebaseUser loggedInUser;
List<Container> messageWidgets = [];

class _homeState extends State<home> {
  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
      userUid = loggedInUser.uid;
    }
  }

  @override
  void initState() {
//    _loading = true;
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset('images/topBarBackground.png',
                    width: double.infinity, fit: BoxFit.fill),
              ),
              Container(
                  height: MediaQuery.of(context).size.height - 250,
                  child: Column(
                    children: <Widget>[
                      MessagesStream(),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .document('Userss')
          .collection('$userUid/Tasks')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data.documents;
        List<taskCard> messageBubbles = [];
        for (var message in messages) {
          final task = message.data['Task'];
          final category = message.data['Category'];
          final color = message.data['Color'];
          final selectedTime = message.data['SelectedTime'];
          final taskHour = DateFormat("HH:mm").format(selectedTime.toDate());
          final taskStatus = message.data['Status'];
          final alarmId = message.data['AlarmId'];
          final newTaskCard = taskCard(alarmId, message.documentID, task,
              category, color, taskHour, taskStatus);
          messageBubbles.add(newTaskCard);
        }
        return Expanded(
          child: messageBubbles.length == 0
              ? noTask()
              : ListView(
                  reverse: false,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                  children: messageBubbles,
                ),
        );
      },
    );
  }
}

Widget noTask() {
  return Center(
    child: Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 150),
          Image.asset(
            'images/noTaskIcon.png',
            height: 180,
          ),
          SizedBox(height: 70),
          Text(
            'No tasks',
            style: TextStyle(
                color: Color(0xFF554E8F),
                fontSize: 28,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 11),
          Text(
            'You have no task to do',
            style: TextStyle(color: Color(0xFF82A0B7), fontSize: 23),
          ),
        ],
      ),
    ),
  );
}
