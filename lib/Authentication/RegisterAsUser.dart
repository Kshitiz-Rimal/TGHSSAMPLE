import 'dart:io';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class RegisterAsUser extends StatefulWidget {
  @override
  _RegisterAsUserState createState() => _RegisterAsUserState();
}



class _RegisterAsUserState extends State<RegisterAsUser>
{
  final TextEditingController _UserNameTextEditingController=TextEditingController();
  final TextEditingController _EmailTextEditingController=TextEditingController();
  final TextEditingController _PasswordTextEditingController=TextEditingController();
  final TextEditingController _ConfirmPasswordTextEditingController=TextEditingController();
  final GlobalKey<FormState>_formkey=GlobalKey<FormState>();
  String userImageUrl="";
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
    return Scaffold(body:
      SingleChildScrollView(
        child: Container(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 10.0,),
                InkWell(
                  onTap: () => print("Selected"),
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
                  onPressed: () => ("clicked"),
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
    )
    );
  }

}

