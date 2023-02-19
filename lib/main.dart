import 'package:connectswe/screen/login_signup.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(LoginSignupUI());
}

class LoginSignupUI extends StatelessWidget {
  // const LoginSignupUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Signup UI",
      home: LoginSignupScreen(),
    );
  }
}