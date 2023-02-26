import 'package:connectswe/ui/auth/login_screen.dart';
import 'package:connectswe/ui/auth/login_screen_main.dart';
import 'package:connectswe/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';

import '../../config/palette.dart';
import '../../post/post_screen.dart';
import '../../utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignupScreenMain extends StatefulWidget {
  const SignupScreenMain({Key? key}) : super(key: key);

  @override
  State<SignupScreenMain> createState() => _SignupScreenMainState();
}

class _SignupScreenMainState extends State<SignupScreenMain> {
  bool obscurePass = true;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void Signup(){
    setState(() {
      loading = true;
      obscurePass = true;
    });


    _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()
    ).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Palette.backgroundColor2,
        /*appBar: AppBar(
          backgroundColor: Colors.black54,
          automaticallyImplyLeading: false,
          centerTitle: true,
          //title: Text('Signup'),
        ),*/
        body: Column(

          children: [

            SizedBox(height: 200,),
            buildSignUpSection(),
            SizedBox(height: 40,),
            SpinKitFoldingCube(
              color: Colors.blueGrey,
              size: 50,

            )
          ],
        ),
    );
  }

Widget buildSignUpSection()
{
  return Positioned(

      top: 150,
      child: Container(

        height: 380 ,
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width-40,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5
              ),
            ]
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [

                      Text(
                        "SIGNUP",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Palette.activeColor
                        ),

                      ),

                      Container(
                        margin: EdgeInsets.only(top:3),
                        height: 2,
                        width: 55,
                        color: Colors.orange,
                      )
                    ],
                  ),

                ],
              ),
              //  if(isSignupScreen) buildSignupSection(),
              //  if(!isSignupScreen) buildSigninSection()

              // build inside loginSection
              Padding(
                // padding: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.only(bottom:8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      //CommunityMaterialIcons.email_outline,
                                      Icons.mail,
                                      color: Palette.iconColor,
                                    ),
                                    hintText: 'Email',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    contentPadding: EdgeInsets.all(8),

                                    hintStyle: TextStyle(
                                      fontSize: 14, color: Palette.textColor1,
                                    )

                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter email';
                                  }
                                  else return null;
                                }


                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                                keyboardType: TextInputType.text,
                                controller: passwordController,
                                obscureText: obscurePass?true:false,
                                decoration:  InputDecoration(
                                    prefixIcon: Icon(
                                      //CommunityMaterialIcons.email_outline,
                                      Icons.lock_open,
                                      color: Palette.iconColor,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          obscurePass = !obscurePass;
                                        });
                                      },
                                      child: Icon(
                                        obscurePass? Icons.visibility: Icons.visibility_off,
                                        color: Palette.iconColor,
                                      ),
                                    ),
                                    hintText: 'Password',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    contentPadding: EdgeInsets.all(8),

                                    hintStyle: TextStyle(
                                      fontSize: 14, color: Palette.textColor1,
                                    )

                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter password';
                                  }
                                  else return null;
                                }


                            ),
                            /*TextFormField(
                                keyboardType: TextInputType.text,
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    hintText: 'Password',
                                    prefixIcon: Icon(Icons.lock_open)
                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter password';
                                  }
                                  else return null;
                                }
                            ),*/
                          ],
                        )
                    ),
                    SizedBox(height: 50,),

                    RoundButton(
                      title: 'Signup',
                      loading: loading,
                      onTap: () {
                        if(_formKey.currentState!.validate())
                        {
                          Signup();
                        }
                      },
                    ),
                    const SizedBox( height: 30,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text("Already have an account?"),
                        TextButton(onPressed: (){
                          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight,
                              duration: Duration(milliseconds: 400),
                              child: LoginScreenMain()));
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreenMain()));
                        },
                            child: Text('Sign in'),

                        )
                      ],
                    )
                  ],
                ),
              ),
              //  buildInsideLoginSection()

            ],
          ),
        ),
      )
  );

}
}
