import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tasheha_app/Theme/colors.dart';
import 'package:tasheha_app/pages/welcome.dart';
import 'package:tasheha_app/pages/home.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn');
  if (isLoggedIn == null || !isLoggedIn) {
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Welcome()),
      );
    });

  } else {
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Home()),
      );
    });

  }
 }


  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Welcome()),
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backC, 
      body: Align(
        alignment: Alignment.center,
      
        child:Center(child:
         Column
         (
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          mainAxisSize: MainAxisSize.min,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("Trip",style: TextStyle(fontFamily: 'RadioCanadaBig',color: AppColors.blueC,fontSize: 55)), 
            SizedBox(width: 5,),
            Text("JO",style: TextStyle(fontFamily: 'RadioCanadaBig',color: AppColors.brownC ,fontSize: 55)), 

            ],),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.blueC),
            ), 
          ],
        ),),
      ), 
    );
  }
}
