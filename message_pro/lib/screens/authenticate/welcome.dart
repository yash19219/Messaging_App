import 'package:flutter/material.dart';
import 'package:message_pro/components/rounded_button.dart';
import 'package:message_pro/screens/authenticate/login.dart';
import 'package:message_pro/screens/authenticate/signup.dart';
import '../../shared/constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   child: Image.asset(
              //     "assets/images/main_top.png",
              //     width: size.width * 0.3,
              //   ),
              // ),
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   child: Image.asset("assets/images/main_bottom.png",
              //       width: size.width * 0.2),
              // ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Freedom Messaging App ",
                      style: TextStyle(
                        letterSpacing: 2.2,
                        fontSize: 27.0,
                        fontFamily: 'Lobster',
                        fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.03),
                    // CircleAvatar(
                    //   backgroundColor: Colors.white,
                    //   radius: 70.0,
                    //   backgroundImage: AssetImage('assets/images/RSKC_logo.png'),
                    //   ),
                    
                    
                    Center(
                      child: Image.asset(
                        "assets/images/w1.png",
                        height: size.height * 0.40,
                      ),
                    ),
                    // Image.asset(
                    //   "assets/images/welcomePic2.png",
                    //    height: size.height * 0.369,
                    //    )
                    
                    SizedBox(height: size.height * 0.05),
                    RoundedButton(
                      text: "LOGIN",
                      color: kPrimaryColor1,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      },
                    ),
                    RoundedButton(
                      text: "SIGN UP",
                      color: kSecondaryColor1,
                      textColor: Colors.black,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignupScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
