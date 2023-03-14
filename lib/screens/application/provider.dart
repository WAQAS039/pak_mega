import 'package:flutter/material.dart';

class ApplicationProvider extends ChangeNotifier{
  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _drawerCurrentIndex = 0;
  int get drawerCurrentIndex => _drawerCurrentIndex;

  void setCurrentPage(int index){
    _currentPage = index;
    notifyListeners();
  }

  void setDrawerCurrent(int index){
    _drawerCurrentIndex = index;
    notifyListeners();
  }
}