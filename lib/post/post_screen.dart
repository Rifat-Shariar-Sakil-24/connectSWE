import 'package:connectswe/ui/auth/login_screen.dart';
import 'package:connectswe/ui/auth/login_screen_main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PostScreen'),
        actions: [
          IconButton(onPressed: (){
                auth.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreenMain()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
          }, icon: Icon(
            Icons.logout_outlined
          ),
          ),
          SizedBox(width: 20,)
        ],
      ),
    );
  }
}
