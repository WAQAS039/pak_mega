import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pak_mega_mcqs/common/model/user_model.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../common/model/leader_board_model.dart';

class LeaderBoardProvider extends ChangeNotifier {
  List<UserModel> _leaderBoardList = [];
  List<UserModel> get leaderBoardList => _leaderBoardList;
  List<UserModel> _allListWithoutTopThree = [];
  List<UserModel> get allListWithoutTopThree => _allListWithoutTopThree;

  void getAllTimeLeaderBoardList(BuildContext context) {
    var userModel = context.read<ProfileProvider>().userModel;
    FirebaseFirestore.instance.collection("users").orderBy("points", descending: true).get().then((value) {
      var list = value.docs.map((e) => e.data()).toList();
      if(list.isNotEmpty){
        for(int i = 0;i<list.length;i++){
          if(userModel!.uid == UserModel.fromJson(list[i]).uid){
            context.read<ProfileProvider>().updateAllTimeRank(i+1);
            break;
          }
        }
      }
      if (value.docs.isNotEmpty) {
        resetAllLists();
        for (var map in value.docs) {
          _leaderBoardList.add(UserModel.fromJson(map.data()));
          notifyListeners();
        }
      }
      if(_leaderBoardList.length > 3){
        for(int i = 3;i<_leaderBoardList.length;i++){
          allListWithoutTopThree.add(_leaderBoardList[i]);
          notifyListeners();
        }
      }
    });
  }

  void getTwentyFourHourList(BuildContext context) {
    var userModel = context.read<ProfileProvider>().userModel;
    resetAllLists();
    FirebaseFirestore.instance.collection("users")
        .where('createdDate', isEqualTo: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}")
        .orderBy("points", descending: true)
        .get().then((value) {
          var list = value.docs.map((e) => e.data()).toList();
          if(list.isNotEmpty){
            for(int i = 0;i<list.length;i++){
              if(userModel!.uid == UserModel.fromJson(list[i]).uid){
                context.read<ProfileProvider>().updateTwentyFourHourRank(i+1);
                break;
              }else{
                context.read<ProfileProvider>().updateTwentyFourHourRank(0);
              }
            }
          }
          if (value.docs.isNotEmpty) {
            for (var doc in value.docs) {
              _leaderBoardList.add(UserModel.fromJson(doc.data()));
              notifyListeners();
            }
            if(_leaderBoardList.length > 3){
              for(int i = 3;i<_leaderBoardList.length;i++){
                allListWithoutTopThree.add(_leaderBoardList[i]);
                notifyListeners();
              }
            }
          }
    });
  }
  void getOneWeekLeaderBoardList(BuildContext context) {
    var userModel = context.read<ProfileProvider>().userModel;
    resetAllLists();
    FirebaseFirestore.instance.collection("users")
        .where('createdTime', isGreaterThan: DateTime.now().subtract(const Duration(days: 7)))
        .where('createdTime', isLessThan: DateTime.now())
        .orderBy("createdTime",)
        .orderBy("points", descending: true)
        .get().then((value) {
          var list = value.docs.map((e) => e.data()).toList();
          if(list.isNotEmpty){
            for(int i = 0;i<list.length;i++){
              if(userModel!.uid == UserModel.fromJson(list[i]).uid){
                context.read<ProfileProvider>().updateWeeklyRank(i+1);
                break;
              }else{
                context.read<ProfileProvider>().updateWeeklyRank(0);
              }
            }
          }
          if (value.docs.isNotEmpty) {
            for (var doc in value.docs) {
              _leaderBoardList.add(UserModel.fromJson(doc.data()));
              // _leaderBoardListOneWeek.add(LeaderBoardModel.fromJson(doc.data()));
              _leaderBoardList.sort((a, b) => b.points!.compareTo(a.points!));
              notifyListeners();
            }
            if(_leaderBoardList.length > 3){
              for(int i = 3;i<_leaderBoardList.length;i++){
                allListWithoutTopThree.add(_leaderBoardList[i]);
                notifyListeners();
              }
            }
      }
    });
  }

  void resetAllLists() {
    _leaderBoardList = [];
    _allListWithoutTopThree = [];
    notifyListeners();
  }

  void getUserRank(){

  }
}