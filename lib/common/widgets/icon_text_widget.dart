import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/text_widget.dart';

class IconTextWidget extends StatelessWidget {
  final Color circleColor;
  final Color textColor;
  final String result;
  final String title;
  const IconTextWidget({Key? key,required this.circleColor,required this.textColor, required this.result,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: circleColor,
              radius: Dimensions.height15-3,
            ),
            SizedBox(width: Dimensions.height10,),
            TextWidget(text: result,textColor: textColor,fontSize: Dimensions.height15,)
          ],
        ),
        const SizedBox(height: 5,),
        TextWidget(text: title,textColor: AppColors.textColor,fontSize: Dimensions.height10 + 2,)
      ],
    );
  }
}
