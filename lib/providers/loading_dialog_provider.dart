import 'package:flutter/material.dart';

class LoadingDialogProvider extends ChangeNotifier{
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void setLoading(bool loading){
    _isLoading = loading;
    notifyListeners();
  }
}