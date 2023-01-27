import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/data/repo/auth_repo.dart';
import 'package:pak_mega_mcqs/providers/setting_provider.dart';
import 'package:pak_mega_mcqs/providers/user_information_provider.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:pak_mega_mcqs/widgets/custom_screen_widget.dart';
import 'package:pak_mega_mcqs/widgets/login_page_buttons_container.dart';
import 'package:pak_mega_mcqs/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScreenWidget(
        title: 'Settings',
        onPress: (){
          Navigator.of(context).pop();
        },
        child: Column(
          children: [
            ListTile(
              leading: Text('Sound',style: TextStyle(fontWeight: FontWeight.bold,fontSize: Dimensions.height20,color: Colors.grey,fontFamily: 'aileron'),),
              trailing: Consumer<SettingsProvider>(
                builder: (context, value, child) {
                  return AnimatedToggleSwitch<bool>.dual(
                    current: value.isSoundON!,
                    first: true,
                    second: false,
                    innerColor: value.isSoundON! ? Colors.red : Colors.green,
                    dif: Dimensions.height30,
                    borderColor: Colors.transparent,
                    borderWidth: 5.0,
                    height: Dimensions.height40,
                    indicatorBorderRadius: BorderRadius.circular(Dimensions.height35),
                    indicatorSize: Size(Dimensions.height30,Dimensions.height30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                    onChanged: (b) {
                      context.read<SettingsProvider>().setSound(b);
                      // return Future.delayed(Duration(seconds: 2));
                    },
                    colorBuilder: (b) => Colors.white,
                    // iconBuilder: (value) => const Icon(Icons.circle,color: Colors.white,),
                    textBuilder: (value) => value
                        ? const Center(child: TextWidget(text: "OFF",))
                        : const Center(child: TextWidget(text: "ON")),
                  );
                },
              ),
            ),
            // Divider(color: Colors.grey,indent:Dimensions.height15,endIndent: Dimensions.height15,),
            // ListTile(
            //   leading: Text('Dark Theme',style: TextStyle(fontWeight: FontWeight.bold,fontSize: Dimensions.height20,color: Colors.grey,fontFamily: 'aileron'),),
            //   trailing: Consumer<SettingsProvider>(
            //     builder: (context, value, child) {
            //       return AnimatedToggleSwitch<bool>.dual(
            //         current: value.isDark!,
            //         first: true,
            //         second: false,
            //         innerColor: value.isDark! ? Colors.red : Colors.green,
            //         dif: Dimensions.height30,
            //         borderColor: Colors.transparent,
            //         borderWidth: 5.0,
            //         height: Dimensions.height40,
            //         indicatorBorderRadius: BorderRadius.circular(Dimensions.height35),
            //         indicatorSize: Size(Dimensions.height30,Dimensions.height30),
            //         boxShadow: const [
            //           BoxShadow(
            //             color: Colors.black26,
            //             spreadRadius: 1,
            //             blurRadius: 2,
            //             offset: Offset(0, 1.5),
            //           ),
            //         ],
            //         onChanged: (b) {
            //           context.read<SettingsProvider>().setDark(b);
            //           // return Future.delayed(Duration(seconds: 2));
            //         },
            //         colorBuilder: (b) => Colors.white,
            //         // iconBuilder: (value) => const Icon(Icons.circle,color: Colors.white,),
            //         textBuilder: (value) => value
            //             ? const Center(child: TextWidget(text: "OFF",))
            //             : const Center(child: TextWidget(text: "ON")),
            //       );
            //     },
            //   ),
            // ),
            Divider(color: Colors.grey,indent:Dimensions.height15,endIndent: Dimensions.height15,),
            ListTile(
              title: Text("Delete Account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: Dimensions.height20,color: Colors.grey,fontFamily: 'aileron')),
              trailing: TextButton(onPressed: (){},child: TextWidget(text: "Delete",textColor: Colors.red,fontSize: Dimensions.height20,),),
            ),
            Divider(color: Colors.grey,indent:Dimensions.height15,endIndent: Dimensions.height15,),
            const Spacer(),
            Consumer<UserInformationProvider>(
              builder: (context, value, child) {
                return value.userModel!.loginType == "guest" ? Column(
                  children: [
                    TextWidget(text: "Login With",textColor: Colors.grey,fontSize: Dimensions.height20,fontWeight: FontWeight.bold,),
                    Divider(color: Colors.grey,indent:Dimensions.height50,endIndent: Dimensions.height50,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(child: buttonContainer(name: "GOOGLE", onTap: (){
                          AuthRepo().linkAnonymousUserWithGoogle(value.userModel!.name!,context);
                        }, containerColor: AppColors.googleButtonColor, icon: "google")),
                        Expanded(child: buttonContainer(name: "FACEBOOK", onTap: (){
                          AuthRepo().linkAnonymousUserWithFacebook(value.userModel!.name!,context);
                        }, containerColor: AppColors.facebookButtonColor, icon: "google"))
                      ],
                    ),
                    SizedBox(height: Dimensions.height10,),
                  ],
                ):const SizedBox.shrink();
              },
            )
          ],
        ));
  }
}


Widget buttonContainer({required String name,required VoidCallback onTap,required Color containerColor,required String icon}){
  return InkWell(
    onTap: onTap,
    child: Container(
        height: Dimensions.height50+10,
        margin: const EdgeInsets.only(left: 5,right: 5),
        decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(Dimensions.height15)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/login_page_icons/$icon.png",
                height: icon == "FACEBOOK" ? Dimensions.height30:Dimensions.height20,width: Dimensions.height20,),
              SizedBox(
                width: Dimensions.height20,
              ),
              Text(
                name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: "poppins"
                ),
              )
            ],
          ),
        )),
  );
}
