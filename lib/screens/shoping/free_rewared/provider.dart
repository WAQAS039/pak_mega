import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TimerProvider extends ChangeNotifier {
  Timer? _timer;
  int _secondsRemaining = Hive.box('app_box').get("timer") ?? 8 * 60 * 60; // 8 hours in seconds
  DateTime? _appCloseTime;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec, (Timer timer) {
        if (_secondsRemaining < 1) {
          timer.cancel();
          notifyListeners();
        } else {
          _secondsRemaining -= 1;
          notifyListeners();
        }
      }
    );
  }

  String get timerText {
    final hours = _secondsRemaining ~/ 3600;
    final minutes = (_secondsRemaining % 3600) ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}m${seconds.toString().padLeft(2, '0')}s';
  }

  void stopTimer() {
    if(_timer != null){
      _timer!.cancel();
      notifyListeners();
    }
    Hive.box('app_box').put("timer", _secondsRemaining);
    _appCloseTime = DateTime.now();
    Hive.box('app_box').put("app_close_time", _appCloseTime?.millisecondsSinceEpoch);
  }

  void handleAppClose() {
    final appOpenTime = DateTime.now();
    final appCloseTimeMilliseconds = Hive.box('app_box').get("app_close_time");
    if (appCloseTimeMilliseconds != null) {
      final appCloseTime = DateTime.fromMillisecondsSinceEpoch(appCloseTimeMilliseconds);
      final timeDifference = appOpenTime.difference(appCloseTime);
      final secondsDifference = timeDifference.inSeconds;
      if (secondsDifference >= _secondsRemaining) {
        _secondsRemaining = 0;
      } else {
        _secondsRemaining -= secondsDifference;
      }
      notifyListeners();
      Hive.box('app_box').put("timer", _secondsRemaining);
    }
  }
}


// Future<void> getDifference() async {
//   int savedStartTime = await Hive.box('app_box').get('timer');
//   int timeDifference = DateTime.now().second - savedStartTime;
//   print(timeDifference);
//   // // If time difference is greater than or equal to 8 hours, reset the timer
//   // if (timeDifference >= 8 * 60 * 60 * 1000) {
//   //   _secondsRemaining = 0;
//   //   Hive.box('app_box').put("timer", 0);
//   //   notifyListeners();
//   // } else {
//   //   // Otherwise, update the timer with the remaining time
//   //   _secondsRemaining = savedStartTime + 8 * 60 * 60 * 1000 - timeDifference;
//   //   Hive.box('app_box').put("timer", _secondsRemaining);
//   //   notifyListeners();
//   // }
// }

// TimerModel get timer => _timer ?? TimerModel(timeStarted: 0, timeSpent: 0);
//
// Future<void> loadTimerState() async {
//   final box = await Hive.openBox<TimerModel>('timer');
//   _timer = box.get('timer');
//   if (_timer == null) {
//     _timer = TimerModel(timeStarted: 0, timeSpent: 0);
//   } else if (!_timer!.isTimerRunning()) {
//     _timer!.timeSpent = 0;
//     saveTimerState();
//   }
//   notifyListeners();
// }

// Future<void> saveTimerState() async {
//   final box = await Hive.openBox<TimerModel>('timer');
//   await box.put('timer', timer);
// }

// void startTimer() {
//   _timer!.timeStarted = DateTime.now().millisecondsSinceEpoch;
//   _timerInstance = Timer.periodic(const Duration(seconds: 1), (timer) {
//     _timer!.timeSpent = timer.tick;
//     notifyListeners();
//     if (!_timer!.isTimerRunning()) {
//       timer.cancel();
//       saveTimerState();
//     }
//   });
// }
