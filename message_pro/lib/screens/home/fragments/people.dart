import 'package:flutter/material.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/screens/home/account_list.dart';
import 'package:message_pro/services/database.dart';
import 'package:message_pro/shared/constants.dart';
import 'package:message_pro/shared/loading.dart';
import 'package:provider/provider.dart';

class People extends StatefulWidget {
  final UserData userData;
  People({this.userData});
  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<Users>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData=snapshot.data;
        return Container(
          child: Column(
            children:<Widget>[
              Container(
              margin: EdgeInsets.symmetric(vertical: 15,horizontal: 7),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
              width: size.width * 0.95,
              decoration: BoxDecoration(
                color: kPrimaryLightColor1,
                borderRadius: BorderRadius.circular(29),
              ),
              child: TextFormField(
                  //validator: (val) => val.isEmpty ? 'Enter a Display Name' : null,
                  cursorColor: kPrimaryColor,
                  onChanged: (val) {
              
                  },
                  decoration: InputDecoration(
                    hintText: 'Search User',
                    suffixIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor1,
                    ),
                    border: InputBorder.none,
                  )),
            ),
            SizedBox(height: 10.0),
            Expanded(child: AccountList(userData: userData,)),
            ]
          ),
          
        );
        }
        else{
          return Loading();
        }
      }
    );
  }
}
