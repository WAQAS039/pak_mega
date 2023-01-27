import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pak_mega_mcqs/providers/auth_provider.dart';
import 'package:pak_mega_mcqs/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/screens/home/main_screen.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/widgets/login_page_buttons_container.dart';
import 'package:pak_mega_mcqs/widgets/main_screen_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repo/mcqsdb_repo.dart';
import '../../model/mcqs_db_model.dart';
import '../../model/tests_model.dart';
import '../../routes/routes_helper.dart';
import '../../utils/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = false;
  int network = 0;
  @override
  void initState() {
    checkDbStatus(context);
    network = context.read<int>();
    super.initState();
  }


  void checkDbStatus(BuildContext context) async{
    SharedPreferences sharePreferences = await SharedPreferences.getInstance();
    int? status = sharePreferences.getInt('dbStatus');
    if (status == 1) {
      context.read<MCQsDbProvider>().resetAllList();
      List<TestModel> testList = await MCQsLDbRepo.getTestsFromLocalDb();
      if(testList.isNotEmpty){
        context.read<MCQsDbProvider>().addTestList(tests: testList);
      }
      List<MCQsDbModel> mCQSList = await MCQsLDbRepo.getCategoriesFromLocalDb();
      if(mCQSList.isNotEmpty){
        context.read<MCQsDbProvider>().addMCQsList(mCQsList: mCQSList);
      }
      var categories = context.read<MCQsDbProvider>().categories;
      if (categories.isEmpty) {
        for (int i = 0; i < mCQSList.length; i++) {
          MCQsDbModel mcQsDbModel = mCQSList[i];
          context.read<MCQsDbProvider>().addCategoriesList(categoriesList: mcQsDbModel.categoriesList!);
        }
      }
    }

  }
  void saveMcqsToLocal(BuildContext context) async {
    SharedPreferences sharePreferences = await SharedPreferences.getInstance();
    int? status = sharePreferences.getInt('dbStatus');
    if (status == null || status == 0) {
      MCQsLDbRepo.saveMCQsDbInLocalDb(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/splash/app_icon.png',
      nextScreen: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return snapshot.data!.uid.isNotEmpty ? const MainScreen() : const Scaffold(body: Center(child: CircularProgressIndicator(),),);
          }else{
            return Scaffold(
                body: MainScreenWidget(
                  mainContainerHeight: Dimensions.height460-40,
                  mainCircleTop: Dimensions.height260,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: Dimensions.height50+10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login With",
                              style: TextStyle(
                                  fontSize: Dimensions.height20, fontWeight: FontWeight.w500,color: Colors.white,fontFamily: "poppins"
                              ),
                            ),
                            Text(
                                "Please click on any option",
                                style: TextStyle(
                                    fontSize: Dimensions.height20-1, fontWeight: FontWeight.w400,color: Colors.white,fontFamily: "poppins"
                                )
                            ),
                          ],
                        ),),

                      Container(
                        margin: EdgeInsets.only(top: Dimensions.height135+Dimensions.height20),
                        child: Column(
                          children: [
                            LoginPageButtonContainer(
                              name: "FACEBOOK",
                              containerColor: AppColors.facebookButtonColor,
                              icon: 'facebook',
                              onTap: () {
                                network = context.read<int>();
                                if(network == 1){
                                  saveMcqsToLocal(context);
                                }
                                AuthProvider().loginInWithFacebook(context);
                                // _getDataFromFirestore(context);
                              },),
                            SizedBox(height: Dimensions.height15,),
                            LoginPageButtonContainer(
                                name: "GOOGLE",
                                containerColor: AppColors.googleButtonColor,
                                icon: 'google',
                                onTap: () {
                                  network = context.read<int>();
                                  if(network == 1){
                                    saveMcqsToLocal(context);
                                  }
                                  AuthProvider().loginInWithGoogle(context);
                                }),
                            SizedBox(height: Dimensions.height15,),
                            const Text("OR",style: TextStyle(color: AppColors.textColor),),
                            SizedBox(height: Dimensions.height15,),
                            LoginPageButtonContainer(
                                name: "LOGIN AS GUEST",
                                containerColor: AppColors.guestButtonColor,
                                onTap: (){
                                  network = context.read<int>();
                                  if(network == 1){
                                    saveMcqsToLocal(context);
                                    Navigator.of(context).pushNamed(RouteHelper.loginAsGuest);
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No Internet")));
                                  }
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                )
            );
          }
        },),
      splashTransition: SplashTransition.rotationTransition,
    );
  }

}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Container(
          height: Dimensions.height80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.blue,),
            ],
          ),
        ),
      );
    },
  );
}

