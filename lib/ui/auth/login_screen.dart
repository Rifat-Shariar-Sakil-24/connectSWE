import 'package:connectswe/post/post_screen.dart';
import 'package:connectswe/ui/auth/signup_screen.dart';
import 'package:connectswe/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
        email: emailController.text.toString(), password: passwordController.text.toString()).then((value) {
          Utils().toastMessage(value.user!.email.toString());
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
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.alternate_email)
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
                      ),
                    ],
                  )
              ),
                 SizedBox(height: 50,),

                 RoundButton(
                   title: 'Login',
                   loading: loading,
                   onTap: () {
                     if(_formKey.currentState!.validate())
                       {
                         login();
                       }
                   },
                 ),
                 const SizedBox( height: 30,),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text("Don't have an account?"),
                     TextButton(onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                     },
                         child: Text('Sign up')
                     )
                   ],
                 )
            ],
          ),
        ),
      ),
    );
  }
}
