import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pak_mega_mcqs/common/providers/admob_provider.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:provider/provider.dart';

class AdMobWidget extends StatefulWidget {
  const AdMobWidget({Key? key}) : super(key: key);

  @override
  State<AdMobWidget> createState() => _AdMobWidgetState();
}

class _AdMobWidgetState extends State<AdMobWidget> {
  BannerAd? _bannerAd;
  bool isLoaded = false;
  @override
  void initState() {
    setBannerAd();
    super.initState();
  }

  void setBannerAd() async{
    _bannerAd = context.read<AdMobServicesProvider>().showBanner();
    await _bannerAd!.load().then((value) {
      isLoaded = true;
    });
  }
  @override
  void dispose() {
    _bannerAd!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AdMobServicesProvider>(
      builder: (context, value, child) {
        return Visibility(
          visible: value.isBannerAdVisible,
          child: SizedBox(
            width: double.maxFinite,
            height: 60.h,
            child: _bannerAd != null ? isLoaded ? AdWidget(ad: _bannerAd!,) : const SizedBox.shrink() : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
