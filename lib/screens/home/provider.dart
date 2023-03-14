import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier{
  bool _viewAll = false;
  bool get viewAll => _viewAll;

  void setViewAll(bool value){
    _viewAll = value;
    notifyListeners();
  }
}