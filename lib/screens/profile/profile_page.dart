import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_mega_mcqs/common/database/offline_database.dart';
import 'package:pak_mega_mcqs/common/model/leader_board_model.dart';
import 'package:pak_mega_mcqs/screens/login/login_provider.dart';
import 'package:pak_mega_mcqs/common/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/common/providers/points_provider.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_provider.dart';
import 'package:pak_mega_mcqs/common/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/common/widgets/main_screen_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/text_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  int network = 0;
  @override
  void initState() {
    network = context.read<int>();
    getRankFromLeaderBoard();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainScreenWidget(
          mainContainerHeight: Dimensions.height360 - 28,
          mainCircleTop: Dimensions.height260,
          child: Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    margin: EdgeInsets.only(top: Dimensions.height40),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white, size: Dimensions.height20
                        ))),
                SizedBox(
                  height: Dimensions.height135,
                ),
                Consumer<ProfileProvider>(
                  builder: (context, profile, child) {
                    return Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: Dimensions.height80 - 10,
                              backgroundColor: AppColors.mainColor,
                              child: profile.userModel!.imageType == "asset" ? CircleAvatar(
                                radius: Dimensions.height50 + 10,
                                backgroundImage: AssetImage(profile.userModel!.image!),
                              ) : ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.height50 + 20),
                                child: CachedNetworkImage(
                                  imageUrl: profile.userModel!.image!,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Positioned(
                              top: Dimensions.height20,
                              left: -5,
                              child: InkWell(
                                onTap: (){
                                  showImagesBottomSheet(context,profile.userModel!.image!,profile.userModel!.imageType!);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: Dimensions.height20,
                                  child: CircleAvatar(
                                    radius: Dimensions.height15 + 3,
                                    backgroundColor: AppColors.mainColor,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: Dimensions.height15 + 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: Dimensions.height10),
                            child: Text(
                              profile.userModel!.name!,
                              style:
                                  const TextStyle(color: AppColors.mainColor),
                            )),
                        // Text(value.userModel!.email!),
                        Container(
                          height: Dimensions.height80,
                          margin: EdgeInsets.only(
                              left: Dimensions.height30,
                              right: Dimensions.height30,
                              top: Dimensions.height80),
                          padding: EdgeInsets.only(left: Dimensions.height20),
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.height10)),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/achive.png',
                                height: Dimensions.height50,
                                width: Dimensions.height50,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: Dimensions.height10,
                                      right: Dimensions.height10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.height30)),
                                  child: LinearPercentIndicator(
                                    // animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 2500,
                                    padding: const EdgeInsets.all(0),
                                    percent: profile.userModel!.points!/profile.userModel!.totalPoints!,
                                    center: Text("${profile.userModel!.points!}/${profile.userModel!.totalPoints!}"),
                                    barRadius: Radius.circular(Dimensions.height30),
                                    progressColor: Colors.green,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: Dimensions.height110,
                          margin: EdgeInsets.only(
                              left: Dimensions.height30,
                              right: Dimensions.height30,
                              top: Dimensions.height35),
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(Dimensions.height10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    Icons.star_border_purple500_outlined,
                                    color: Colors.white,
                                  ),
                                  Text('Points',style: TextStyle(color: Colors.white,fontSize: Dimensions.height15)),
                                  TextWidget(text: profile.userModel!.points.toString())
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.white,
                                indent: Dimensions.height20,
                                endIndent: Dimensions.height20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.language_rounded,color: Colors.white,),
                                  Text('Rank',style: TextStyle(color: Colors.white,fontSize: Dimensions.height15),),
                                  TextWidget(text: profile.userModel!.allTimeRank.toString(),)
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Text(FirebaseAuth.instance.currentUser!.photoURL!),
                        // Text(FirebaseAuth.instance.currentUser!.uid),
                        // Image.network(FirebaseAuth.instance.currentUser!.photoURL!),
                        Container(
                          margin: EdgeInsets.only(top: Dimensions.height10,left: Dimensions.height30,right: Dimensions.height30),
                          height: Dimensions.height50,
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Dimensions.height35)
                              )
                            ),
                            onPressed: () async {
                              SharedPreferences sharePreferences = await SharedPreferences.getInstance();
                              if(profile.userModel!.loginType == "google" || profile.userModel!.loginType == "facebook"){
                                showDialogForNormalUser(sharePreferences, context, profile.userModel!.loginType!);
                              }else{
                                showDialogForGuestUser(sharePreferences, context);
                              }
                            },
                            child: TextWidget(
                              text: 'Sign Out',
                              textColor: Colors.white,
                              fontSize: Dimensions.height15+1,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                )
              ],
            ),
          )),
    );
  }
  
  void showImagesBottomSheet(BuildContext context,String image,String imageType) {
     showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: AppColors.mainColor,
      builder: (context) {
      return SizedBox(
        height: Dimensions.height460,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: const Icon(Icons.clear)),
            Flexible(
              child: GridView.builder(
                  itemCount: 7,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      mainAxisExtent: Dimensions.height98+2,
                      crossAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 5,right: 5),
                      child: InkWell(
                        onTap: (){
                          context.read<ProfileProvider>().updateUserPicture('assets/images/guest_images/${index+1}.png', "asset");
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          radius: Dimensions.height35,
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.height25),
                            child: Image.asset('assets/images/guest_images/${index+1}.png',height: Dimensions.height80+10,)
                        ),
                      ),
                    ));
                  },),
            ),
          ],
        ),
      );
    },);
  }

  getRankFromLeaderBoard() {
    network = context.read<int>();
    print("------------- $network");
    var userModel = context.read<ProfileProvider>().userModel;
    if(network == 1){
      FirebaseFirestore.instance.collection('leaderboard').orderBy("points",descending: true).get().then((value) {
        var list = value.docs.map((e) => e.data()).toList();
        if(list.isNotEmpty){
          for(int i = 0;i<list.length;i++){
            if(userModel!.uid == LeaderBoardModel.fromJson(list[i]).uid){
              context.read<ProfileProvider>().updateAllTimeRank(i+1);
              break;
            }
          }
        }
      });
    }else{
      Future.delayed(const Duration(seconds: 2),(){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No Internet"),));
      });
    }
  }

}

