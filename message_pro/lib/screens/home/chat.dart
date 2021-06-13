import 'package:flutter/material.dart';
import 'package:message_pro/shared/constants.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUer;
  ChatScreen({this.chatWithUer});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(widget.chatWithUer),
      ),
      
    );
  }
}