import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:done/components/taskCard.dart';
import 'package:easy_listview/easy_listview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class home extends StatefulWidget {
  static const String id = 'home';
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  bool _loading = false;
  String userUid;

  FirebaseUser loggedInUser;
  final _fireStore = Firestore.instance;

  final _auth = FirebaseAuth.instance;
  List<Container> messageWidgets = [];

  Future getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
      userUid = loggedInUser.uid;
    }
  }

  getTasks() {
    return _fireStore
        .document('Userss')
        .collection('$userUid/Tasks')
        .getDocuments();
  }

  bool isDataLoaded = false;
  var tasks;

  @override
  void initState() {
//    _loading = true;
    getCurrentUser().whenComplete(() {
      getTasks().then((QuerySnapshot docs) {
        if (docs.documents.isNotEmpty) {
          setState(() {
            isDataLoaded = true;
            for (var taskName in docs.documents) {
              final taskLabel = taskName.data['Task'];
              final taskCategory = taskName.data['Category'];
              final color = taskName.data['Color'];
              final messageWidget = new Container(
                child: taskCard(taskLabel, taskCategory, color),
              );
              messageWidgets.add(messageWidget);
            }
          });
        }
        if (isDataLoaded == true) {
          setState(() {
            _loading = false;
          });
        }
        if (messageWidgets.length == 0) {
          setState(() {
            _loading = false;
          });
        }
      });
    });
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
                child: isDataLoaded
                    ? Container(
                        // TODO : Solve Height Problem
                        height: MediaQuery.of(context).size.height - 220,
                        child: EasyListView(
                            itemCount: messageWidgets.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Column(
                                  children: <Widget>[messageWidgets[index]],
                                ),
                              );
                            }))
                    : Container(
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
                              style: TextStyle(
                                  color: Color(0xFF82A0B7), fontSize: 23),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/**
 *
 *
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
