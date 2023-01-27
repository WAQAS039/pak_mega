import 'package:flutter/cupertino.dart';
import 'package:pak_mega_mcqs/data/repo/auth_repo.dart';
import 'package:pak_mega_mcqs/routes/routes_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  void loginInWithGoogle(BuildContext context) {
    AuthRepo().signInWithGoogle(context);
  }

  void loginInWithFacebook(BuildContext context){
    AuthRepo().signInWithFacebookAuth(context);
  }

  void loginWithAnonymous(BuildContext context, String userName){
    AuthRepo().signInWithAnonymous(context,userName);
  }
  void logoutFromFacebook(){
    AuthRepo().signOutFromFacebook();
  }

  void logoutFromGoogle(){
    AuthRepo().signOutFromGoogle();
  }

  void logoutFromGuest(){
    AuthRepo().signOutFromGuest();
  }

  void changeLoginState(String state){
    AuthRepo().changeLoginState(state);
  }
  Future<bool> isAlreadyLogin() async{
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    String? loginStatus = sharedPreferences.getString("loginStatus");
    print("status $loginStatus");
    if(loginStatus == "login"){
      _isLogin = true;
      notifyListeners();
      return true;
    }else{
      _isLogin = false;
      notifyListeners();
      return false;
    }
  }

  // void initLoginKeys(){
  //   AuthRepo().initLoginKeys();
  // }
}