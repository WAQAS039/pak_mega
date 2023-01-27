import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pak_mega_mcqs/Screens/home/main_screen.dart';
import 'package:pak_mega_mcqs/providers/admob_provider.dart';
import 'package:pak_mega_mcqs/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:provider/provider.dart';

import 'mcqsdb_provider.dart';

class CoinsProvider with ChangeNotifier{
  int _coins = 0;
  int get coins => _coins;


  void setCoins(int coins){
    _coins = coins;
    notifyListeners();
  }
  void getFreeReward(int newCoins,BuildContext context){
    var ad = context.read<AdMobServicesProvider>().loadRewardedAd();
    if(ad != null){
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {},
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          context.read<AdMobServicesProvider>().loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          context.read<AdMobServicesProvider>().loadRewardedAd();
        },
        onAdImpression: (RewardedAd ad) {}
      );
      ad.show(onUserEarnedReward: (ad,reward){
        _coins = _coins + newCoins;
        notifyListeners();
      });
      ad = null;
    }
  }

  void pay(int payCoins){
    _coins = _coins + payCoins;
    notifyListeners();
  }

  Future<void> reduceCoins(BuildContext context) async {
    if(_coins > 0){
      _coins = _coins - 10;
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "coins": _coins
      });
      notifyListeners();
    }else if(_coins == 0){
      context.read<MCQsDbProvider>().changeState(false);
      context.read<MCQsDbProvider>().resetAllSubCategoriesList();
      context.read<MCQsDbProvider>().resetQuestionsList();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const MainScreen(initPosition: 1,)), (route) => false);
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.mainColor,
            title: const Text('You are out of coins',style: TextStyle(fontSize: 20,color: Colors.white),),
            content: Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: (){
                    context.read<CoinsProvider>().getFreeReward(_coins + 20, context);
                    Navigator.of(context).pop();
                  }, child: Row(
                    children:  [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.mainColor,
                        child: Icon(Icons.play_arrow,size: 15,color: Colors.white,),
                      ),
                      const SizedBox(width: 5,),
                      Text("Watch Ad",style: TextStyle(fontSize: Dimensions.height10,color: AppColors.mainColor),),
                    ],
                  )),
                ),
                const SizedBox(width: 5,),
                Expanded(
                  child: ElevatedButton(onPressed: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const MainScreen(initPosition: 0,)), (route) => false);
                  }, child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.mainColor,
                        child: Icon(Icons.play_for_work_outlined,size: 15,color: Colors.white,),
                      ),
                      const SizedBox(width: 5,),
                      Text("Buy Coins",style: TextStyle(fontSize: Dimensions.height10,color: AppColors.mainColor),),
                    ],
                  )),
                ),
              ],
            ),
          );
        },);
      // await showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: const Text('You are out of coins'),
      //         actions: [
      //           ElevatedButton(onPressed: (){
      //             context.read<CoinsProvider>().getFreeReward(_coins + 20, context);
      //           }, child: Row(
      //             children: const [
      //               CircleAvatar(
      //                 radius: 10,
      //                 child: Icon(Icons.play_arrow),
      //               ),
      //               Text("Watch Ad",style: TextStyle(fontSize: 20,color: AppColors.mainColor),),
      //             ],
      //           )),
      //           ElevatedButton(onPressed: (){
      //             Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
      //           }, child: Row(
      //             children: const [
      //               CircleAvatar(
      //                 radius: 10,
      //                 child: Icon(Icons.play_for_work_outlined),
      //               ),
      //               Text("Buy Coins",style: TextStyle(fontSize: 20,color: AppColors.mainColor),),
      //             ],
      //           )),
      //         ],
      //       );
      //     },);
    }
  }

  void increaseCoins(int result){
    print("------------$result---------------");
    if(result >=80 && result < 90){
      _coins = _coins + 10;
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "coins": _coins
      });
      notifyListeners();
    }else if(result >=90){
      _coins = _coins + 20;
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "coins": _coins
      });
      notifyListeners();
    }
  }
}