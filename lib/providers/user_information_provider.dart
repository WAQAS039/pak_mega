import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/model/user_model.dart';
import 'package:pak_mega_mcqs/providers/coins_provider.dart';
import 'package:pak_mega_mcqs/providers/points_provider.dart';
import 'package:provider/provider.dart';

import '../data/repo/user_photo_repo.dart';

class UserInformationProvider with ChangeNotifier{
  String? _imagePath;
  String? get imagePath => _imagePath;
  FirebaseFirestore? _ref;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  void getProfileImage({required String userName}) async{
    _imagePath = await UserInfoRepo().getImage(userName);
    notifyListeners();
  }

  void getUserData(String uid,BuildContext context) async{
    _ref = FirebaseFirestore.instance;
    var userData = await _ref!.collection('users').doc(uid).get();
    if(userData.data() != null){
      _userModel = UserModel.fromJson(userData.data());
      notifyListeners();
      if(_userModel != null){
        context.read<PointsProvider>().getInitPointsFromDb(_userModel!.points!,_userModel!.totalPoints!);
        context.read<CoinsProvider>().setCoins(_userModel!.coins!);
      }
    }
  }

  void updateAllTimeRank(int allTimeRank){
      if(FirebaseAuth.instance.currentUser != null){
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          "allTimeRank":allTimeRank
        });
      }
      _userModel!.setAllTimeRank = allTimeRank;
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
      FirebaseFirestore.instance.collection('leaderboard').doc(FirebaseAuth.instance.currentUser!.uid).update({
        "image":image,
        "imageType": imageType
      });
    }
    _userModel!.setImage = image;
    _userModel!.setImageType = imageType;
    notifyListeners();
  }


  void reduceCoins(){
    _userModel!.setCoins = _userModel!.coins! - 10;
    notifyListeners();
  }
}