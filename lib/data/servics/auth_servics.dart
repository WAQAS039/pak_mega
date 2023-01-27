// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:pak_mega_mcqs/routes/routes_helper.dart';
// import 'package:pak_mega_mcqs/screens/home/main_screen.dart';
// import 'package:pak_mega_mcqs/screens/login/login_page.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class AuthServicesProvider with ChangeNotifier {
//   handleAuthServices() {
//     return StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if(snapshot.hasData){
//             return const MainScreen();
//           }else{
//             return const LoginScreen();
//           }
//         },);
//   }
//
//
//   // static Future<User?> signInWithGoogle({required BuildContext context}) async {
//   //   FirebaseAuth auth = FirebaseAuth.instance;
//   //   User? user;
//   //
//   //   final GoogleSignIn googleSignIn = GoogleSignIn();
//   //
//   //   final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//   //
//   //   if (googleSignInAccount != null) {
//   //     final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//   //
//   //     final AuthCredential credential = GoogleAuthProvider.credential(
//   //       accessToken: googleSignInAuthentication.accessToken,
//   //       idToken: googleSignInAuthentication.idToken,
//   //     );
//   //
//   //     try {
//   //       final UserCredential userCredential = await auth.signInWithCredential(credential);
//   //       user = userCredential.user;
//   //     } on FirebaseAuthException catch (e) {
//   //       if (e.code == 'account-exists-with-different-credential') {
//   //         // handle the error here
//   //       }
//   //       else if (e.code == 'invalid-credential') {
//   //         // handle the error here
//   //       }
//   //     } catch (e) {
//   //       // handle the error here
//   //     }
//   //   }
//   //
//   //   return user;
//   // }
//
//
//   signInWithGoogle() async{
//     final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>['email']).signIn();
//     final GoogleSignInAuthentication googleSignInAuthentication = await googleUser!.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken
//     );
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
//
//   signOutFromGoogle(){
//     FirebaseAuth.instance.signOut();
//   }
// }