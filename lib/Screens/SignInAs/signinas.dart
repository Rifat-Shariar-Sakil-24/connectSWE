import 'package:flutter/material.dart';

class SignInAs extends StatelessWidget {
  const SignInAs({Key? key}) : super(key: key);

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

                  onPressed: (){},
                  child: Text('sign in as Teacher'),
                ),
              ),

              ElevatedButton(
                onPressed: (){},
                child: Text('sign in as Student'),
              ),


            ],
          ),
        )

    );
  }
}