void _showTimeoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Request Timeout'),
        content: const Text('The server is taking too long to respond. Please try again later.'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK',style: TextStyle(color: Colors.black),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}


Future _makeRequest(BuildContext context) async {
  try {
    _showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 1), () {

    }).timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("Request Timeout");
    });
  } catch (e) {
    Navigator.pop(context);
    _showTimeoutDialog(context);
  }
}



Future _getDataFromFirestore(BuildContext context) async {
  try {
    _showLoadingDialog(context);
    var snapshot = await FirebaseFirestore.instance.collection('Categories').get().timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException("Request Timeout");
    }).then((value) {
      Navigator.pop(context);
    });
    // Use the data from the snapshot here
  } catch (e) {
    if (e is TimeoutException) {
      Navigator.pop(context);
      _showTimeoutDialog(context);
    }
  }
}






// @override
// Widget build(BuildContext context) {
//   return FutureBuilder<bool>(
//     future: AuthProvider().isAlreadyLogin(),
//     builder: (context, snapshot) {
//       if(snapshot.hasData){
//         return snapshot.data == true ? const MainScreen() : Scaffold(
//             body: MainScreenWidget(
//               mainContainerHeight: Dimensions.height460-40,
//               mainCircleTop: Dimensions.height260,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(top: Dimensions.height50+10),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Login With",
//                           style: TextStyle(
//                               fontSize: Dimensions.height20, fontWeight: FontWeight.w500,color: Colors.white,fontFamily: "poppins"
//                           ),
//                         ),
//                         Text(
//                             "Please click on any option",
//                             style: TextStyle(
//                                 fontSize: Dimensions.height20-1, fontWeight: FontWeight.w400,color: Colors.white,fontFamily: "poppins"
//                             )
//                         ),
//                       ],
//                     ),),
//
//                   Container(
//                     margin: EdgeInsets.only(top: Dimensions.height135+Dimensions.height20),
//                     child: Column(
//                       children: [
//                         LoginPageButtonContainer(
//                           name: "FACEBOOK",
//                           containerColor: AppColors.facebookButtonColor,
//                           icon: 'facebook',
//                           onTap: () {
//                             network = context.read<int>();
//                             if(network == 1){
//                               saveMcqsToLocal(context);
//                             }
//                             AuthProvider().loginInWithFacebook(context);
//                           },),
//                         SizedBox(height: Dimensions.height15,),
//                         LoginPageButtonContainer(
//                             name: "GOOGLE",
//                             containerColor: AppColors.googleButtonColor,
//                             icon: 'google',
//                             onTap: () {
//                               network = context.read<int>();
//                               if(network == 1){
//                                 saveMcqsToLocal(context);
//                               }
//                               AuthProvider().loginInWithGoogle(context);
//                             }),
//                         SizedBox(height: Dimensions.height15,),
//                         const Text("OR",style: TextStyle(color: AppColors.textColor),),
//                         SizedBox(height: Dimensions.height15,),
//                         LoginPageButtonContainer(
//                             name: "LOGIN AS GUEST",
//                             containerColor: AppColors.guestButtonColor,
//                             onTap: (){
//                               network = context.read<int>();
//                               if(network == 1){
//                                 saveMcqsToLocal(context);
//                               }
//                               Navigator.of(context).pushNamed(RouteHelper.loginAsGuest);
//                             }),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//         );
//       }else{
//         return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
//       }
//     },);
// }
