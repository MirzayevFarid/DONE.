import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/newTask.dart';
import 'screens/home.dart';
import 'package:done/screens/tasks.dart';

class homePage extends StatefulWidget {
  static const String id = 'homePage';

  @override
  homePageState createState() => homePageState();
}

class homePageState extends State<homePage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  final _pages = [
    home(),
    tasks(),
    newTask(),
  ];

  int currentIndex = 0;
  int cIndex = 0;

  void incrementTab(index) {
    setState(() {
      currentIndex = index;
      cIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: cIndex == 0 ? Colors.blue : Colors.grey,
              ),
              title: new Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
                color: cIndex == 1 ? Colors.blue : Colors.grey,
              ),
              title: new Text('TASKS')),
        ],
        onTap: (index) {
          incrementTab(index);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
          shape: StadiumBorder(),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 50,
          ),
          onPressed: () {
            setState(() {
              cIndex = 2;
            });
          }),
      body: _pages[cIndex],
    );
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
    }
  }
}
