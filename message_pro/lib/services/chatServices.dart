import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatDatabase{
  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async{
    return FirebaseFirestore.instance
    .collection("chatrooms")
    .doc(chatRoomId)
    .collection("chats")
    .orderBy("ts",descending: true)
    .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRoom(String myUserName) async{
    return FirebaseFirestore.instance
    .collection("chatrooms")
    .orderBy("lastMessageSendTs",descending: true)
    .where("users",arrayContains:myUserName)
    .snapshots();
  }

  // Update(String myUserName){
    
  //   CollectionReference c= FirebaseFirestore.instance
  //   .collection("chatrooms");
  //  // .where("users",arrayContains:myUserName);
  //  c=c.where("users",arrayContains: myUserName);
  //  Stream<QuerySnapshot<Object>> snap=c.snapshots();
  //  snap.listen((event) { 
  //    event.docChanges.forEach((element) { })
  //  });

   
    
 // }

//  NewMessage(String myUsername,String chatRoomID){

   
//    CollectionReference ref=FirebaseFirestore.instance.collection("chatrooms");
//    ref=ref.where("users",arrayContains: myUsername);
//    Stream<QuerySnapshot> ref1=ref.doc(chatRoomID).collection("chats").snapshots();
//    Future<QuerySnapshot> s=ref.doc(chatRoomID).collection("chats").get();
 
   
// //  }
// NewMess(String a){
//   FirebaseFirestore.instance.collection("chatrooms").where("users",arrayContains: a).snapshots().listen((event) {
//     event.docChanges.forEach((element) {
//       if(element.type==DocumentChangeType.added){
//         print("Chatroom added");
//       }
//       else if(element.type==DocumentChangeType.modified){
//         print("Chatroom modified");
//       }
//       else if(element.type==DocumentChangeType.removed){
//         print("Chatroom removed");
//       }
//     });
//   });
// }

}