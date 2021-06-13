import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_pro/models/account.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/screens/home/chat_screen.dart';
import 'package:message_pro/services/database.dart';
import 'package:message_pro/shared/constants.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername;
  Timestamp time;
  UserData userData;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername,this.userData,this.time);
  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";
  Account account;
  getThisUserInfo() async {
    username =widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseService().getUserInfo(username);
   //print("something bla bla ${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["Display name"]}");
    name = querySnapshot.docs[0]["Display name"];
    profilePicUrl = "${querySnapshot.docs[0]["Photo"]}";
    account=Account(
      uid: querySnapshot.docs[0].id,
      displayName: name,
      email: querySnapshot.docs[0]['Email'],
      imageUrl: profilePicUrl
    );
    setState(() {});
  }

  String timeDiff(Timestamp time){
    Duration d=DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(widget.time.microsecondsSinceEpoch));
    if(d.inSeconds<60){
      return d.inSeconds.toString()+" secs ago";
    }
    else if(d.inMinutes<60){
      return d.inMinutes.toString()+' mins ago';
    }
    else if(d.inHours<24){
      return d.inHours.toString()+' hours ago';
    }
    else{
      return d.inDays.toString()+' days ago';
    }
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top:10.0),
      child:GestureDetector(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder:(context)=> ChatScreen(account:account,userData:widget.userData ,)));
        } ,
              child: Card(
                elevation: 0,
          color: Colors.white,
        margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0), 
        child: ListTile(
          leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: profilePicUrl!=""?NetworkImage(profilePicUrl): AssetImage('assets/icons/defaultProfilePic.png') ,
              ),
              title: Text(name),
              subtitle: Text(widget.lastMessage),
              trailing: Container(child: Text(timeDiff(widget.time),style: TextStyle(fontSize: 10,color: Colors.grey),)),
        ),
             ),
      )
    );
    // return Container(
    //   margin: EdgeInsets.symmetric(vertical: 8),
    //     child: Row(
    //       children: [
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(30),
    //           child: profilePicUrl==""?Text('Image'): Image.network(
    //             profilePicUrl,
    //             height: 40,
    //             width: 40,
    //           ),
    //         ),
    //         SizedBox(width: 12),
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               name,
    //               style: TextStyle(fontSize: 16),
    //             ),
    //             SizedBox(height: 3),
    //             Text(widget.lastMessage)
    //           ],
    //         )
    //       ],
    //     ),
    // );
  }
}
