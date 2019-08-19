import 'package:flutter/material.dart';
import 'package:done/screens/welcome.dart';
import 'package:done/screens/login.dart';
import 'package:done/screens/signUp.dart';
import 'package:done/homePage.dart';
import 'screens/splashScreen.dart';
import 'screens/newTask.dart';
import 'screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
//      theme: ThemeData.dark(),
      initialRoute: welcome.id,
      routes: {
        welcome.id: (context) => welcome(),
        login.id: (context) => login(),
        signUp.id: (context) => signUp(),
        homePage.id: (context) => homePage(),
        splashScreen.id: (context) => splashScreen(),
        home.id: (context) => home(),
      },
    );
  }
}
