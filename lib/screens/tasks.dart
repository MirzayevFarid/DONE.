import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:done/screens/home.dart';
class tasks extends StatefulWidget {
  @override
  _tasksState createState() => _tasksState();
}

class _tasksState extends State<tasks> {
  final _fireStore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: devHeight / 2 * 0.3,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.blueAccent, blurRadius: 10),
              ],
              color: Colors.amber,
              image: DecorationImage(
                  image: AssetImage('images/topBarBackground.png'),
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: devHeight / 2 * 0.3),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    reverse: false,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomCenter,
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
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  //TODO: EDIT HERE TO GET CATEGORIES FROM FIRESTORE
  void getCategories(){
    var userUid = homeState().getUserId;

    StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .document('Userss')
          .collection('$userUid/Tasks')
          .orderBy('SelectedTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data.documents;
        List<Container> messageBubbles = [];
        for (var message in messages) {
          final category = message.data['Category'];
          final color = message.data['Color'];
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
