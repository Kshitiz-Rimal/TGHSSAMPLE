import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';
import 'RegisterAsUser.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register> {
  final TextEditingController _UserNameTextEditingController = TextEditingController();
  final TextEditingController _EmailTextEditingController = TextEditingController();
  final TextEditingController _PasswordTextEditingController = TextEditingController();
  final TextEditingController _ConfirmPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState>_formkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imagefile;

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery
        .of(context)
        .size
        .width,
        _screenheight = MediaQuery
            .of(context)
            .size
            .height;
    return
      SingleChildScrollView(
          child: Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 10.0,),
                  InkWell(
                    onTap: _SelectAndPickImage,
                    child: CircleAvatar(
                      radius: _screenwidth * 0.15,
                      backgroundColor: Colors.white,
                      backgroundImage: _imagefile == null ? null : FileImage(
                          _imagefile),
                      child: _imagefile == null ?
                      Icon(Icons.add_photo_alternate, size: _screenwidth * 0.15,
                        color: Colors.grey,)
                          : null,
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _UserNameTextEditingController,
                          data: Icons.person,
                          hintText: "Your Name",
                          isObsecure: false,
                        ),
                        CustomTextField(
                          controller: _EmailTextEditingController,
                          data: Icons.email,
                          hintText: "Your Email-Id",
                          isObsecure: false,
                        ),
                        CustomTextField(
                          controller: _PasswordTextEditingController,
                          data: Icons.person,
                          hintText: "Password",
                          isObsecure: true,
                        ),
                        CustomTextField(
                          controller: _ConfirmPasswordTextEditingController,
                          data: Icons.person,
                          hintText: "Confirm Password",
                          isObsecure: true,
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {UploadAndSaveImage();},
                    color: Colors.blue,
                    child: Text(
                      "Sign Up", style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: 4.0,
                    width: _screenwidth * 0.8,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ]
            ),
          )
      );
  }
  Future<void> _SelectAndPickImage()async{
    _imagefile =await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> UploadAndSaveImage()async
  {
    if(_imagefile==null)
      {
        showDialog(
            context: context,
          builder: (c){
              return ErrorAlertDialog(message: "Please Select an Image",);
          }
        );
      }
    else
      {
        _PasswordTextEditingController.text==_ConfirmPasswordTextEditingController.text
            ?_EmailTextEditingController.text.isNotEmpty &&
            _PasswordTextEditingController.text.isNotEmpty &&
            _ConfirmPasswordTextEditingController.text.isNotEmpty &&
            _UserNameTextEditingController.text.isNotEmpty

            ? UploadToStorage()

            :DisplayDialogue("Please Fill all the spaces")
            :DisplayDialogue("Password do not Match");

      }
  }
  DisplayDialogue(String Msg)
  {
    showDialog(
      context: context,
      builder: (c){
        return ErrorAlertDialog(message: 'Authenticating, Please wait.....',);
      }
    );
  }
  UploadToStorage()async{
    showDialog(
        context:context,
      builder: (c){
          return LoadingAlertDialog();
      }
    );

    String ImageFileName=DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child(ImageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imagefile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage){
      userImageUrl = urlImage;

      _regesterUser();
    });

  }
  FirebaseAuth _auth=FirebaseAuth.instance;
  void _regesterUser()async{
    FirebaseUser firebaseUser;
    await _auth.createUserWithEmailAndPassword
      (
          email: _EmailTextEditingController.text.trim(),
          password: _PasswordTextEditingController.text.trim(),
    ).then((auth){
          firebaseUser=auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,
      builder:(c){
        return ErrorAlertDialog(message: error.message.toString());
    }
    );
    });
    if(firebaseUser!=null)
      {
        saveUserInfoToFirestore(firebaseUser).then((value){
          Navigator.pop(context);
          Route route=MaterialPageRoute(builder: (c)=>StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }
  }
  Future saveUserInfoToFirestore(FirebaseUser fuser)async{
    Firestore.instance.collection("users").document(fuser.uid).setData({
      "uid":fuser.uid,
      "email":fuser.email,
      "Name": _UserNameTextEditingController.text.trim(),
      "url":userImageUrl,

    });

     await EcommerceApp.sharedPreferences.setString("uid", fuser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fuser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _UserNameTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);


  }


      // Column(
      //   children: [
      //     RaisedButton(
      //         onPressed: () => RegisterAsUser(),
      //         color: Colors.blue,
      //         child: Text(
      //           "As User", style: TextStyle(fontSize: 30, color: Colors.white),)
      //     ),
      //     SizedBox(
      //
      //       height: 15.0,
      //     ),
      //     RaisedButton(
      //         onPressed: () => RegisterAsUser(),
      //         color: Colors.blue,
      //         child: Text(
      //           "As Worker", style: TextStyle(fontSize: 30,color: Colors.white),)
      //     ),
      //     SizedBox(
      //
      //       height: 15.0,
      //     ),
      //   ],
      // );
  }




