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
  final user = FirebaseAuth.instance.currentUser;



  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = this.user;
     String gg="";
    if (user != null) {
      // Name, email address, and profile photo URL
      gg += user.email.toString();


    }
    String email1 = gg;
    String email2 = "xyz@student.sust.edu";
      RegExp domainRegex = RegExp(r"@(.*$)");
      String? domain1 = domainRegex.firstMatch(email1)?.group(1);
      String? domain2 = domainRegex.firstMatch(email2)?.group(1);

      if (domain1 != null && domain2 != null) {
        if(domain1==domain2) gg+= " 1";
        else gg+= " 0";
      } else {
        gg += " 0";
      }

    return Scaffold(
      appBar: AppBar(

        title: Text(gg),
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
