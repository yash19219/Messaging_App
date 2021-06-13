import 'package:flutter/material.dart';
import 'package:message_pro/models/account.dart';
import 'package:message_pro/models/friends.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/screens/home/fragments/chats.dart';
import 'package:message_pro/screens/home/fragments/people.dart';
import 'package:message_pro/screens/home/fragments/profile.dart';
import 'package:message_pro/services/auth.dart';
import 'package:message_pro/services/database.dart';
import 'package:message_pro/shared/constants.dart';
import 'package:message_pro/shared/loading.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    final AuthService _auth= AuthService();
    int _currentIndex=0;
    final List<Widget> _children=[Chats(),People(),Profile()];

    void onTabTapped(int index){
      setState(() {
        _currentIndex=index;
      });
    }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return StreamProvider<List<Account>>.value(

      initialData: null,
      value: DatabaseService().accounts,
          child: StreamProvider<List<Friend>>.value(
            initialData: null,
            value: DatabaseService(uid: user.uid).friends,
                      child: StreamBuilder<UserData>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  UserData userData=snapshot.data;
                return Scaffold(
        appBar: AppBar(
                backgroundColor: kPrimaryColor1,
                title: Text(
                  'Freedom App',
                  style: TextStyle(
                    fontSize: 27,
                    letterSpacing: 2,
                    fontFamily: 'Lobster',
                  ),
                  
                  ),
                elevation: 0.0,
                actions: <Widget>[
                  FlatButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                    }, 
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: Text(''), 
                    )
                ],
        ),
        body: _currentIndex==0?Chats(userdata: userData):(_currentIndex==1?People():Profile()),
        bottomNavigationBar: BottomNavigationBar(
                onTap: onTabTapped,
                currentIndex: _currentIndex,
                backgroundColor: Colors.white,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon:Icon(
                      Icons.chat_sharp,
                      color: _currentIndex==0?kPrimaryColor1:Colors.grey[400]
                      ),
                  
                    title: Text('Chats',style: TextStyle(color: _currentIndex==0?kPrimaryColor1:Colors.grey[400]),),
                  ),
                  BottomNavigationBarItem(
                    icon:Icon(Icons.people,
                    color: _currentIndex==1?kPrimaryColor1:Colors.grey[400]
                    ),
                    title: Text('People',style: TextStyle(color: _currentIndex==1?kPrimaryColor1:Colors.grey[400]),),
                  ),
                  BottomNavigationBarItem(
                    icon:Icon(Icons.person,
                    color: _currentIndex==2?kPrimaryColor1:Colors.grey[400]
                    ),
                    title: Text('Profile',style: TextStyle(color: _currentIndex==2?kPrimaryColor1:Colors.grey[400]),),
                  ),
                ],
        ),

        
      );}
      else{
        return Loading();
      }

              }
            ),
          ),
    );
  }
}