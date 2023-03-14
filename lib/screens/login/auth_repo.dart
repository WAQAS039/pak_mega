import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pak_mega_mcqs/common/model/user_model.dart';
import 'package:pak_mega_mcqs/common/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/common/widgets/easy_loading.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AuthRepo {
  FirebaseFirestore? _ref;
  signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>['email']).signIn();
      if (googleUser != null) {
        Future.delayed(Duration.zero,()=>EasyLoadingDialog.show(context: context,radius: 20.r,));
        final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
        try {
          await FirebaseAuth.instance.signInWithCredential(credential).then((userCredentials) async {
            _ref = FirebaseFirestore.instance;
            // to check weather user exist in the existing list of firStore
            int counter = 0;
            var doc = await _ref!.collection("users").get();
            List<UserModel> usersList = doc.docs.map((e) => UserModel.fromJson(e.data())).toList();
            if (usersList.isNotEmpty) {
              for (int index = 0; index < usersList.length; index++) {
                counter++;
                if (usersList[index].uid == userCredentials.user!.uid) {
                  Future.delayed(Duration.zero,(){
                    context.read<ProfileProvider>().saveUserProfile(usersList[index],context);
                    EasyLoadingDialog.dismiss(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
                  });
                  break;
                }
                // user not found
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
                    createDate: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      isAdFree: false,
                      isOfflineEnable: false
                  );
                  _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
                    context.read<ProfileProvider>().saveUserProfile(userModel,context);
                    EasyLoadingDialog.dismiss(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
                  });
                }
              }
              // if no user exist in fireStore
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
                  createdTime: userCredentials.user!.metadata.creationTime,
                  createDate: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                    isAdFree: false, isOfflineEnable: false
                );
                _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
                  context.read<ProfileProvider>().saveUserProfile(userModel,context);
                  EasyLoadingDialog.dismiss(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
                });
              }
          });
        } on FirebaseAuthException catch (e) {
          Future.delayed(Duration.zero,()=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Error"))));
        }
      }else{
        Future.delayed(Duration.zero,()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User has Cancelled Login"))));
      }
    } on PlatformException catch (e) {
      if (e.code == "network_error") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Internet')));
      }
    }
  }

  signInWithFacebookAuth(BuildContext context) async {
    LoginResult loginResult = await FacebookAuth.instance.login(permissions: ["email", "public_profile", "user_friends"]);
    if (loginResult.accessToken != null) {
      Future.delayed(Duration.zero,()=>EasyLoadingDialog.show(context: context,radius: 20.r,));
      // to get user profile information
      var data = await FacebookAuth.instance.getUserData();
      try{
        final OAuthCredential authCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(authCredential).then((userCredentials) async {
          _ref = FirebaseFirestore.instance;
          // to check weather user exist in the existing list of firStore
          int counter = 0;
          var doc = await _ref!.collection("users").get();
          List<UserModel> usersList = doc.docs.map((e) => UserModel.fromJson(e.data())).toList();
          if (usersList.isNotEmpty) {
            for (int index = 0; index < usersList.length; index++) {
              counter++;
              if (usersList[index].uid == userCredentials.user!.uid) {
                Future.delayed(Duration.zero,(){
                  context.read<ProfileProvider>().saveUserProfile(usersList[index],context);
                  Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
                });
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
                      createDate: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      isAdFree: false, isOfflineEnable: false
                  );
                  _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
                    context.read<ProfileProvider>().saveUserProfile(userModel,context);
                    EasyLoadingDialog.dismiss(context);
                    Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
                  });
                }
              }else{
                _ref = FirebaseFirestore.instance;
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
                    createDate: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                    isAdFree: false, isOfflineEnable: false
                );
                _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
                  context.read<ProfileProvider>().saveUserProfile(userModel,context);
                  EasyLoadingDialog.dismiss(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
                });
              }
            }
          }
        });
      }on FirebaseAuthException catch (e) {
        Future.delayed(Duration.zero,(){
          EasyLoadingDialog.dismiss(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
        });
      }
    } else {
      Future.delayed(Duration.zero,()=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loginResult.message!))));
    }
  }

  signInWithAnonymous(BuildContext context, String userName) async {
    try {
      EasyLoadingDialog.show(context: context,radius: 20.r);
      await FirebaseAuth.instance.signInAnonymously().then((userCredentials) {
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
          createDate: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
            isAdFree: false, isOfflineEnable: false
        );
        _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) async{
          context.read<ProfileProvider>().saveUserProfile(userModel,context);
          EasyLoadingDialog.dismiss(context);
          Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
          context.read<ProfileProvider>().getAllTimeRank(userModel.uid!);
        });
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          EasyLoadingDialog.dismiss(context);
          break;
        case "network-request-failed":
          EasyLoadingDialog.dismiss(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No Internet")));
          break;
        default:
          print("Unknown error.");
          EasyLoadingDialog.dismiss(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unknown error.")));
      }
    }
  }

  Future<void> linkAnonymousUserWithGoogle(String name, BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>['email']).signIn();
    if(googleUser != null){
      Future.delayed(Duration.zero,()=>EasyLoadingDialog.show(context: context,radius: 20.r));
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
            createDate: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              isAdFree: false, isOfflineEnable: false
          );
          _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
            context.read<ProfileProvider>().saveUserProfile(userModel,context);
            EasyLoadingDialog.dismiss(context);
            Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
          });
        });
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "provider-already-linked":
            print("The provider has already been linked to the user.");
            Future.delayed(Duration.zero,(){
              EasyLoadingDialog.dismiss(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("already linked")));
            });
            break;
          case "invalid-credential":
            print("The provider's credential is not valid.");
            Future.delayed(Duration.zero,()=>EasyLoadingDialog.dismiss(context));
            break;
          case "credential-already-in-use":
            print("The account corresponding to the credential already exists, "
                "or is already linked to a Firebase User.");
            Future.delayed(Duration.zero,(){
              EasyLoadingDialog.dismiss(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("already linked")));
            });
            break;
        // See the API reference for the full list of error codes.
          default:
            print("Unknown error.");
            Future.delayed(Duration.zero,(){
              EasyLoadingDialog.dismiss(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unknown error.")));
            });
        }
      }
    }else{
      Future.delayed(Duration.zero,()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Cancel Login"))));
    }
  }

  Future<void> linkAnonymousUserWithFacebook(String name,BuildContext context) async {
    LoginResult loginResult = await FacebookAuth.instance.login(permissions: ["email", "public_profile", "user_friends"]);
    if(loginResult.accessToken != null){
      Future.delayed(Duration.zero,()=>EasyLoadingDialog.show(context: context,radius: 20.r));
      var data = await FacebookAuth.instance.getUserData();
      final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      try {
        await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(credential)
            .then((userCredentials) async {
          _ref = FirebaseFirestore.instance;
          UserModel userModel = UserModel(
            name: name,
            email: userCredentials.user!.email,
            image: data["picture"]['data']['url'],
            imageType: "network",
            uid: userCredentials.user!.uid,
            points: 100,
            totalPoints: 500,
            allTimeRank: await ProfileProvider().getAllTimeRank(userCredentials.user!.uid),
            weeklyRank: 0,
            twentyFourHourRank: 0,
            coins: 100,
            loginType: "google",
            createdTime: userCredentials.user!.metadata.creationTime,
            createDate: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              isAdFree: false, isOfflineEnable: false
          );

          _ref!.collection("users").doc(userCredentials.user!.uid).set(userModel.toJson()).then((value) {
            context.read<ProfileProvider>().saveUserProfile(userModel,context);
            Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
          });
        });
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "provider-already-linked":
            Future.delayed(Duration.zero,(){
              EasyLoadingDialog.dismiss(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("already linked")));
            });
            print("The provider has already been linked to the user.");
            break;
          case "invalid-credential":
            Future.delayed(Duration.zero,(){
              EasyLoadingDialog.dismiss(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("invalid already")));
            });
            print("The provider's credential is not valid.");
            break;
          case "credential-already-in-use":
            Future.delayed(Duration.zero,(){
              EasyLoadingDialog.dismiss(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("already linked")));
            });
            print("The account corresponding to the credential already exists,"
                "or is already linked to a Firebase User.");
            break;
        // See the API reference for the full list of error codes.
          default:
            Future.delayed(Duration.zero,(){
              EasyLoadingDialog.dismiss(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unknown error")));
            });
            print("Unknown error.");
        }
      }
    }else{
      Future.delayed(Duration.zero,()=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loginResult.message!))));
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
    final FirebaseAuth auth = FirebaseAuth.instance;
    _ref = FirebaseFirestore.instance;
    _ref!.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).delete();
    await auth.currentUser!.delete();
  }

  void getAllTimeRanks(){

  }
}
