import 'package:flutter/material.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/screens/wrapper.dart';
import 'package:message_pro/services/auth.dart';
import 'package:message_pro/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'Freedom App',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
