import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

// Global Variables

String? get bannerId{
  if(Platform.isAndroid){
    return "ca-app-pub-3940256099942544/6300978111";
  }else if(Platform.isIOS){
    return "ca-app-pub-3940256099942544/2934735716";
  }else{
    return null;
  }
}

String? get interstitialId{
  if(Platform.isAndroid){
    return "ca-app-pub-3940256099942544/1033173712";
  }else if(Platform.isIOS){
    return "ca-app-pub-3940256099942544/4411468910";
  }else{
    return null;
  }
}

String? get rewardedId{
  if(Platform.isAndroid){
    return "ca-app-pub-3940256099942544/5224354917";
  }else if(Platform.isIOS){
    return "ca-app-pub-3940256099942544/1712485313";
  }else{
    return null;
  }
}

class AdMobServicesProvider with ChangeNotifier{
  bool _isAdVisible = false;
  bool get isAdVisible => _isAdVisible;

  BannerAd showBanner() {
    var myBanner = BannerAd(
        adUnitId: bannerId!,
        size: AdSize.fullBanner,
        request: const AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              _isAdVisible = true;
              notifyListeners();
            },
            onAdFailedToLoad: (ad,error){
              ad.dispose();
              _isAdVisible= false;
              notifyListeners();
            },
            onAdOpened: (ad){
              // add open
            },
            onAdClosed: (ad){
              // add Close
            }
        )
    );
    return myBanner;
  }


  RewardedAd? loadRewardedAd() {
    RewardedAd? rewardedAd;
    RewardedAd.load(
        adUnitId: rewardedId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad){
            rewardedAd = ad;
            notifyListeners();
            },
          onAdFailedToLoad: (ad){
            rewardedAd = null;
            notifyListeners();
          },
        ));
    return rewardedAd;
  }
}