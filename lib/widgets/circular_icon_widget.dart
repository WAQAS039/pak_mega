import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/Widgets/text_widget.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';

import '../utils/app_colors.dart';

class CircularIconWidget extends StatelessWidget {
  final Color circleColor;
  final IconData icon;
  final String title;
  final VoidCallback onPress;
  final String? imagePath;
  const CircularIconWidget({Key? key,required this.circleColor,required this.title,required this.icon,required this.onPress,this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          CircleAvatar(
            radius: Dimensions.height35,
            backgroundColor: circleColor,
            child: Center(
              child: imagePath == null ? Icon(icon,color: Colors.white,size: Dimensions.height25,) : ImageIcon(AssetImage(imagePath!),size: Dimensions.height30,color: Colors.white,),
            ),
          ),
          SizedBox(height: Dimensions.height10,),
          TextWidget(text: title,fontSize: Dimensions.height15 - 2,textColor: AppColors.textColor,)
        ],
      ),
    );
  }
}
