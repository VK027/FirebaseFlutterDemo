import 'package:ffd/screens/home_page.dart';
import 'package:ffd/screens/login.dart';
import 'package:ffd/screens/splash_screen.dart';
import 'package:flutter/material.dart';

const String appTitle = 'Flutter Firebase Demo';
const String login = "login";
const String home = "home";
const String splash = '/';

class Routes {
  static var routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => Login(),
    home: (BuildContext context) => HomePage(),
  };

  static void callForward(BuildContext context, String className) {
    Navigator.pushNamed(context, className);
  }

  static void callBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void callPushReplacement(BuildContext context, String className) {
    Navigator.pushReplacementNamed(context, className);
  }
}