Future<void> showDialogForNormalUser(SharedPreferences sharePreferences,BuildContext context,String loginType) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_rounded,color: AppColors.mainColor,size: 28.65.h,),
            Container(
                margin: EdgeInsets.only(top: 45.h.h,bottom: Dimensions.height50,left: Dimensions.height20,right: Dimensions.height20),
                child: const Text('Do you want to sign out ?',textAlign: TextAlign.center,style: TextStyle(fontFamily: 'aileron'),)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buttonWidget("Cancel",(){
                  Navigator.of(context).pop();
                }),
                buttonWidget("Ok",(){
                  if(loginType == "google"){
                    LoginProvider().logoutFromGoogle();
                    Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.loginPage, (route) => false);
                  }else if(loginType == "facebook"){
                    LoginProvider().logoutFromFacebook();
                    Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.loginPage, (route) => false);
                  }
                }),
              ],
            ),
          ],
        ),
      );
    },);
}

// sharePreferences.clear();
// context.read<MCQsDbProvider>().resetAllList();
// OfflineDatabase().deleteCategoriesListFromLocalDb();
// OfflineDatabase().deleteTestListFromLocalDb();


Future<void> showDialogForGuestUser(SharedPreferences sharePreferences,BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (context) {
      return AlertDialog(
        insetPadding: EdgeInsets.only(left: Dimensions.height20,right: Dimensions.height20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_rounded,color: AppColors.mainColor,size: 28.65.h,),
            Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(top: 18.7.h,bottom: Dimensions.height20,),
                child: Text('If you sign out all data will be lost \n\nIf you want to save your progress and scores. Convert guest to real account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Dimensions.height15,fontFamily: 'aileron'),)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buttonWidget("Convert Guest\nTo Real",(){
                  Navigator.of(context).pushNamed(RouteHelper.settingsPage);
                }),
                buttonWidget("Cancel",(){
                  Navigator.of(context).pop();
                }),
                buttonWidget("Sign Out",(){
                  LoginProvider().logoutFromGuest();
                  Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.loginPage, (route) => false);
                }),
              ],
            ),
          ],
        ),
      );
    },);
}

buttonWidget(String text,VoidCallback onTab){
  return InkWell(
    onTap: onTab,
    child: Container(
      height: Dimensions.height40,
      width: Dimensions.height98,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainColor),
          borderRadius: BorderRadius.circular(Dimensions.height10)
      ),
      child: TextWidget(text: text,textColor: Colors.black,fontSize: 13,textAlign: TextAlign.center,),
    ),
  );
}