import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pak_mega_mcqs/model/leader_board_model.dart';
import 'package:pak_mega_mcqs/model/user_model.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/mcqs_db_model.dart';
import '../../model/tests_model.dart';
import '../../providers/mcqsdb_provider.dart';
import '../../routes/routes_helper.dart';
import 'mcqsdb_repo.dart';

class AuthRepo {
  SharedPreferences? _sharedPreferences;
  FirebaseFirestore? _ref;
  bool isLoading = true;

  signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>['email']).signIn();
      if (googleUser != null) {
        // showLoadingDialog(context, 1);
        _showLoadingDialog(context);
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        try {
          await FirebaseAuth.instance.signInWithCredential(credential).then((userCredentials) async {
            _ref = FirebaseFirestore.instance;
            int counter = 0;
            var doc = await _ref!.collection("users").get();
            List<UserModel> usersList = doc.docs.map((e) => UserModel.fromJson(e.data())).toList();
            if (usersList.isNotEmpty) {
              for (int index = 0; index < usersList.length; index++) {
                counter++;
                if (usersList[index].uid == userCredentials.user!.uid) {
                  Navigator.of(context).pushReplacementNamed(RouteHelper.mainScreen);
                  break;
                }
                if (counter == usersList.length) {
                  _ref = FirebaseFirestore.instance;
                  UserModel userModel = UserModel(
                    name: userCredentials.user!.displayName,
                    email: userCredentials.user!.email,
                    image: userCredentials.user!.photoURL,
                    imageType: "network",
                    uid: userCredentials.user!.uid,
                    points: 100,
                    totalPoints: 500,
                    allTimeRank: 0,
                    weeklyRank: 0,
                    twentyFourHourRank: 0,
                    coins: 100,
                    loginType: "google",
                    createdTime: userCredentials.user!.metadata.creationTime,
                  );
                  LeaderBoardModel leaderBoardModel = LeaderBoardModel(
                    name: userCredentials.user!.displayName,
                    image: userCredentials.user!.photoURL,
                    imageType: "network",
                    points: 100,
                    uid: userCredentials.user!.uid,
                    time: DateTime.now(),
                    date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                  );
                  _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
                    _ref!.collection("leaderboard").doc(userCredentials.user!.uid).set(leaderBoardModel.toJson()).then((value) {
                      Navigator.of(context).pushReplacementNamed(
                        RouteHelper.mainScreen,
                      );
                    });
                  });
                }
              }
            }else{
                _ref = FirebaseFirestore.instance;
                UserModel userModel = UserModel(
                  name: userCredentials.user!.displayName,
                  email: userCredentials.user!.email,
                  image: userCredentials.user!.photoURL,
                  imageType: "network",
                  uid: userCredentials.user!.uid,
                  points: 100,
                  totalPoints: 500,
                  allTimeRank: 0,
                  weeklyRank: 0,
                  twentyFourHourRank: 0,
                  coins: 100,
                  loginType: "google",
                  createdTime: userCredentials.user!.metadata.creationTime,);
                LeaderBoardModel leaderBoardModel = LeaderBoardModel(
                    name: userCredentials.user!.displayName,
                    image: userCredentials.user!.photoURL,
                    imageType: "network",
                    points: 100, uid: userCredentials.user!.uid,
                    time: DateTime.now(),
                    date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
                _ref!.collection("leaderboard").doc(userCredentials.user!.uid).set(leaderBoardModel.toJson()).then((value) {
                  _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
                    Navigator.of(context).pushReplacementNamed(RouteHelper.mainScreen);
                  });
                });
                // showLoadingDialog(context,1);
              }
          });
        } on FirebaseAuthException catch (e) {
          print("********${e.code}*********");
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User has Cancelled Login")));
      }
    } on PlatformException catch (e) {
      if (e.code == "network_error") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No Internet')));
      }
    }
  }

  signInWithFacebookAuth(BuildContext context) async {
    LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ["email", "public_profile", "user_friends"]);
    if (loginResult.accessToken != null) {
      _showLoadingDialog(context);
      var data = await FacebookAuth.instance.getUserData();
      final OAuthCredential authCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      return FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .then((userCredentials) async {
        _ref = FirebaseFirestore.instance;
        int counter = 0;
        var doc = await _ref!.collection("users").get();
        List<UserModel> usersList = doc.docs.map((e) => UserModel.fromJson(e.data())).toList();
        if (usersList.isNotEmpty) {
          for (int index = 0; index < usersList.length; index++) {
            counter++;
            if (usersList[index].uid == userCredentials.user!.uid) {
              Navigator.of(context).pushReplacementNamed(RouteHelper.mainScreen);
              break;
            }
            if (counter == usersList.length) {
              _ref = FirebaseFirestore.instance;
              if(FirebaseAuth.instance.currentUser != null){
                UserModel userModel = UserModel(
                  name: userCredentials.user!.displayName,
                  email: userCredentials.user!.email,
                  image: data["picture"]['data']['url'],
                  imageType: "network",
                  uid: userCredentials.user!.uid,
                  points: 100,
                  totalPoints: 500,
                  allTimeRank: 0,
                  weeklyRank: 0,
                  twentyFourHourRank: 0,
                  coins: 100,
                  loginType: "facebook",
                  createdTime: userCredentials.user!.metadata.creationTime,
                );
                LeaderBoardModel leaderBoardModel = LeaderBoardModel(
                  name: userCredentials.user!.displayName,
                  image: data["picture"]['data']['url'],
                  imageType: "network",
                  points: 100,
                  uid: userCredentials.user!.uid,
                  time: DateTime.now(),
                  date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                );
                _ref!.collection("leaderboard").doc(userCredentials.user!.uid).set(leaderBoardModel.toJson()).then((value) {
                  _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
                    Navigator.of(context).pushReplacementNamed(
                      RouteHelper.mainScreen,
                    );
                  });
                });
              }
            }
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loginResult.message!)));
    }
  }

  signInWithAnonymous(BuildContext context, String userName) async {
    try {
      _showLoadingDialog(context);
      await FirebaseAuth.instance.signInAnonymously().then((userCredentials) async {
        _ref = FirebaseFirestore.instance;
        UserModel userModel = UserModel(
          name: userName,
          email: "",
          image: "assets/images/guest_images/0.png",
          imageType: "asset",
          uid: userCredentials.user!.uid,
          points: 100,
          totalPoints: 500,
          allTimeRank: 0,
          weeklyRank: 0,
          twentyFourHourRank: 0,
          coins: 100,
          loginType: "guest",
          createdTime: userCredentials.user!.metadata.creationTime,
        );
        LeaderBoardModel leaderBoardModel = LeaderBoardModel(
          name: userName,
          image: "assets/images/guest_images/0.png",
          imageType: "asset",
          points: 100,
          uid: userCredentials.user!.uid,
          time: DateTime.now(),
          date:
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        );
        _ref!
            .collection("leaderboard")
            .doc(userCredentials.user!.uid)
            .set(leaderBoardModel.toJson())
            .then((value) {
          _ref!
              .collection("users")
              .doc(userCredentials.user!.uid)
              .set(userModel.toJson())
              .then((value) {
            Navigator.of(context).pushReplacementNamed(
              RouteHelper.mainScreen,
            );
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        case "network-request-failed":
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No Internet")));
          break;
        default:
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unknown error.")));
          print("Unknown error.");
      }
    }
  }

  Future<void> linkAnonymousUserWithGoogle(String name, BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>['email']).signIn();
    if(googleUser != null){
      _showLoadingDialog(context);
      final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      try {
        await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(credential)
            .then((userCredentials) {
          _ref = FirebaseFirestore.instance;
          UserModel userModel = UserModel(
            name: name,
            email: userCredentials.user!.email,
            image: "assets/images/guest_images/0.png",
            imageType: "asset",
            uid: userCredentials.user!.uid,
            points: 100,
            totalPoints: 500,
            allTimeRank: 0,
            weeklyRank: 0,
            twentyFourHourRank: 0,
            coins: 100,
            loginType: "google",
            createdTime: userCredentials.user!.metadata.creationTime,
          );
          LeaderBoardModel leaderBoardModel = LeaderBoardModel(
            name: name,
            image: "assets/images/guest_images/0.png",
            imageType: "asset",
            points: 100,
            uid: userCredentials.user!.uid,
            time: DateTime.now(),
            date:
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          );
          _ref!.collection("leaderboard").doc(userCredentials.user!.uid).set(leaderBoardModel.toJson()).then((value) {
            _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
              Navigator.of(context).pushReplacementNamed(RouteHelper.mainScreen);
            });
          });
        });
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "provider-already-linked":
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("already linked")));
            print("The provider has already been linked to the user.");
            break;
          case "invalid-credential":
            print("The provider's credential is not valid.");
            break;
          case "credential-already-in-use":
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("already linked")));
            print("The account corresponding to the credential already exists, "
                "or is already linked to a Firebase User.");
            break;
        // See the API reference for the full list of error codes.
          default:
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unknown error")));
            print("Unknown error.");
        }
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Cancel Login")));
    }
  }

  Future<void> linkAnonymousUserWithFacebook(String name,BuildContext context) async {
    LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ["email", "public_profile", "user_friends"]);
    if(loginResult.accessToken != null){
      _showLoadingDialog(context);
      var data = await FacebookAuth.instance.getUserData();
      final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      try {
        await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(credential)
            .then((userCredentials) {
          _ref = FirebaseFirestore.instance;
          UserModel userModel = UserModel(
            name: name,
            email: userCredentials.user!.email,
            image: data["picture"]['data']['url'],
            imageType: "network",
            uid: userCredentials.user!.uid,
            points: 100,
            totalPoints: 500,
            allTimeRank: 0,
            weeklyRank: 0,
            twentyFourHourRank: 0,
            coins: 100,
            loginType: "google",
            createdTime: userCredentials.user!.metadata.creationTime,
          );
          LeaderBoardModel leaderBoardModel = LeaderBoardModel(
            name: name,
            image: data["picture"]['data']['url'],
            imageType: "network",
            points: 100,
            uid: userCredentials.user!.uid,
            time: DateTime.now(),
            date:
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          );
          _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
            _ref!.collection("leaderboard").doc(userCredentials.user!.uid).set(leaderBoardModel.toJson()).then((value) {
              Navigator.of(context).pushReplacementNamed(RouteHelper.mainScreen);
            });
          });
        });
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "provider-already-linked":
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("already linked")));
            print("The provider has already been linked to the user.");
            break;
          case "invalid-credential":
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("invalid already")));
            print("The provider's credential is not valid.");
            break;
          case "credential-already-in-use":
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("already linked")));
            print("The account corresponding to the credential already exists,"
                "or is already linked to a Firebase User.");
            break;
        // See the API reference for the full list of error codes.
          default:
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unknown error")));
            print("Unknown error.");
        }
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loginResult.message!)));
    }
  }

  // for Facebook Only
  void signOutFromFacebook() async {
    await FacebookAuth.instance.logOut();
    await FirebaseAuth.instance.signOut();
  }

  signOutFromGoogle() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  signOutFromGuest() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final FirebaseAuth auth = FirebaseAuth.instance;
    _ref = FirebaseFirestore.instance;
    _ref!
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    _ref!
        .collection('leaderboard')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    await auth.currentUser!.delete();
    await auth.signOut();
  }

  void changeLoginState(String state) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences!.setString('loginStatus', state);
  }

  // void checkDb(BuildContext context) async {
  //   SharedPreferences sharePreferences = await SharedPreferences.getInstance();
  //   int? status = sharePreferences.getInt('dbStatus');
  //   if(status == null){
  //     print("from Auth $status");
  //   }
  //   if (status == null) {
  //     MCQsLDbRepo.saveMCQsDbInLocalDb(context);
  //   } else if (status == 1) {
  //     context.read<MCQsDbProvider>().resetMCQsList();
  //     context.read<MCQsDbProvider>().resetCategoriesList();
  //     context.read<MCQsDbProvider>().resetAllSubCategoriesList();
  //     context.read<MCQsDbProvider>().resetQuestionsList();
  //     context.read<MCQsDbProvider>().resetTestList();
  //     List<TestModel> testList = await MCQsLDbRepo.getTestsFromLocalDb();
  //     context.read<MCQsDbProvider>().addTestList(tests: testList);
  //     List<MCQsDbModel> mCQSList = await MCQsLDbRepo.getCategoriesFromLocalDb();
  //     context.read<MCQsDbProvider>().addMCQsList(mCQsList: mCQSList);
  //     var categories = context.read<MCQsDbProvider>().categories;
  //     if (categories.isEmpty) {
  //       print('calling from main');
  //       for (int i = 0; i < mCQSList.length; i++) {
  //         MCQsDbModel mcQsDbModel = mCQSList[i];
  //         context.read<MCQsDbProvider>().addCategoriesList(categoriesList: mcQsDbModel.categoriesList!);
  //       }
  //     }
  //   }
  // }

  Future<void> showLoadingDialog(BuildContext context, int time) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          title: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          ),
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          content: Container(
            height: Dimensions.height80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(color: Colors.blue,),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTimeoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Request Timeout'),
          content: const Text('The server is taking too long to respond. Please try again later.'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK',style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  Future _makeRequest(BuildContext context) async {
    try {
      _showLoadingDialog(context);
      await Future.delayed(const Duration(seconds: 1), () {

      }).timeout(const Duration(seconds: 5), onTimeout: () {
        throw TimeoutException("Request Timeout");
      });
    } catch (e) {
      Navigator.pop(context);
      _showTimeoutDialog(context);
    }
  }
}
