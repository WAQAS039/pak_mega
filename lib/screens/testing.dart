import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:pak_mega_mcqs/widgets/background_container.dart';

class Testing extends StatelessWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Positioned(
          //     top: 0,
          //     left: -Dimensions.height20,
          //     right: -Dimensions.height20,
          //     child: Image.asset('assets/circle.png',width: double.maxFinite,height: Dimensions.height360-30,)),
          Positioned(
              left: -Dimensions.height20,
              right: -Dimensions.height20,
              child: BackgroundContainer(height: Dimensions.height360)),
          Positioned(
              top: -Dimensions.height200,
              left: 0,
              right: 0,
              child: Image.asset('assets/main_circle.png',height: Dimensions.height460,width: double.maxFinite,))
        ],
      ),
    );
  }


}
