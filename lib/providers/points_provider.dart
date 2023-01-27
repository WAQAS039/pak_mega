import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PointsProvider extends ChangeNotifier{
  int _totalScore = 500;
  int get totalScore => _totalScore;
  int _obtainScore = 100;
  int get obtainScore => _obtainScore;
  int _result = 0;
  int get result => _result;
  String _attemptCategoryName = "";
  String get attemptCategoryName => _attemptCategoryName;

  void setAttemptCategory(String name){
    _attemptCategoryName = name;
    notifyListeners();
  }

  void getInitPointsFromDb(int points,int totalPoints){
    _obtainScore = points;
    _totalScore = totalPoints;
    notifyListeners();
  }
  void setObtainScore(){
    if(_result != 0){
      _obtainScore = _obtainScore + _result;
      notifyListeners();
    }
  }

  void setResult(int totalMCQs,int score){
    _result = ((score/totalMCQs)*100).toInt();
    notifyListeners();
  }
  void changeTotalScore(){
    if(_obtainScore > _totalScore){
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"totalPoints": _totalScore});
      _totalScore = _totalScore + 500;
      notifyListeners();
    }

  }
  void checkOldScore(int newPoints,int oldPoints){
    if(oldPoints < newPoints){
      if(FirebaseAuth.instance.currentUser != null){
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"points":newPoints,"totalPoints":_totalScore});
        FirebaseFirestore.instance
            .collection('leaderboard')
            .doc(FirebaseAuth.instance.currentUser!.uid).update({"points":newPoints,"createdDate":"${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}","createdDateTime":DateTime.now()});
      }
    }
  }
}