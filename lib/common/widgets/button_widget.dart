import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';

class ButtonWidget extends StatelessWidget {
  final Color? textColor;
  final double? textSize;
  final String text;
  final double radius;
  final Color buttonColor;
  final FontWeight fontWeight;
  final double? height;
  const ButtonWidget({Key? key, this.textColor = Colors.white, this.textSize = 0, required this.text, this.radius = 20, this.buttonColor = Colors.white, this.fontWeight = FontWeight.normal, this.height = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == 0 ? Dimensions.height50 : height,
      margin: EdgeInsets.only(left: Dimensions.height25 , right: Dimensions.height25,top: 5, bottom: 5),
      // padding: EdgeInsets.all(Dimensions.height10),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: buttonColor, boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), offset: Offset(0.5,0.5), blurRadius: 0.5,)
          ]
      ),
      child: Center(child: Text(text, style: TextStyle(color: textColor, fontSize: textSize == 0 ? Dimensions.height20 : textSize, fontWeight: fontWeight),)),
    );
  }
}
