import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/screens/home/chatroomTile.dart';
import 'package:message_pro/services/chatServices.dart';
import 'package:message_pro/shared/constants.dart';

class Chats extends StatefulWidget {
  final UserData userdata;
  Chats({this.userdata});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  Stream chatRoomStream;
  
  Widget chatRoomList(UserData userData){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context,snapshot){
        return snapshot.hasData?
        ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            DocumentSnapshot ds=snapshot.data.docs[index];
            return ChatRoomListTile(ds["lastMessage"],ds.id,widget.userdata.displayName,userData,ds["lastMessageSendTs"]);
          }
          ) : Center(child: CircularProgressIndicator()); 
      }
      );
  }

  getChatRooms() async{
    chatRoomStream=await ChatDatabase().getChatRoom(widget.userdata.displayName);
    setState(() {
      
    });
  }
  
  @override
  void initState() {
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical:2.0),
          width: size.width,
          height: size.height*0.1,
          color: kPrimaryColor1,
          alignment: Alignment.centerLeft,
          child: Container(
            //color: Colors.white,
            width: size.width*0.4,
            height: size.height*0.045,
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(55),
             ),
            child: Center(
              child: Text(
                'Recent Messages',
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
        Expanded(
                  child: Container(
            child:chatRoomList(widget.userdata)
          ),
        ),
      ],
    );
  }
}