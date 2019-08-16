import 'package:flutter/material.dart';

class tasks extends StatefulWidget {
  @override
  _tasksState createState() => _tasksState();
}

class _tasksState extends State<tasks> {
  @override
  Widget build(BuildContext context) {
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
              child: Column(
                children: <Widget>[
                  SizedBox(height: 150),
                  Image.asset(
                    'images/noTaskIcon.png',
                    height: 180,
                  ),
                  SizedBox(height: 70),
                  Text(
                    'TASKS   No tasks',
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
      ],
    );
  }
}
