import 'dart:async';

import 'package:connectswe/config/palette.dart';
import 'package:connectswe/firebase_services/splash_services.dart';
import 'package:connectswe/ui/auth/login_screen_main.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

class SplashScreenMain2 extends StatefulWidget {

  const SplashScreenMain2({Key? key}) : super(key: key);


  @override
  State<SplashScreenMain2> createState() => _SplashScreenMain2State();
}

class _SplashScreenMain2State extends State<SplashScreenMain2> {

  SplashServices splashServices = SplashServices();
  @override

  void initState() {
    // TODO: implement initState
    splashServices.isLogin(context);
    super.initState();

    Timer( Duration(seconds: 7), () =>
    {



    }
    );



  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Stack(
            children: [
              // Lottie.asset("assets/splash/splash2.json"),
              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Palette.activeColor
                      )

                  ),
                  SpinKitFoldingCube(
                    color: Palette.backgroundColor2,
                    size: 75.0,

                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
