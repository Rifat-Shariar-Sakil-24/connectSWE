import 'package:connectswe/screen/login_signup.dart';
import 'package:connectswe/ui/splash_screen.dart';
import 'package:connectswe/ui/splash_screen_main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simple_animations/simple_animations.dart';




import 'package:flutter/animation.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const LoginSignupUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Splash Screen",
      home: SplashScreenMain(),

    );
  }
}