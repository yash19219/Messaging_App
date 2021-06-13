import 'package:flutter/material.dart';
import 'package:message_pro/components/account_check.dart';
import 'package:message_pro/components/rounded_button.dart';
import 'package:message_pro/screens/authenticate/signup.dart';
import 'package:message_pro/services/auth.dart';
import 'package:message_pro/shared/constants.dart';
import 'package:message_pro/shared/loading.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String email = '';
  String password = '';
  String error = '';
  bool visible=false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
            width: double.infinity,
            height: size.height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   child: Image.asset(
                //     "assets/images/main_top.png",
                //     width: size.width * 0.35,
                //   ),
                // ),
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: Image.asset(
                //     "assets/images/login_bottom.png",
                //     width: size.width * 0.4,
                //   ),
                // ),
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "LOGIN",
                          style: TextStyle(
                            letterSpacing: 1.8,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Image.asset(
                          "assets/images/w4.png",
                          height: size.height * 0.35,
                        ),
                        SizedBox(height: size.height * 0.03),
                        Form(
                            key: _formKey,
                            child: Column(children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor1,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: TextFormField(
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter an email' : null,
                                    cursorColor: kPrimaryColor,
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
                                    horizontal: 20, vertical: 5),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor1,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: TextFormField(
                                    obscureText: !visible,
                                    cursorColor: kPrimaryColor1,
                                    validator: (val) => val.length < 6
                                        ? 'Enter a password 6+ chars long'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.lock,
                                        color: kPrimaryColor1,
                                      ),
                                      hintText: 'Password',
                                      suffixIcon: Container(
                                        width: size.width*0.01,
                                        child: FlatButton.icon(
                                          padding: EdgeInsets.zero,
                                          onPressed: (){
                                            setState(() {
                                              visible=!visible;                              
                                            });
                                          },
                                          label: Text(''),
                                          icon: Icon(Icons.visibility,color: kPrimaryColor1,),
                                          color: kPrimaryLightColor1,
                                        ),
                                      ),
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
                          text: "LOGIN",
                          color: kSecondaryColor1,
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              print(result);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not Sign in with those Credentials!!';
                                  loading=false;
                                });
                              }
                              else{
                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Wrapper()));
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                        SizedBox(height: size.height * 0.03),
                        AlreadyHaveAnAccountCheck(
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
                        SizedBox(height: size.height * 0.03),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
  }
}
