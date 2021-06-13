import 'package:flutter/material.dart';
import 'package:message_pro/models/account.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/screens/home/chat_screen.dart';
import 'package:message_pro/services/database.dart';
import 'package:message_pro/shared/constants.dart';

class AccountTile extends StatefulWidget {
  bool isFriend;
  final Account account;
  final UserData userData;
  AccountTile({this.isFriend,this.account,this.userData});

  @override
  _AccountTileState createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  getChatRoomId(String a,String b){
    if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      //   print('the values are ${userData.displayName} and ${account.displayName}');
      //   var chatRoomId=getChatRoomId(userData.displayName, account.displayName);
      //   Map<String,dynamic> chatRoomInfoMap={
      //     "users":[userData.displayName,account.displayName]
      //   };
      //   DatabaseService(uid:userData.uid).createChatRoom(chatRoomId, chatRoomInfoMap);
      // Navigator.push(context, MaterialPageRoute(builder:(context)=> ChatScreen(account:account,userData: userData,)));

      },
          child: Padding(
        padding: EdgeInsets.only(top:8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
          child:ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: widget.account.imageUrl!=""?NetworkImage(widget.account.imageUrl) :AssetImage('assets/icons/defaultProfilePic.png') ,
            ),
            title: Text(widget.account.displayName),
            subtitle: Text(widget.account.email),
            trailing: widget.account.uid==widget.userData.uid?Icon(Icons.home,color: kPrimaryColor1,): 
            (widget.isFriend? Icon(Icons.favorite,
            color: Colors.red):FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text(''),
              onPressed: () async {
                Map<String,dynamic> accountInfo={
                  "Display name":widget.account.displayName,
                  "Email":widget.account.email,
                  "Photo":""
                };
                await DatabaseService(uid: widget.userData.uid).addFriend(widget.account.uid, accountInfo);
                var chatRoomId=getChatRoomId(widget.userData.displayName, widget.account.displayName);
                Map<String,dynamic> chatRoomInfoMap={
                  "users":[widget.userData.displayName,widget.account.displayName]
                };
                await DatabaseService(uid:widget.userData.uid).createChatRoom(chatRoomId, chatRoomInfoMap);
                 Map<String, dynamic> lastMessageInfoMap = {
                  "lastMessage": '${widget.userData.displayName} added ${widget.account.displayName} as a Friend',
                  "lastMessageSendTs": DateTime.now(),
                  "lastMessageSendBy": widget.userData.uid
                };
                await DatabaseService(uid: widget.userData.uid)
                .updateLastMessageSend(chatRoomId, lastMessageInfoMap);

              },
            ))
          )
        ),
      ),
    );
      
    
  }
}