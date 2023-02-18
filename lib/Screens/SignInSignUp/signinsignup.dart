
import 'package:flutter/material.dart';

import '../SignInAs/signinas.dart';
import '../SignUpAs/signupas.dart';

class SignInSignUp extends StatelessWidget {
  //const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: Text('connectSWE'),
          centerTitle: true ,
          backgroundColor: Colors.grey[850],
        ),

        body: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [



              Container(
                //  padding: EdgeInsets.all(100),
                //margin: EdgeInsets.only,

                child: ElevatedButton(

                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInAs()));
                  },
                  child: Text('sign in'),
                ),
              ),

              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpAs()));
                },
                child: Text('sign up'),
              ),


            ],
          ),
        )

    );
  }
}
