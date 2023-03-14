import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';

class EasyLoadingDialog {
  static Future<void> show(
      {required BuildContext context,
      double? radius = 15.0,
      Widget? indicator = const CircularProgressIndicator(
        strokeWidth: 2,
      )}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          backgroundColor: AppColors.mainColor,
          shape: const CircleBorder(),
          content: CircleAvatar(
              backgroundColor: AppColors.mainColor,
              radius: radius,
              child: SizedBox(height: 30.h, width: 30.w, child: indicator)),
        );
      },
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}

// EasyLoadingDialog.show(context: context,radius: 20.r,);
// Future.delayed(const Duration(seconds: 5),(){
// EasyLoadingDialog.dismiss(context);
// });
