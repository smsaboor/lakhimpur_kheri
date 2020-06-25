import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:lakhimpur_kheri/route.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/MultiTheme/Model/theme_model.dart';
import 'package:lakhimpur_kheri/screens/HomePageFinall/drawer/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScr extends StatefulWidget {
  ThemeModel model;
  SplashScr(this.model);
  @override
  State<StatefulWidget> createState() {
    return  _SplashScrState(this.model);
  }
}
class _SplashScrState extends State<SplashScr> {
  SharedPreferences prefs;
  ThemeModel model;
  _SplashScrState(this.model);

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => RoutePage(model,prefs:prefs)));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroPage(model,prefs:prefs)));
    }
  }

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (){
      checkFirstSeen();
    });
  }
  // added test yourself
  // and made the text to align at center
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          backgroundColor: Colors.indigo,
          body: Center(
            child: Text(
              "Explore\nCity\nat Home !!",
              style: TextStyle(
                fontSize: 50.0,
                color: Colors.white,
                fontFamily: "Satisfy",
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
  }
}