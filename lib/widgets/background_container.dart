import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/dimensions.dart';

class BackgroundContainer extends StatelessWidget {
  final double height;
  const BackgroundContainer({Key? key,required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: AppColors.mainColor,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(300), bottomRight: Radius.circular(300))
      ),);
  }
}



