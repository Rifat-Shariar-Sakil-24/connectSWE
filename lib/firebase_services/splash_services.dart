
import 'dart:async';

import 'package:connectswe/post/post_screen.dart';
import 'package:connectswe/post/post_screen2.dart';
import 'package:connectswe/post/post_screen3.dart';
import 'package:connectswe/screen/login_signup.dart';
import 'package:connectswe/ui/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ui/auth/login_screen_main.dart';


import 'package:connectivity/connectivity.dart';

class SplashServices{

  Future<void> isLogin(BuildContext context) async {

    bool ActiveConnection = false;
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) ActiveConnection = true;

    bool timeOverflow = false;
    //






    if(user!=null)
      {
        Timer( Duration(seconds: 7), () =>
        {

        Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen2()))

        }
        );



      }
    else
      {


        Timer( Duration(seconds: 7), () =>
        {


        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreenMain()))
        }
        );


      }


  }



}