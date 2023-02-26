import 'dart:async';

import 'package:connectswe/config/palette.dart';
import 'package:connectswe/firebase_services/splash_services.dart';
import 'package:connectswe/ui/auth/login_screen_main.dart';
import 'package:connectswe/ui/auth/splash_screen_main_2.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

import '../post/post_screen.dart';

class SplashScreenMain extends StatefulWidget {

  const SplashScreenMain({Key? key}) : super(key: key);


  @override
  State<SplashScreenMain> createState() => _SplashScreenMainState();
}

class _SplashScreenMainState extends State<SplashScreenMain> {

  SplashServices splashServices = SplashServices();
  @override

  void initState() {
    // TODO: implement initState
    splashServices.isLogin(context);
    super.initState();





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
