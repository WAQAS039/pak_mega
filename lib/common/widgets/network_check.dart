import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';

class NetworkCheck extends StatelessWidget {
  const NetworkCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/internet.png',height: Dimensions.height200+10,),
          SizedBox(height: Dimensions.height15,),
          const Text('No Internet Connection'),
          const SizedBox(height: 4,),
          const Text('Check your connection, then refresh the page.',textAlign: TextAlign.center,),
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.height50),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainColor),
                  borderRadius: BorderRadius.circular(Dimensions.height15)
              ),
              padding: EdgeInsets.only(left: Dimensions.height50,right: Dimensions.height50,top: Dimensions.height10,bottom: Dimensions.height10),
              child: const Text('Ok',style: TextStyle(color: AppColors.mainColor),),
            ),
          )
        ],
      ),
    );
  }
}
