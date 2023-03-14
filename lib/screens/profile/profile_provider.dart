import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pak_mega_mcqs/common/model/user_model.dart';
import 'package:pak_mega_mcqs/common/providers/network_error_provider.dart';
import 'package:pak_mega_mcqs/common/providers/points_provider.dart';
import 'package:pak_mega_mcqs/common/utils/app_constants.dart';
import 'package:pak_mega_mcqs/screens/application/provider.dart';
import 'package:provider/provider.dart';

import '../../common/routes/routes_helper.dart';
import '../../common/providers/mcqsdb_provider.dart';

class ProfileProvider with ChangeNotifier{
  FirebaseFirestore? _ref;
  UserModel? _userModel = Hive.box("app_box").get('user_profile');
  UserModel? get userModel => _userModel;
  int _totalScore = 500;
  int get totalScore => _totalScore;
  int _obtainScore = 100;
  int get obtainScore => _obtainScore;
  int _result = 0;
  int get result => _result;
  String _attemptCategoryName = "";
  String get attemptCategoryName => _attemptCategoryName;

  void getUserData(String uid,BuildContext context) async{
    if(_userModel == null){
      _ref = FirebaseFirestore.instance;
      var userData = await _ref!.collection('users').doc(uid).get().timeout(const Duration(seconds: 10));
      if(userData.data() != null){
        _userModel = UserModel.fromJson(userData.data());
        saveUserProfile(_userModel!,context);
        notifyListeners();
        if(_userModel != null){
          context.read<PointsProvider>().getInitPointsFromDb(_userModel!.points!,_userModel!.totalPoints!);
          // context.read<CoinsProvider>().setCoins(_userModel!.coins!);
        }
      }
    }else{
      print(_userModel);
    }
  }

  void saveUserProfile(UserModel userModel,BuildContext context){
    Hive.box('app_box').put("user_profile", userModel).then((value) {
      _userModel = Hive.box("app_box").get('user_profile');
      notifyListeners();
    });
  }



  void updateAllTimeRank(int allTimeRank){
      if(FirebaseAuth.instance.currentUser != null){
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          "allTimeRank":allTimeRank
        });
      }
      _userModel!.setAllTimeRank = allTimeRank;
      Hive.box('app_box').put("user_profile", _userModel);
    notifyListeners();
  }

  void updateWeeklyRank(int weeklyRank){
    if(FirebaseAuth.instance.currentUser != null){
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "weeklyRank":weeklyRank
      });
    }
    _userModel!.setWeeklyRank = weeklyRank;
    notifyListeners();
  }

  void updateTwentyFourHourRank(int twentyFourHourRank){
    if(FirebaseAuth.instance.currentUser != null){
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "twentyFourHourRank":twentyFourHourRank
      });
    }
    _userModel!.setTwentyFourHourRank = twentyFourHourRank;
    notifyListeners();
  }

  void updateUserPicture(String image,String imageType){
    if(FirebaseAuth.instance.currentUser != null){
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "image":image,
        "imageType": imageType
      });
    }
    _userModel!.setImage = image;
    _userModel!.setImageType = imageType;
    notifyListeners();
  }

  void updateIsAdFree(bool isAdFree){
    if(FirebaseAuth.instance.currentUser != null){
      if(_userModel!.loginType == "google" || _userModel!.loginType == "facebook"){
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          "isAdFree": isAdFree,
        }).then((value) {
          _userModel!.setIsAdFree = isAdFree;
          notifyListeners();
        });
      }
    }
  }

  void updateIsOfflineEnable(bool isOfflineEnable){
    if(FirebaseAuth.instance.currentUser != null){
      if(_userModel!.loginType == "google" || _userModel!.loginType == "facebook"){
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          "isOfflineEnable": isOfflineEnable,
        }).then((value) {
          _userModel!.setIsOfflineEnable = isOfflineEnable;
          notifyListeners();
        });
      }
    }
  }

  void getFreeReward(int newCoins){
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      "coins": newCoins
    });
    _userModel!.setCoins = _userModel!.coins! + newCoins;
    notifyListeners();
  }

  Future<void> reduceCoins(BuildContext context) async {
    if(_userModel!.coins! > 0){
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "coins": _userModel!.coins! - 10
      });
      _userModel!.setCoins = _userModel!.coins! - 10;
      notifyListeners();
    }else if(_userModel!.coins! == 0){
      context.read<MCQsDbProvider>().changeState(false);
      context.read<MCQsDbProvider>().resetAllSubCategoriesList();
      context.read<MCQsDbProvider>().resetQuestionsList();
      context.read<ApplicationProvider>().setCurrentPage(0);
      Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You are out of Coins buy coins")));
    }
  }

  void increaseCoins(int result){
    if(result >=80 && result < 90){
      _userModel!.setCoins = _userModel!.coins! + 10;
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "coins": _userModel!.coins! + 10
      });
      notifyListeners();
    }else if(result >=90){
      _userModel!.setCoins = _userModel!.coins! + 20;
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "coins": _userModel!.coins!
      });
      notifyListeners();
    }
  }

  Future<int> getAllTimeRank(String uid) async {
    FirebaseFirestore.instance.collection("users").orderBy("points", descending: true).get().then((value) {
      var usersList = value.docs.map((e) => e.data()).toList();
      if(usersList.isNotEmpty){
        for(int i = 0;i<usersList.length;i++){
          if(uid == UserModel.fromJson(usersList[i]).uid){
            if(FirebaseAuth.instance.currentUser != null){
              FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                "allTimeRank": i + 1
              });
            }
            _userModel!.setAllTimeRank = i + 1;
            Hive.box('app_box').put("user_profile", _userModel);
            notifyListeners();
            updateAllTimeRank(i+1);
            print("-------$i--------");
            return i;
          }
        }
      }
    });
    return 0;
  }

  void setAttemptCategory(String name){
    _attemptCategoryName = name;
    notifyListeners();
  }

  void setObtainScore(){
    if(_result != 0){
      _userModel!.setPoints = _userModel!.points! + _result;
      notifyListeners();
    }
  }

  void setResult(int totalMCQs,int score){
    _result = ((score/totalMCQs)*100).toInt();
    notifyListeners();
  }
  void changeTotalScore(){
    if(_userModel!.points! > _userModel!.totalPoints!){
      _userModel!.setTotalPoints = _userModel!.totalPoints! + 500;
      notifyListeners();
    }
  }

  void updateUserData(){
    int isUpdated = Hive.box(appBox).get(isUpdatedString) ?? 0;
    if(isUpdated == 0){
      Networks(
          onError: (){
            Hive.box(appBox).put(isUpdated, 0);
          },
          onComplete: (){
            FirebaseFirestore.instance.collection("user").doc(_userModel!.uid!).set(_userModel!.toJson()).then((value) {
              Hive.box(appBox).put(isUpdated, 1);
            });
          }
      ).doRequest();
    }
  }
  void checkOldScore(int newPoints,int oldPoints){
    if(oldPoints < newPoints){
      if(FirebaseAuth.instance.currentUser != null){
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"points":newPoints,"totalPoints":_userModel!.totalPoints!});
      }
    }
  }
}