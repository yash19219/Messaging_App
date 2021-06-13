import 'package:flutter/material.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/screens/authenticate/welcome.dart';
import 'package:message_pro/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<Users>(context);
    print('in wrapper');
    if(user==null){
      return WelcomeScreen();
    }
    else{
      return HomeScreen();
    }
    
  }
}