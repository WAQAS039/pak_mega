import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class CheckInternet extends ChangeNotifier {
  String status = 'waiting...';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;

  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.mobile) {
      status = "Connected to MobileData";
      notifyListeners();
    } else if (connectionResult == ConnectivityResult.wifi) {
      status = "Connected to Wifi";
      notifyListeners();
    } else {
      status = "Offline";
      notifyListeners();
    }
  }

  void checkRealtimeConnection(BuildContext context) {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      switch (event) {
        case ConnectivityResult.mobile:
          {
            status = "Connected to MobileData";
            notifyListeners();
            // context.read<NetworkErrorProvider>().setNetwork(1,context);
          }
          break;
        case ConnectivityResult.wifi:
          {
            status = "Connected to Wifi";
            notifyListeners();
            // context.read<NetworkErrorProvider>().setNetwork(1,context);
          }
          break;
        default:
          {
            status = 'Offline';
            notifyListeners();
            // context.read<NetworkErrorProvider>().setNetwork(0,context);
          }
          break;
      }
    });
  }
}