import 'package:firebase_auth/firebase_auth.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/services/database.dart';

class AuthService{

  final FirebaseAuth _auth=FirebaseAuth.instance;


  Users _userFromFirebaseUser(User user){
    return user!=null?Users(uid:user.uid):null;
  }

  Stream<Users> get user{
    return _auth.authStateChanges()
    .map(_userFromFirebaseUser);
  }

  Future registerWithEmailAndPassword(String displayName,String email, String password) async {
    try{
      UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(result);
      User user=result.user;

       await DatabaseService(uid: user.uid).updateUserData(displayName,email,'');
      // return _userFromFirebaseUser(user);
      return user.uid;

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user=result.user;
       print('Sign In Successfull');
      return user;
      //return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      return null;
    }
  }

}