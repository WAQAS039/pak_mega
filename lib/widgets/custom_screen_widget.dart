import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pak_mega_mcqs/Widgets/admob_widget.dart';
import 'package:pak_mega_mcqs/Widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/admob_provider.dart';
import '../utils/app_colors.dart';
import '../utils/dimensions.dart';

class CustomScreenWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final double? toolBarHeight;
  final Widget child;
  final Color? appBarColor;
  final Color? scaffoldColor;
  const CustomScreenWidget({Key? key,required this.title,required this.onPress,this.toolBarHeight = 0.0,required this.child, this.appBarColor = AppColors.mainColor,this.scaffoldColor = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // BannerAd bannerAd = context.watch<AdMobServicesProvider>().showBanner();
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        toolbarHeight: toolBarHeight==0.0?Dimensions.height50 + 29:toolBarHeight,
        backgroundColor: appBarColor,
        elevation: 0,
        title: TextWidget(text: title , textColor: Colors.white,fontSize: Dimensions.height25,),
        leading: InkWell(
          onTap: onPress,
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,size: Dimensions.height20,),
        ),
        centerTitle: true,
      ),
      body: child,
      // bottomNavigationBar: AdMobWidget(bannerAd: bannerAd,),
    );
  }
}
