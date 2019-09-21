import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:done/screens/login.dart';
import 'package:done/screens/signUp.dart';
import 'package:done/components/roundButton.dart';
import 'package:done/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:done/homePage.dart';

class welcome extends StatefulWidget {
  static const String id = 'welcome';

  @override
  _welcomeState createState() => _welcomeState();
}

class _welcomeState extends State<welcome> with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  var user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    user = await _auth.currentUser();
    if (user != null) {
      Navigator.pushNamed(context, homePage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Hero(
                tag: 'logo',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 70,
                      child: Image.asset(
                        'images/logo.png',
                      ),
                    ),
                    SizedBox(width: 10),
                    TypewriterAnimatedTextKit(
                        onTap: () {
                          print("Tap Event");
                        },
                        text: [
                          "DONE",
                        ],
                        textStyle:
                            TextStyle(fontSize: 45.0, fontFamily: 'Gugi'),
                        textAlign: TextAlign.start,
                        alignment: AlignmentDirectional
                            .topStart // or Alignment.topLeft
                        ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: roundButton('Log In', () {
              Navigator.pushNamed(context, login.id);
            }, kBlueColor, 300),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: roundButton('Sign Up', () {
              Navigator.pushNamed(context, signUp.id);
            }, Colors.blueAccent, 300),
          ),
        ],
      ),
    );
  }
}
