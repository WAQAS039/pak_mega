import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
class FreeRewardedPage extends StatelessWidget {
  const FreeRewardedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRewardedContainers("assets/icons/coins_page_icons/coins_logo.png", "",false,true,context)
      ],
    );
  }

  Container buildRewardedContainers(String icon,String text,bool isCollected,bool isLoaded,BuildContext context) {
    bool watched = false;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 10.w,right: 10.w,top: 10.h,bottom: 3.h),
      padding: EdgeInsets.only(left: 20.w,right: 20.w),
      height: 130.h,
      decoration: BoxDecoration(
          color: AppColors.subCategoryContainerColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.mainColor),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5),offset: const Offset(0.5,0.5),blurRadius: 2)
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon,height: 58.74.h,width: 50.59.w,),
              SizedBox(height: 5.h,),
              Text("Get X20",style: TextStyle(fontSize: 18.sp,fontFamily: "Aileron"),),
            ],
          ),
          isCollected ? Text('Collected',style: TextStyle(fontSize: 22.sp,fontFamily: "Aileron",color: const Color(0xFF9F9F9F))) : const SizedBox.shrink(),
          isLoaded ? InkWell(
            onTap: (){
              buildCollectedDialogBox(context);
            },
            child: Container(
              height: 53.h,
              padding: EdgeInsets.only(left: 20.w,right: 20.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: AppColors.mainColor
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Claim",style: TextStyle(fontSize: 14.sp,color: Colors.white),),
                  SizedBox(width: 10.w,),
                  ImageIcon(const AssetImage("assets/icons/coins_page_icons/video.png"),size: 29.56.h,color: Colors.white,),
                ],
              ),
            ),
          ) : const SizedBox.shrink(),
          // Stack(
          //   clipBehavior: Clip.none,
          //   children: [
          //     Container(
          //       height: 53.h,
          //       width: 147.w,
          //       alignment: Alignment.centerRight,
          //       padding: EdgeInsets.only(left: 20.w,right: 20.w),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(5.r),
          //           color: AppColors.textColor
          //       ),
          //       child: ImageIcon(const AssetImage("assets/icons/coins_page_icons/video.png"),size: 20.56.h,color: Colors.white,),
          //     ),
          //     Positioned(
          //         top: -23.h,
          //         left: 10.w,
          //         child: Image.asset("assets/icons/coins_page_icons/lock.png",height: 75.81.h,)),
          //   ],
          // ),
        ],
      ),
    );
  }

  buildCollectedDialogBox(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            insetPadding: EdgeInsets.only(left: 20.w,right: 20.w),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: Container(
              height: 300.h,
              color: AppColors.mainColor,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.maxFinite,
                  ),
                  Positioned(
                    top: 20.h,
                    bottom: 0,
                    left: 0,right: 0,
                    child: Text('Congratulations',textAlign: TextAlign.center,style: TextStyle(fontSize: 20.sp,fontFamily: "Aileron",color: Colors.white),),),
                  Positioned(
                      left: -10,
                      right: -10,
                      bottom: -10,
                      child: Image.asset('assets/icons/coins_page_icons/sub.png',)),
                  Positioned(
                      left: 20,right: 20,
                      top: 60.h,
                      child: Image.asset('assets/icons/coins_page_icons/coin.png',height: 153.h,)),
                  Positioned(
                      left: 0,right: 0,
                      bottom: 64.h,
                      child: Text(
                        'X20',textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Aileron',fontSize: 28.sp,),
                      )),
                  Positioned(
                    left: 77.w,right: 77.w,
                      bottom: 8.h,
                      child: Container(
                        padding: EdgeInsets.only(top: 12.h,bottom: 12.h),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                          color: AppColors.mainColor
                        ),
                        child: Text('COLLECT',style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Aileron',
                          color: Colors.white
                        ),),
                      ))
                ],
              ),
            ),
          );
          //   AlertDialog(
          //   clipBehavior: Clip.none,
          //   contentPadding: EdgeInsets.zero,
          //   content: Container(
          //     color: AppColors.mainColor,
          //     child: ,
          //   ),
          // );
        },);
  }
}
