import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pak_mega_mcqs/common/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/common/utils/app_constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2),(){
      int status = Hive.box(appBox).get(dbStatus) ?? 0;
      if(status == 0){
        Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.setupPage, (route) => false);
      }else{
        Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.loginPage, (route) => false);
      }
    });
    return Scaffold(
      body: Image.asset('assets/splash/splash.jpg',width: double.maxFinite,fit: BoxFit.cover,),
    );
  }
}
