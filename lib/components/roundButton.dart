import 'package:flutter/material.dart';

class roundButton extends StatelessWidget {
  final Color color;
  final String label;
  final Function onPressed;
  final double size;

  roundButton(this.label, this.onPressed, this.color, this.size);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: color,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: size,
        height: 42,
        child: Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
