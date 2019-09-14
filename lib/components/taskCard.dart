import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:done/screens/home.dart';
//import 'package:marquee/marquee.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:done/screens/newTask.dart';

class taskCard extends StatelessWidget {
  String task;
  String category;
  int color;
  bool status;
  final date;
  String id;
  int alarmId;
  taskCard(this.alarmId, this.id, this.task, this.category, this.color,
      this.date, this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF9FCFF),
      child: Container(
        height: 50,
        margin: EdgeInsets.all(20),
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
        child: Row(
          children: <Widget>[
            Container(
//              margin: EdgeInsets.only(left: 0.3),
              decoration: BoxDecoration(
                  color: Color(color),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              width: 10,
            ),
            SizedBox(
              width: 5,
            ),
            Checkbox(
//              activeColor: Colors.grey,
              value: status,
              onChanged: (bool val) async {
                _updateStatus(val, id);
                if (val == true) {
                  await newTask.flutterLocalNotificationsPlugin.cancel(alarmId);
                }
              },
            ),
            SizedBox(
              width: 10,
            ),
            Text(date),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Container(
                width: 190,
                child: Marquee(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    task,
                    style: TextStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.add_alert,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}

final db = Firestore.instance;
_updateStatus(bool status, String id) async {
  await db
      .document('Userss')
      .collection('$userUid/Tasks')
      .document(id)
      .updateData({'Status': status});
}
