import 'package:flutter/material.dart';
import 'package:message_pro/models/user.dart';
import 'package:message_pro/services/database.dart';
import 'package:message_pro/shared/constants.dart';
import 'package:message_pro/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class Profile extends StatefulWidget {
  final UserData userData;
  Profile({this.userData});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _displayName;
  TextEditingController controller=TextEditingController();
  File image;
  String imgUrl;

  Future getImage() async{
    final img=await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
          image=File(img.path);
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Container(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                       SizedBox(height: size.height*0.04),
                      Text(
                        'Your Account',
                        style: TextStyle(
                          fontSize: 24.0,
                          //fontFamily: 'Lobster',
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                          
                          ),
                      ),
                      SizedBox(height: size.height*0.05),
                      GestureDetector(
                        onTap: (){
                          getImage();
                        },
                        child: CircleAvatar(
                          radius: 100.0,
                         backgroundImage: image!=null?FileImage(image): ( userData.imageUrl!=""?NetworkImage(userData.imageUrl):AssetImage('assets/icons/defaultProfilePic.png')) ,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          SizedBox(width: size.width*0.03),
                          Text(
                            'Display Name',
                            style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            ),
                            ),
                            SizedBox(width: size.width*0.01),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                            width: size.width * 0.60,
                            height: size.height*0.05,
                            decoration: BoxDecoration(
                              color: kPrimaryColor1,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: TextFormField(
                                //controller: controller,
                                textAlign: TextAlign.center,
                                validator: (val)=>val.isEmpty?'Please enter your Display name':null,
                                initialValue: userData.displayName,
                                style: TextStyle(color: Colors.white),
                                  cursorColor: kPrimaryColor1,
                                  onChanged: (val) {
                                    setState(() {
                                      _displayName = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    // icon: Icon(
                                    //   Icons.visibility,
                                    //   color: kPrimaryColor,
                                    // ),
                                    hintText: 'Display Name',
                                    border: InputBorder.none,
                                  )),
                            
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: size.width*0.03),
                          Text(
                            'Email ID',
                            style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            ),
                            ),
                          SizedBox(width: size.width*0.125),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                            width: size.width * 0.60,
                             height: size.height*0.05,
                            decoration: BoxDecoration(
                              color: kPrimaryColor1,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: Center(
                              child: Text(
                                '${userData.email}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.2),
                      GestureDetector(
                        onTap: () async {
                          //if(=""){
                            var storageImage=FirebaseStorage.instance.ref().child(image.path);
                            var task=await storageImage.putFile(image);
                            imgUrl=await task.ref.getDownloadURL();
                            await DatabaseService(uid: userData.uid).updateUserData(
                              _displayName??userData.displayName, 
                              userData.email, imgUrl);
                         // }
                        },
                        child: Container(
                          //alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                              width: size.width * 0.40,
                               height: size.height*0.05,
                              decoration: BoxDecoration(
                                color: kSecondaryColor1,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: Center(
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          else{
            return Loading();
          }
        });
  }
}
