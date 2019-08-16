import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class home extends StatefulWidget {
  static const String id = 'home';
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  Future _data;
  FirebaseUser loggedInUser;
  final _fireStore = Firestore.instance;
  String userUid;

  final _auth = FirebaseAuth.instance;
  List<Container> messageWidgets = [];

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
      userUid = loggedInUser.uid;
    }
  }

  Future getTasks() async {
    QuerySnapshot qn = await _fireStore
        .document('Userss')
        .collection('$userUid/Tasks')
        .getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    build(context);
  }

  Container bbuild() {
    StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .document('Userss')
            .collection('$userUid/Tasks')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data.documents;
            for (var message in messages) {
              final messageText = message.data['Task'];
              final messageCategory = message.data['Category'];

              //TODO
              final messageWidget = Container(
                color: Colors.black12,
                child: Text(messageText),
              );
              messageWidgets.add(messageWidget);
            }
            return SingleChildScrollView(
              child: Column(
                children: messageWidgets,
              ),
            );
          } else {
            return Column(
              children: <Widget>[Text('NO DATA')],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .document('Userss')
                .collection('$userUid/Tasks')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text('Loading...');
              return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text('hi'),
                  subtitle: new Text(document['Task']),
                );
              }).toList());
            }),
      ),
    );
  }
}
/*



* Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset('images/topBarBackground.png',
                  width: double.infinity, fit: BoxFit.fill),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 150),
                  Image.asset(
                    'images/noTaskIcon.png',
                    height: 180,
                  ),
                  SizedBox(height: 70),
                  Text(
                    'HOME   No tasks',
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
          ],
        ),
 */

/**
 * StreamBuilder<QuerySnapshot>(
    stream: _fireStore
    .document('Userss')
    .collection('$userUid/Tasks')
    .snapshots(),
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    final messages = snapshot.data.documents;
    for (var message in messages) {
    final messageText = message.data['Task'];
    final messageCategory = message.data['Category'];

    //TODO
    final messageWidget = Container(
    color: Colors.black12,
    child: Text(messageText),
    );
    messageWidgets.add(messageWidget);
    }
    return SingleChildScrollView(
    child: Column(
    children: messageWidgets,
    ),
    );
    } else {
    return Column(
    children: <Widget>[Text('NO DATA')],
    );
    }
    }),
 */
