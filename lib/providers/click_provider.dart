import 'package:flutter/cupertino.dart';

class ClicksProvider with ChangeNotifier{
  bool _viewAll = false;
  bool get viewAll => _viewAll;

  void clickViewAll(bool isLock){
    _viewAll = isLock;
    notifyListeners();
  }
}