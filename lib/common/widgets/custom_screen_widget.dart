import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pak_mega_mcqs/common/providers/admob_provider.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_provider.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/admob_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class CustomScreenWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final double? toolBarHeight;
  final Widget child;
  final Color? appBarColor;
  final Color? scaffoldColor;
  final bool? isBack;
  final Widget? coins;
  final bool? isShowAd;
  const CustomScreenWidget({Key? key,required this.title,required this.onPress,this.toolBarHeight = 0.0,required this.child, this.appBarColor = AppColors.mainColor,this.scaffoldColor = Colors.white,this.isBack = true,this.coins = const SizedBox.shrink(),this.isShowAd = true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        toolbarHeight: toolBarHeight==0.0?Dimensions.height50 + 29:toolBarHeight,
        backgroundColor: appBarColor,
        elevation: 0,
        title: TextWidget(text: title , textColor: Colors.white,fontSize: Dimensions.height25,),
        leading: isBack! ? InkWell(
          onTap: onPress,
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,size: Dimensions.height20,),
        ) : const SizedBox.shrink(),
        centerTitle: true,
        actions: [
          coins != const SizedBox.shrink() ? coins! : const SizedBox.shrink()
        ],
      ),
      body: child,
      bottomNavigationBar: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          return isShowAd! ? value.userModel!.isAdFree! ? const AdMobWidget() : const SizedBox.shrink() : const SizedBox.shrink();
        },
      ),
    );
  }
}
