import 'package:done/screens/Categories.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/newTask.dart';

class homePage extends StatefulWidget {
  static const String id = 'homePage';
  @override
  homePageState createState() => homePageState();
}

class homePageState extends State<homePage> {
  final _pages = [
    home(),
    Categories(),
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
              title: new Text('Categories')),
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
}
