import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pak_mega_mcqs/providers/user_information_provider.dart';
import 'package:provider/provider.dart';

import '../model/leader_board_model.dart';

class LeaderBoardProvider extends ChangeNotifier {
  List<LeaderBoardModel> _leaderBoardList = [];
  List<LeaderBoardModel> get leaderBoardList => _leaderBoardList;
  List<LeaderBoardModel> _allListWithoutTopThree = [];
  List<LeaderBoardModel> get allListWithoutTopThree => _allListWithoutTopThree;

  void getAllTimeLeaderBoardList(BuildContext context) {
    var userModel = context.read<UserInformationProvider>().userModel;
    FirebaseFirestore.instance.collection("leaderboard").orderBy("points", descending: true).get().then((value) {
      var list = value.docs.map((e) => e.data()).toList();
      if(list.isNotEmpty){
        for(int i = 0;i<list.length;i++){
          if(userModel!.uid == LeaderBoardModel.fromJson(list[i]).uid){
            context.read<UserInformationProvider>().updateAllTimeRank(i+1);
            break;
          }
        }
      }
      if (value.docs.isNotEmpty) {
        resetAllLists();
        // _leaderBoardList = [];
        for (var map in value.docs) {
          _leaderBoardList.add(LeaderBoardModel.fromJson(map.data()));
          // _leaderBoardListAllTimes.add(LeaderBoardModel.fromJson(map.data()));
          notifyListeners();
        }
      }
      // for(int i = 0;i<_leaderBoardList.length;i++){
      //   print("all Times ${_leaderBoardList[i].name}");
      // }
      if(_leaderBoardList.length > 3){
        for(int i = 3;i<_leaderBoardList.length;i++){
          allListWithoutTopThree.add(_leaderBoardList[i]);
          notifyListeners();
        }
      }
      // for(int i = 0;i<_allListWithoutTopThree.length;i++){
      //   print("without ${_allListWithoutTopThree[i].name}");
      // }
    });
  }

  void getTwentyFourHourList(BuildContext context) {
    var userModel = context.read<UserInformationProvider>().userModel;
    resetAllLists();
    FirebaseFirestore.instance.collection("leaderboard")
        .where('createdDate', isEqualTo: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}")
        .orderBy("points", descending: true)
        .get().then((value) {
          var list = value.docs.map((e) => e.data()).toList();
          if(list.isNotEmpty){
            for(int i = 0;i<list.length;i++){
              if(userModel!.uid == LeaderBoardModel.fromJson(list[i]).uid){
                context.read<UserInformationProvider>().updateTwentyFourHourRank(i+1);
                break;
              }
            }
          }
          if (value.docs.isNotEmpty) {
            for (var doc in value.docs) {
              _leaderBoardList.add(LeaderBoardModel.fromJson(doc.data()));
              // _leaderBoardListTwentyFourHour.add(LeaderBoardModel.fromJson(doc.data()));
              notifyListeners();
            }
            // for(int i = 0;i<_leaderBoardList.length;i++){
            //   print("four ${_leaderBoardList[i].name}");
            // }

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
    var userModel = context.read<UserInformationProvider>().userModel;
    resetAllLists();
    FirebaseFirestore.instance.collection("leaderboard")
        .where('createdDateTime', isGreaterThan: DateTime.now().subtract(const Duration(days: 7)))
        .where('createdDateTime', isLessThan: DateTime.now())
        .orderBy("createdDateTime",)
        .orderBy("points", descending: true)
        .get().then((value) {
          var list = value.docs.map((e) => e.data()).toList();
          if(list.isNotEmpty){
            for(int i = 0;i<list.length;i++){
              if(userModel!.uid == LeaderBoardModel.fromJson(list[i]).uid){
                context.read<UserInformationProvider>().updateWeeklyRank(i+1);
                break;
              }
            }
          }
          if (value.docs.isNotEmpty) {
            for (var doc in value.docs) {
              _leaderBoardList.add(LeaderBoardModel.fromJson(doc.data()));
              // _leaderBoardListOneWeek.add(LeaderBoardModel.fromJson(doc.data()));
              _leaderBoardList.sort((a, b) => b.points!.compareTo(a.points!));
              notifyListeners();
            }
            if(_leaderBoardList.length > 3){
              for(int i = 3;i<_leaderBoardList.length;i++){
                allListWithoutTopThree.add(_leaderBoardList[i]);
                notifyListeners();
              }
              // for(int i = 0;i<leaderBoardList.length;i++){
              //   print(_leaderBoardList[i].points);
              // }
            }
      }
    });
  }

  // void resetTwentyFourHourList() {
  //   _leaderBoardListTwentyFourHour = [];
  //   notifyListeners();
  // }
  //
  // void resetOneWeekList() {
  //   _leaderBoardListOneWeek = [];
  //   notifyListeners();
  // }

  void resetAllLists() {
    _leaderBoardList = [];
    _allListWithoutTopThree = [];
    notifyListeners();
  }
}