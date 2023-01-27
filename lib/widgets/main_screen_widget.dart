import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import 'background_container.dart';


class MainScreenWidget extends StatelessWidget {
  final double mainContainerHeight;
  final Widget child;
  final bool? isGuestScreen;
  final double mainCircleTop;
  const MainScreenWidget({Key? key, required this.mainContainerHeight,required this.child,this.isGuestScreen = false,required this.mainCircleTop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: -Dimensions.height20,
            right: -Dimensions.height20,
            child: BackgroundContainer(height: mainContainerHeight)),
        Positioned(
            top: -mainCircleTop,
            left: 0,
            right: 0,
            child: Image.asset('assets/icons/coins_page_icons/main_circle.png',height: Dimensions.height460,width: double.maxFinite,)),
        // Positioned(
        //     top: Dimensions.height10,
        //     bottom: 0,
        //     left: -Dimensions.height98,
        //     child: isGuestScreen! ? Image.asset('assets/icons/coins_page_icons/double_circle.png',height: Dimensions.height200,width: Dimensions.height200,) : const SizedBox.shrink()),
        // Positioned(
        //     bottom: Dimensions.height135+10,
        //     right: -Dimensions.height98,
        //     child: isGuestScreen! ? Image.asset('assets/icons/coins_page_icons/multi_circle.png',height: Dimensions.height200,width: Dimensions.height200,) : const SizedBox.shrink()),
        // Positioned(
        //   bottom: 0,
        //   left: -Dimensions.height98,
        //   child: isGuestScreen! ? Image.asset('assets/icons/coins_page_icons/multi_circle.png',height: Dimensions.height200,width: Dimensions.height200,) : const SizedBox.shrink(),),
        child
      ],
    );
  }
}
