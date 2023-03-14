import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pak_mega_mcqs/common/widgets/easy_loading.dart';

// class NetworkErrorProvider extends ChangeNotifier{
//   int network = 0;
//   bool popped = false;
//   void setNetwork(int n,BuildContext context) async{
//     if(n == 1){
//       try{
//         // showLoadingDialog(context);
//         var response = await http.get(Uri.parse("https://www.google.com")).timeout(const Duration(seconds: 5));
//         if(response.statusCode == 200){
//           print('------- ${response.statusCode} ------');
//           EasyLoadingDialog.dismiss(context);
//           network = 1;
//           notifyListeners();
//         }
//       }on HttpException catch(e){
//         print("------------http ${e.message} http-------------");
//         network = 0;
//         notifyListeners();
//       }on TimeoutException catch(e){
//         print("------------Timeout ${e.message} Timeout-------------");
//         network = 0;
//         notifyListeners();
//       }catch (e){
//         print("------------catch $e catch-------------");
//         network = 0;
//         notifyListeners();
//       }
//     }else{
//       network = 0;
//       notifyListeners();
//     }
//   }
//
//   void makeRequest() async {
//     try {
//       Dio dio = Dio();
//       dio.options.connectTimeout = const Duration(seconds: 5); // Set a timeout of 5 seconds
//       Response response = await dio.get('https://www.google.com');
//     } on DioError catch (e) {
//       if (e.type == DioErrorType.connectionTimeout) {
//         print('Request timed out');
//       } else if (e.type == DioErrorType.badResponse) {
//         print('Response timed out');
//       } else if (e.type == DioErrorType.receiveTimeout) {
//         print('Error response received: ${e.response?.statusCode}');
//       } else if (e.type == DioErrorType.cancel) {
//         print('Request was cancelled');
//       } else {
//         print('Other error occurred: ${e.message}');
//       }
//     } catch (e) {
//       print('Unexpected error occurred: ${e.toString()}');
//     }
//   }
// }


class Networks{
  VoidCallback? onComplete;
  VoidCallback? onError;
  String? error;

  Networks({this.onComplete, this.onError,this.error = "something went wrong"});

  void doRequest() async{
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5); // Set a timeout of 5 seconds
      Response response = await dio.get('https://www.google.com');
      if(response.statusCode == 200){
        print('get ');
        onComplete!();
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) {
        onError!();
        error = e.message;
        print('Request timed out');
      } else if (e.type == DioErrorType.badResponse) {
        error = e.message;
        onError!();
        print('Response timed out');
      } else if (e.type == DioErrorType.receiveTimeout) {
        error = e.message;
        onError!();
        print('Error response received: ${e.response?.statusCode}');
        error = e.message;
        onError!();
      } else if (e.type == DioErrorType.cancel) {
        error = e.message;
        onError!();
        print('Request was cancelled');
      } else {
        onError!();
        print('Other error occurred: ${e.message}');
        error = e.message;
      }
    } catch (e) {
      print('Unexpected error occurred: ${e.toString()}');
      error = e.toString();
      onError!();
    }
  }
}