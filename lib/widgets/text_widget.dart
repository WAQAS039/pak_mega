import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  const TextWidget({Key? key, required this.text , this.textColor = Colors.white, this.fontSize = 15,this.fontWeight = FontWeight.normal,this.textAlign = TextAlign.justify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: textColor , fontSize: fontSize == 15 ? Dimensions.height15:fontSize,fontWeight: fontWeight,fontFamily: 'aileron'),textAlign: textAlign,);
  }
}
