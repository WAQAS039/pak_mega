import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_mega_mcqs/screens/login/login_provider.dart';
import 'package:pak_mega_mcqs/common/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/login_page_buttons_container.dart';
import 'package:pak_mega_mcqs/common/widgets/main_screen_widget.dart';
import 'package:pak_mega_mcqs/screens/application/main_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    int network = Provider.of<int>(context);
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return snapshot.data!.uid.isNotEmpty ? const MainScreen() : const Scaffold(body: Center(child: CircularProgressIndicator(),),);
        }else{
          return Scaffold(
              body: MainScreenWidget(
                mainContainerHeight: Dimensions.height460-40,
                mainCircleTop: Dimensions.height260,
                child: Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 160.h,
                  child: SingleChildScrollView(
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
                                  LoginProvider().loginInWithFacebook(context);
                                },),
                              SizedBox(height: Dimensions.height15,),
                              LoginPageButtonContainer(
                                  name: "GOOGLE",
                                  containerColor: AppColors.googleButtonColor,
                                  icon: 'google',
                                  onTap: () {
                                    LoginProvider().loginInWithGoogle(context);
                                  }),
                              SizedBox(height: Dimensions.height15,),
                              const Text("OR",style: TextStyle(color: AppColors.textColor),),
                              SizedBox(height: Dimensions.height15,),
                              LoginPageButtonContainer(
                                  name: "LOGIN AS GUEST",
                                  containerColor: AppColors.guestButtonColor,
                                  onTap: (){
                                    if(network == 1){
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
                  ),
                ),
              )
          );
        }
      },);
  }
}









