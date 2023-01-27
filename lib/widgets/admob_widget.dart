import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pak_mega_mcqs/providers/admob_provider.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:provider/provider.dart';

class AdMobWidget extends StatefulWidget {
  final BannerAd bannerAd;
  const AdMobWidget({Key? key,required this.bannerAd}) : super(key: key);

  @override
  State<AdMobWidget> createState() => _AdMobWidgetState();
}

class _AdMobWidgetState extends State<AdMobWidget> {
  BannerAd? _bannerAd;
  @override
  void initState() {
    _bannerAd = widget.bannerAd;
    _bannerAd!.load();
    super.initState();
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
          visible: value.isAdVisible,
          child: SizedBox(
            width: double.maxFinite,
            height: Dimensions.height50+10,
            child: AdWidget(ad: _bannerAd!,),
          ),
        );
      },
    );
  }
}
