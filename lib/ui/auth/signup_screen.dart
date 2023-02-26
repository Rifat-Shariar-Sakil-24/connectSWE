import 'package:connectswe/ui/auth/login_screen.dart';
import 'package:connectswe/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/utils.dart';
import 'login_screen_main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Signup'),
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
              loading: loading,
              title: 'Signup',
              onTap: () {
                if(_formKey.currentState!.validate())
                {
                  setState(() {
                    loading = true;
                  });
                     _auth.createUserWithEmailAndPassword(
                         email: emailController.text.toString(),
                         password: passwordController.text.toString()
                     ).then((value) {
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
              },
            ),
            const SizedBox( height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreenMain()));
                },
                    child: Text('Sign in')
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
