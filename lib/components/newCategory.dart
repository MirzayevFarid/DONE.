import 'package:flutter/material.dart';

class newCategory extends StatelessWidget {
  String text;
  Color dotColor;
  Function onTap;

  newCategory(
    this.text,
    this.dotColor,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.fiber_manual_record,
                color: dotColor,
                size: 17,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
