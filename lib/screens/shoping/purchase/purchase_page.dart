import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';

class PurchasePage extends StatelessWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildPurchasesContainers("assets/icons/coins_page_icons/ad_free.png","Ad free by \$4.99"),
          buildPurchasesContainers("assets/icons/coins_page_icons/coin.png","100 Coins by \$0.99"),
          buildPurchasesContainers("assets/icons/coins_page_icons/coin.png","100 Coins by \$0.99"),
          buildPurchasesContainers("assets/icons/coins_page_icons/coin.png","500 Coins by \$2"),
          Container(
            margin: EdgeInsets.only(left: 10.w,right: 10.w,top: 10.w,bottom: 3.h),
            height: 80.h,
            padding: EdgeInsets.only(left: 12.w,right: 12.w),
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
                Image.asset("assets/icons/coins_page_icons/offline.png",height: 46.h,width: 46.h,),
                Text("8 Hours offline",style: TextStyle(fontSize: 18.sp,fontFamily: "Aileron"),),
                Container(
                  height: 37.h,
                  padding: EdgeInsets.only(left: 10.w,right: 10.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: AppColors.mainColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Watch Video",style: TextStyle(fontSize: 10.sp,color: Colors.white),),
                      SizedBox(width: 2.w,),
                      ImageIcon(const AssetImage("assets/icons/coins_page_icons/video.png"),size: 15.h,color: Colors.white,),
                      // Icon(Icons.ondemand_video,size: 15.h,color: Colors.white,)
                    ],
                  ),
                )
              ],
            ),
          ),
          buildPurchasesContainers("assets/icons/coins_page_icons/offline.png","Weekly offline \$1.99"),
          buildPurchasesContainers("assets/icons/coins_page_icons/offline.png","Monthly offline \$4.99"),
        ],
      ),
    );
  }


  Container buildPurchasesContainers(String icon,String text) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 10.w,right: 10.w,top: 10.h,bottom: 3.h),
      padding: EdgeInsets.only(left: 20.w),
      height: 80.h,
      decoration: BoxDecoration(
          color: AppColors.subCategoryContainerColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.mainColor),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5),offset: const Offset(0.5,0.5),blurRadius: 2)
          ]
      ),
      child: Row(
        children: [
          Image.asset(icon,height: 46.h,width: 46.h,),
          SizedBox(width: 50.w,),
          Text(text,style: TextStyle(fontSize: 18.sp,fontFamily: "Aileron"),),
        ],
      ),
    );
  }
}
