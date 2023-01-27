

import 'package:flutter/cupertino.dart';
import 'dart:ui';

extension MediaQueryValues on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double anyHeight(int number){
    double totalHeight = height/number;
    return height/totalHeight;
  }
}

class Dimensions{
  // final double height;
  // final double width;
  // Dimensions({required this.height,required this.width});
  // double anyHeight(int number){
  //   double totalHeight = height/number;
  //   return height/totalHeight;
  // }


  static final screenSize = window.physicalSize / window.devicePixelRatio;
  static final height = screenSize.height;
  static final width = screenSize.width;

  static final double height10 = height/84.4;
  static final double height15 = height/56.26;
  static final double height20 = height/42.2;
  static final double height25 = height/33.73;
  static final double height30 = height/28.13;
  static final double height35 = height/24.11;
  static final double height40 = height/21.1;
  static final double height50 = height/16.88;
  static final double height200 = height/4.22;
  static final double height260 = height/3.24;
  static final double height135 = height/6.25;
  static final double height110 = height/7.67;
  static final double height170 = height/4.96;
  static final double height98 = height/8.612;
  static final double height360 = height/2.41;
  static final double height80 = height/10.55;
  static final double height70 = height/12.05;
  static final double height460 = height/1.83;

  static final double width10 = width/39;
  static final double width15 = width/26;
  static final double width20 = width/19.5;
  static final double width25 = width/15.6;
  static final double width280 = width/1.39;
}
