import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_pro/models/account.dart';
import 'package:message_pro/models/friends.dart';
import 'package:message_pro/models/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection=FirebaseFirestore.instance.collection('users');

  Future updateUserData(String displayName,String email,String imageUrl) async{
    return await userCollection.doc(uid).set({
      'Display name':displayName,
      'Email':email,
      'Photo':imageUrl,
    });
  }

  List<Account> _accountListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Account(
        uid: doc.id,
        displayName: doc['Display name']?? '',
        email: doc['Email']?? '',
        imageUrl: doc['Photo']?? ''
      );
    }).toList();
  }
List<Friend> _friendListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Friend(
        uid: doc.id,
        displayName: doc['Display name']?? '',
        email: doc['Email']?? '',
        imageUrl: doc['Photo']?? ''
      );
    }).toList();
  }
  

  Stream<List<Account>> get accounts{
    return userCollection.snapshots()
    .map(_accountListFromSnapshot);
  }

  Stream<List<Friend>> get friends{
    return FirebaseFirestore.instance
    .collection("users")
    .doc(uid)
    .collection("friends").snapshots()
    .map(_friendListFromSnapshot);
  }


  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid:uid,
      displayName: snapshot['Display name'],
      email: snapshot['Email'],
      imageUrl: snapshot['Photo']
    );
  }

  Stream<UserData> get userData{
    return userCollection.doc(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

  Future addMessage(String chatRoomId,String messageId,Map messageInfoMap) async {
    return FirebaseFirestore.instance
    .collection("chatrooms")
    .doc(chatRoomId)
    .collection("chats")
    .doc(messageId)
    .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId,Map lastMessageInfoMap){
    return FirebaseFirestore.instance.collection("chatrooms")
    .doc(chatRoomId).update(lastMessageInfoMap);
  }

  createChatRoom(String chatRoomId,Map chatRoomInfoMap) async {
    final snapshot=await FirebaseFirestore.instance
    .collection("chatrooms")
    .doc(chatRoomId)
    .get();

    if(snapshot.exists){
      return true;
    }
    else{
      return FirebaseFirestore.instance
      .collection("chatrooms")
      .doc(chatRoomId)
      .set(chatRoomInfoMap);
    }
  }

  Future addFriend(String friendsUID,Map accountInfo) async{
    return FirebaseFirestore.instance
    .collection("users")
    .doc(uid)
    .collection("friends")
    .doc(friendsUID)
    .set(accountInfo);
  }

  getUserInfo(String name) async{
    return await FirebaseFirestore.instance
    .collection("users")
    .where("Display name",isEqualTo: name)
    .get();
  }

  
}