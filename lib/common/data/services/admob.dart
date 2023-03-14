import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pak_mega_mcqs/common/providers/admob_provider.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:provider/provider.dart';

class AdMobServices{
  static const String _bannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _bannerIdIOS = 'ca-app-pub-3940256099942544/2934735716';
  static const String _interstitialIdAndroid = "ca-app-pub-3940256099942544/1033173712";
  static const String _interstitialIdIOS = "ca-app-pub-3940256099942544/4411468910";
  static const String _rewardedIdAndroid = "ca-app-pub-3940256099942544/5224354917";
  static const String _rewardedIdIOS = "ca-app-pub-3940256099942544/1712485313";

  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;

  String? get _bannerId{
    if(Platform.isAndroid){
      return _bannerIdAndroid;
    }else if(Platform.isIOS){
      return _bannerIdIOS;
    }else{
      return null;
    }
  }

  String? get _interstitialId{
    if(Platform.isAndroid){
      return _interstitialIdAndroid;
    }else if(Platform.isIOS){
      return _interstitialIdIOS;
    }else{
      return null;
    }
  }

  String? get _rewardedId{
    if(Platform.isAndroid){
      return _rewardedIdAndroid;
    }else if(Platform.isIOS){
      return _rewardedIdIOS;
    }else{
      return null;
    }
  }

  BannerAd loadBannerAd(BuildContext context) {
    var bannerAd = BannerAd(
        adUnitId: _bannerId!,
        size: AdSize(height: 60,width: Dimensions.width.toInt()),
        request: const AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              context.read<AdMobServicesProvider>().setIsBannerAdLoaded(true);
            },
            onAdFailedToLoad: (ad,error){
              ad.dispose();
              context.read<AdMobServicesProvider>().setIsBannerAdLoaded(false);
            },
            onAdOpened: (ad){
              // add open
            },
            onAdClosed: (ad){
              // add Close
            }
        )
    )..load();
    return bannerAd;
  }
}