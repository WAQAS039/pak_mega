import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/screens/login/login_provider.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/main_screen_widget.dart';


class LoginAsGuest extends StatefulWidget {
  const LoginAsGuest({Key? key}) : super(key: key);

  @override
  State<LoginAsGuest> createState() => _LoginAsGuestState();
}

class _LoginAsGuestState extends State<LoginAsGuest> {
  var name = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/backgrounds/login_guest_background.png'),
              fit: BoxFit.cover)),
      child: WillPopScope(
        onWillPop: () async{
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: MainScreenWidget(
              mainContainerHeight: Dimensions.height360 - 30,
              mainCircleTop: Dimensions.height260,
              isGuestScreen: true,
              child: Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                          margin: EdgeInsets.only(top: Dimensions.height40),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ))),
                    ),
                    Positioned(
                      bottom: Dimensions.height110,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: Dimensions.height50 + 6,
                            margin: EdgeInsets.only(left: Dimensions.height30, right: Dimensions.height30),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(Dimensions.height10),
                                boxShadow: const [
                                  BoxShadow(color: Colors.grey, blurRadius: 0.5)
                                ]),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Dimensions.height15),
                              controller: name,
                              decoration: InputDecoration(
                                  hintText: "Enter Your Nickname",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.height10),
                                    borderSide: const BorderSide(color: AppColors.mainColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: AppColors.circleColor2),
                                    borderRadius: BorderRadius.circular(Dimensions.height10),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.height20,
                          ),
                          InkWell(
                            onTap: () {
                              if(name.text.isNotEmpty){
                                LoginProvider().loginWithAnonymous(context, name.text);
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Can not be Empty')));
                              }
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: Dimensions.height50 + 6,
                              margin: EdgeInsets.only(
                                  top: Dimensions.height10,
                                  left: Dimensions.height35,
                                  right: Dimensions.height35),
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(Dimensions.height10),
                                  boxShadow: const [
                                    BoxShadow(color: AppColors.mainColor, blurRadius: 0.1)
                                  ]),
                              child: Center(
                                child: Text(
                                  'START',
                                  style: TextStyle(
                                      fontSize: Dimensions.height15 + 3,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
