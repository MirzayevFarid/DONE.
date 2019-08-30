import 'package:flutter/material.dart';

class taskCard extends StatelessWidget {
  String task;
  String category;
  int color;
  bool checked = true;
  taskCard(this.task, this.category, this.color);

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
              width: 20,
            ),
            Checkbox(
              //TODO: ADD VALUE TO FIRESTORE
//              activeColor: Colors.grey,
              value: checked,
              onChanged: (bool val) {},
            ),
            SizedBox(
              width: 20,
            ),
            Text('07:00 AM '),
            Text(task),
          ],
        ),
      ),
    );
  }
}
