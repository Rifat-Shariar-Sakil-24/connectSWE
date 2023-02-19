import 'package:connectswe/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:connectswe/config/community_material_icon.dart';
import 'package:flutter/rendering.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isMale = true;
  bool isSignupScreen = true;
  bool isRememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(

        children: [

          addImageInBackground(),// add image in background
          buildBottomHalfContainer(true), // trick to add shadow
          buildSigninSignup(),// log in sign up build
          buildBottomHalfContainer(false),// click to submit

        ],

      ),
    );
  }








  Widget addImageInBackground()
  {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,

      child: Container(

        height: 300,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background2.jpg"),
              fit: BoxFit.fill,
            )
        ),
        child: Container(
          padding: EdgeInsets.only(top: 90, left: 20),
          color: Color(0xFF3b5999).withOpacity(.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    text: "Welcome to",
                    style: TextStyle(
                        fontSize: 25,
                        letterSpacing: 1,
                        color: Colors.yellow[700]
                    ),
                    children: [
                      TextSpan(
                        text: "  connectSWE",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[700]
                        ),)
                    ]
                ),
              ),
              SizedBox(height: 5,),
              Text(
                isSignupScreen?
                "Signup to Continue" : "Signin continue",
                style: TextStyle(
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              )
            ],
          ),

        ),
      ),
    );
  }




  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
          curve: Curves.bounceInOut,
          top: isSignupScreen? 535 : 430,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                height: 90,
                width: 90,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      if(showShadow)
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 1.5,
                        blurRadius: 10,
                        offset: Offset(0,1)
                    )
                    ]
                ),
                child: !showShadow?  Container(

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange,Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                    ),
                    borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0,1)
                      )
                      ]

                  ),
                  child: Icon(
                    Icons.arrow_forward,color: Colors.white,
                  ),
                ) : Center(),
              ),
            )
        );
  }



  Widget buildSigninSignup()
  {
    return AnimatedPositioned(
        duration: Duration(milliseconds: 700),
        curve: Curves.bounceInOut,
        top: isSignupScreen?200:230,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 700),

          curve: Curves.bounceInOut,
          height: isSignupScreen? 380: 250 ,
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width-40,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
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
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isSignupScreen = false;
                        });

                      },
                      child: Column(
                        children: [
                          Text(
                            "LOGIN",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSignupScreen? Palette.textColor1 : Palette.activeColor
                            ),

                          ),
                          if(isSignupScreen==false)
                            Container(
                              margin: EdgeInsets.only(top:3),
                              height: 2,
                              width: 55,
                              color: Colors.orange,
                            )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isSignupScreen = true;

                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            "SIGNUP",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSignupScreen? Palette.activeColor : Palette.textColor1
                            ),

                          ),
                          if(isSignupScreen)
                            Container(
                              margin: EdgeInsets.only(top:3),
                              height: 2,
                              width: 55,
                              color: Colors.orange,
                            )
                        ],
                      ),
                    )
                  ],
                ),
                if(isSignupScreen) buildSignupSection(),
                if(!isSignupScreen) buildSigninSection()


              ],
            ),
          ),
        )
    );
  }





  Widget buildTextField(IconData icon, String hinttext, bool isPassword, bool isEmail) {
    return Padding(

      padding: const EdgeInsets.only(bottom:8.0),
      child: TextField(
                            obscureText: isPassword,
                            keyboardType: isEmail? TextInputType.emailAddress : TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                  //CommunityMaterialIcons.email_outline,
                                      icon,
                                color: Palette.iconColor,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Palette.textColor1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(35.0)),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Palette.textColor1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(35.0)),
                              ),
                              contentPadding: EdgeInsets.all(10),
                              hintText: hinttext,
                              hintStyle: TextStyle(
                                fontSize: 14, color: Palette.textColor1,
                              )
                            ),
                          ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top:20) ,
      child: Column(
        children: [
          buildTextField(Icons.account_box_outlined,"User Name", false, false),
          buildTextField(Icons.mail,"Email", false, true),
          buildTextField(Icons.password,"Password", true, false),

          Padding(
            padding: const EdgeInsets.only(top:10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        width: 30,height: 30,
                        decoration: BoxDecoration(
                          color: isMale? Palette.textColor2: Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color: isMale? Colors.transparent: Palette.textColor1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.account_box_outlined,
                          color: isMale? Colors.white: Palette.iconColor,
                        ),
                      ),
                      Text("Male",style: TextStyle(
                        color: Palette.textColor1,
                      ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 30,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isMale = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        width: 30,height: 30,
                        decoration: BoxDecoration(
                          color: isMale? Colors.transparent: Palette.textColor2,
                          border: Border.all(
                            width: 1,
                            color: isMale? Palette.textColor1 : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.account_box_outlined,
                          color: isMale? Palette.iconColor: Colors.white,
                        ),
                      ),
                      Text("Female",style: TextStyle(
                        color: Palette.textColor1,
                      ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(top:20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "By pressing 'Submit' you agree to our ",
                  style: TextStyle(color: Palette.textColor2),
                  children: [
                    TextSpan(
                      //recognizer: ,
                      text: "term & conditions",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(Icons.mail, "info@demouri.com", false, true),
          buildTextField(Icons.password, "**********", true, false),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Checkbox(
                    value: isRememberMe,
                    activeColor: Palette.textColor2,
                    onChanged: (value){
                      setState(() {
                        isRememberMe = !isRememberMe;
                      });
                    }
                ),
                Text(
                    "Remember me",
                    style: TextStyle(
                      fontSize: 12,
                      color: Palette.textColor1,
                    )
                ),

              ],),
              TextButton(
                onPressed: (){},
                child: Text("Forgot Password",
                  style: TextStyle(
                    fontSize: 12, color: Palette.textColor1,
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }


}
