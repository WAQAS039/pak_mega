import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkProvider{
  StreamController<int> streamController = StreamController<int>();
  NetworkProvider(){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
      int connectionStatus = _checkConnectivityStatus(connectivityResult);
      streamController.add(connectionStatus);
    });
  }
  int _checkConnectivityStatus(ConnectivityResult connectivityResult){
    return connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile ? 1 : 0;
  }
}