import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pak_mega_mcqs/common/utils/app_colors.dart';

class BackgroundContainer extends StatelessWidget {
  final double height;
  const BackgroundContainer({Key? key,required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.mainColor,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(300.r), bottomRight: Radius.circular(300.r))
      ),);
  }
}



