import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/BookQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth=FirebaseAuth.instance;
  EcommerceApp.sharedPreferences=await SharedPreferences.getInstance();
  EcommerceApp.firestore=Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            title: 'e-Shop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.green,
            ),
            home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState() {
    super.initState();
    displaySplash();
  }
  displaySplash(){
    Timer(Duration(seconds: 5), ()async{
      if(await EcommerceApp.auth.currentUser() != null ){
        Route route=MaterialPageRoute(builder: (_)=>StoreHome());
        Navigator.pushReplacement(context, route);
      }
      else{
        Route route=MaterialPageRoute(builder: (_)=>AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text(
            "तापई को घर हम्रो सेवा",
          style: TextStyle(color: Colors.green, fontSize: 40.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
