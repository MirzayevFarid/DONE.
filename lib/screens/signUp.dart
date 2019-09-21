import 'package:flutter/material.dart';
import 'package:done/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:done/homePage.dart';
import 'package:done/components/roundButton.dart';
import 'package:done/components/inputField.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:done/screens/splashScreen.dart';

class signUp extends StatefulWidget {
  static const String id = 'signUp';
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
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
                          'Create your account',
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
                  child: roundButton('Sign Up', () async {
                    setState(() {
                      _saving = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, splashScreen.id);
                      }

                      setState(() {
                        _saving = true;
                      });
                    } catch (e) {
                      print(e);
                    }
                  }, Colors.blueAccent, 150),
                ),
              ],
            ),
          ),
        ));
  }
}
