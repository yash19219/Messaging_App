import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_pro/models/account.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/services/chatServices.dart';
import 'package:message_pro/services/database.dart';
import 'package:message_pro/shared/constants.dart';
import 'package:message_pro/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final Account account;
  final UserData userData;

  ChatScreen({this.account, this.userData});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = "";
  Stream messageStream;
  UserData userData;
  TextEditingController controller = TextEditingController();

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(UserData userData) {
    if (controller.text != "") {
      //chatRoomId=getChatRoomId(userData.displayName, widget.account.displayName);
      String message = controller.text;
      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfo = {
        "message": message,
        "sendBy": userData.uid,
        "ts": lastMessageTs
      };
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }
      DatabaseService(uid: userData.uid)
          .addMessage(chatRoomId, messageId, messageInfo)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": userData.uid
        };

        DatabaseService(uid: userData.uid)
            .updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        controller.text = "";
        messageId = "";
      });
    }
  }

  getAndSetMessages() async {
    print('The Chatroom Value is $chatRoomId');
    messageStream = await ChatDatabase().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0),
                ),
                color: sendByMe ? kPrimaryColor1 : kSecondaryColor1,
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Colors.white,fontSize: 17.0),
              )),
        ),
      ],
    );
  }

  Widget chatMessages(String myUid) {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        // messageStream.listen((event) { 
        //   print(event);
        // });
        // ChatDatabase().NewMess(widget.userData.displayName);
        //var x=snapshot.getDocumentChanges();
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(ds["message"], myUid == ds["sendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    // print('The value is ${widget.userData.displayName} and ${widget.account.displayName}');
    chatRoomId =
        getChatRoomId(widget.userData.displayName, widget.account.displayName);
    getAndSetMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<Users>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(size.height*0.07),
                  child: AppBar(
                    backgroundColor: kPrimaryColor1,
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: widget.account.imageUrl!=""?NetworkImage(widget.account.imageUrl):AssetImage('assets/icons/defaultProfilePic.png'),
                        ),
                        SizedBox(width: 10),
                        Text(widget.account.displayName),
                      ],
                    ),
                  ),
                ),
                body: Container(
                    child: Stack(
                  children: [
                    chatMessages(user.uid),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            SizedBox(width: size.width*0.03,),
                            Container(
                              // margin: EdgeInsets.symmetric(
                              //     vertical: 10, horizontal: 2),
                              margin: EdgeInsets.fromLTRB(2, 10, 0, 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 1),
                              width: size.width * 0.805,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 2,color: kPrimaryLightColor1),
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextField(
                                  controller: controller,
                                  cursorColor: kPrimaryColor1,
                                  decoration: InputDecoration(
                                    hintText: 'Send Messages',
                                    border: InputBorder.none,
                      
                                  ),
                                ),
                              
                              // FlatButton.icon(
                              //     onPressed: () {
                              //       addMessage(userData);
                              //     },
                              //     icon: Icon(Icons.send),
                              //     label: Text(''))
                            ),
                            Container(
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.zero,
                              width: size.width*0.155,
                             // height: size.height*0.05,
                              child: FlatButton.icon(
                                  onPressed: () {
                                    addMessage(userData);
                                  },
                                  
                                  icon: Icon(Icons.send,color: kSecondaryColor1,),
                                  label: Text('')),
                            )
                          ],
                        ))
                  ],
                )));
          } else {
            return Loading();
          }
        });
  }
}
