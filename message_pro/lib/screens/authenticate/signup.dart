import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:message_pro/components/account_check.dart';
import 'package:message_pro/components/rounded_button.dart';
import 'package:message_pro/screens/authenticate/components/or_divider.dart';
import 'package:message_pro/screens/authenticate/components/social_icon.dart';
import 'package:message_pro/screens/authenticate/login.dart';
import 'package:message_pro/services/auth.dart';
import 'package:message_pro/shared/constants.dart';
import 'package:message_pro/shared/loading.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String dispName='';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
            height: size.height,
            width: double.infinity,
            // Here i can use size.width but use double.infinity because both work as a same
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   child: Image.asset(
                //     "assets/images/signup_top.png",
                //     width: size.width * 0.35,
                //   ),
                // ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   child: Image.asset(
                //     "assets/images/main_bottom.png",
                //     width: size.width * 0.25,
                //   ),
                // ),
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.05),
                        Text(
                          "SIGNUP",
                          style: TextStyle(
                            letterSpacing: 1.8,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Image.asset(
                          "assets/images/w3.png",
                          height: size.height * 0.33,
                        ),
                        SizedBox(height: size.height * 0.03),
                        Form(
                            key: _formKey,
                            child: Column(children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 1),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor1,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                               child: TextFormField(
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter a Display Name' : null,
                                    cursorColor: kPrimaryColor1,
                                    onChanged: (val) {
                                      setState(() {
                                        dispName = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.visibility,
                                        color: kPrimaryColor1,
                                      ),
                                      hintText: 'Display Name',
                                      border: InputBorder.none,
                                    )
                               ), 
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 1),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor1,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: TextFormField(
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter an email' : null,
                                    cursorColor: kPrimaryColor1,
                                    onChanged: (val) {
                                      setState(() {
                                        email = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.person,
                                        color: kPrimaryColor1,
                                      ),
                                      hintText: 'Your Email',
                                      border: InputBorder.none,
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 1),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor1,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: TextFormField(
                                    obscureText: true,
                                    cursorColor: kPrimaryColor1,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    validator: (val) => val.length < 6
                                        ? 'Enter a password 6+ chars long'
                                        : null,
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.lock,
                                        color: kPrimaryColor1,
                                      ),
                                      hintText: 'Password',
                                      // suffixIcon: Icon(
                                      //   Icons.visibility,
                                      //   color: kPrimaryColor,
                                      // ),
                                      border: InputBorder.none,
                                    )),
                              ),
                            ])),
                        // RoundedInputField(
                        //   hintText: "Your Email",
                        //   onChanged: (value) {},
                        // ),
                        // RoundedPasswordField(
                        //   onChanged: (value) {},
                        // ),
                        RoundedButton(
                          text: "SIGNUP",
                          color: kSecondaryColor1,
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth
                                  .registerWithEmailAndPassword(dispName,email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Please supply a Valid Email';
                                  loading = false;
                                });
                              } else {
                                //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Wrapper()));
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        AlreadyHaveAnAccountCheck(
                          login: false,
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
                        OrDivider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SocialIcon(
                              iconSrc: "assets/icons/facebook.svg",
                              press: () {},
                            ),
                            SocialIcon(
                              iconSrc: "assets/icons/twitter.svg",
                              press: () {},
                            ),
                            SocialIcon(
                              iconSrc: "assets/icons/google-plus.svg",
                              press: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
  }
}
