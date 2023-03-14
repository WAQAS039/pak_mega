import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDark = true;
  bool get isDark => _isDark;
  get getTheme => _themeMode;

  setTheme(themeMode){
    _themeMode = themeMode;
    notifyListeners();
  }

  void setDark(bool dark){
    _isDark = dark;
    notifyListeners();
  }
}
