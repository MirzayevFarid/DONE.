import 'package:flutter/material.dart';

const kHeaderTextStyle = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.bold,
);
const kBodyTextStyle = TextStyle(fontSize: 20);

const kBlueColor = Color(0xFF3AD9F2);

const kInputDecoration = InputDecoration(
  hintText: 'Enter Email Adress',
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
    borderRadius: BorderRadius.all(
      Radius.circular(32),
    ),
  ),
);
