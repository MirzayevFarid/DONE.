import 'package:flutter/material.dart';
import 'package:done/constants.dart';
import 'package:done/components/roundButton.dart';
import 'package:done/homePage.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class splashScreen extends StatefulWidget {
  static const String id = 'splashScreen';
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData.dark().copyWith(backgroundColor: Colors.red);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
            'images/Splash_Icon.png',
            height: 270,
          ),
          Text(
            'Welcome',
            style: kHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'You\'re going to do great things with DONE! Click to Get Started to explore the app :)',
              style: TextStyle(fontSize: 20, wordSpacing: 1.2),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 60, right: 60),
            child: GradientButton(
              shapeRadius: BorderRadius.circular(30),
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 20),
              ),
              callback: () {
                Navigator.pushNamed(context, homePage.id);
              },
              increaseWidthBy: 220,
              increaseHeightBy: 20,
              gradient: Gradients.coldLinear,
              shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.50),
            ),
          ),
        ],
      ),
    );
  }
}
