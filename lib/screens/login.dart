import 'package:flutter/material.dart';
import 'package:done/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:done/homePage.dart';
import 'package:done/components/inputField.dart';
import 'package:done/components/roundButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:done/screens/splashScreen.dart';

class login extends StatefulWidget {
  static const String id = 'login';

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedUser;
  String email;
  String password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
          backgroundColor: Color(0xFF303030),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 200,
                        child: Image.asset(
                          'images/logo.png',
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Center(
                        child: Text(
                          'Log in to your account',
                          style: kBodyTextStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50, left: 60, right: 60),
                      child: inputField(
                          TextInputAction.next,
                          TextInputType.emailAddress,
                          'Enter Email Adress',
                          false, (value) {
                        email = value;
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 60, right: 60),
                      child: inputField(
                          TextInputAction.next,
                          TextInputType.multiline,
                          'Enter Password',
                          true, (value) {
                        password = value;
                      }),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 60, right: 60),
                  child: roundButton('Log In', () async {
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      Navigator.pushNamed(context, splashScreen.id);
                      setState(() {
                        _saving = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                      _saving = true;
                    });
                  }, kBlueColor, 150),
                ),
              ],
            ),
          ),
        ));
  }
}
