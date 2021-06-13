import 'package:flutter/material.dart';
import 'package:message_pro/models/account.dart';
import 'package:message_pro/models/friends.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/screens/home/account_tile.dart';
import 'package:provider/provider.dart';

class AccountList extends StatefulWidget {
  final UserData userData;
  AccountList({this.userData});
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {

  bool checkIsFriend(List<Friend> friends,String uid){
    if(friends!=null){
    for(int i=0;i<friends.length;i++){
      if(friends[i].uid==uid){
        return true;
      }
    }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Account> accounts=Provider.of<List<Account>>(context);
    final List<Friend> friends=Provider.of<List<Friend>>(context);
    // print('------------------');
    // print(accounts.length);
    // print('------------------');
    // print(friends.length);
    return accounts==null?Container():ListView.builder(
      itemCount: accounts.length,
      itemBuilder:(context,index){
        return AccountTile(isFriend: checkIsFriend(friends, accounts[index].uid),account:accounts[index],userData:widget.userData);
      },
      );
  }
}