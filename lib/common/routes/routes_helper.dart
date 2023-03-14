import 'package:flutter/cupertino.dart';
import 'package:pak_mega_mcqs/screens/categories/categories_screen.dart';
import 'package:pak_mega_mcqs/screens/application/main_screen.dart';
import 'package:pak_mega_mcqs/screens/init_setup/init_setup_page.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_page.dart';
import 'package:pak_mega_mcqs/screens/settings/settings.dart';
import 'package:pak_mega_mcqs/screens/login/login_as_guest_page.dart';
import 'package:pak_mega_mcqs/screens/login/login_page.dart';
import 'package:pak_mega_mcqs/screens/mcqs/bookmarks_screen.dart';
import 'package:pak_mega_mcqs/screens/mcqs/mcqs_screen.dart';
import 'package:pak_mega_mcqs/screens/mcqs/quiz_screen.dart';
import 'package:pak_mega_mcqs/screens/results/achievements_screen.dart';
import 'package:pak_mega_mcqs/screens/splash/splash_screen.dart';



class RouteHelper{
  static const String initRoute = "/";
  static const String setupPage = "/initSetup";
  static const String loginPage = "/loginPage";
  static const String homePage = "/homePage";
  static const String categoryPage = "/categoryPage";
  static const String mcqPage = "/mcqPage";
  static const String profile = "/profile";
  static const String quizPage ="/quizPage";
  static const String subCategoryPage = "/subCategoryPage";
  static const String mainScreen = "/mainPage";
  static const String loginAsGuest = "/loginAsGuest";
  static const String settingsPage = "/settingPage";
  static const String achievementsPage = "/achievementsPage";
  static const String bookmarkPage = "/bookmarkPage";

  static Map<String,Widget Function(BuildContext)> routesList(BuildContext context){
    return {
      initRoute: (context) => const SplashScreen(),
      setupPage: (context) => const InitSetUp(),
      loginPage: (context)=> const LoginScreen(),
      // homePage: (context)=> const HomeScreen(),
      categoryPage:(context)=> const CategoriesScreen(),
      mcqPage:(context)=> const MCQsScreen(),
      quizPage:(context)=>const QuizScreen(),
      // subCategoryPage:(context)=>const SubCategoriesScreen(),
      mainScreen:(context)=> const MainScreen(),
      loginAsGuest:(context)=>const LoginAsGuest(),
      settingsPage:(context)=>const Settings(),
      achievementsPage: (context)=>const AchievementsScreen(),
      profile: (context)=> const ProfileScreen(),
      bookmarkPage: (context)=> const BookmarkScreen()
    };
  }
}