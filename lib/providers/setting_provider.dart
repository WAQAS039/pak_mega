import 'package:flutter/cupertino.dart';

class SettingsProvider extends ChangeNotifier{
  bool? _isSoundON = false;
  bool? get isSoundON => _isSoundON;
  bool _isDark = false;
  bool get isDark => _isDark;

  void setSound(bool value){
    _isSoundON = value;
    notifyListeners();
  }

  void setDark(bool value){
    _isDark = value;
    notifyListeners();
  }
}