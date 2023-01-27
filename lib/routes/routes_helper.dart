import 'package:flutter/cupertino.dart';

import 'package:pak_mega_mcqs/Screens/categories/categories_screen.dart';
import 'package:pak_mega_mcqs/Screens/home_screen_pages/home_screen.dart';
import 'package:pak_mega_mcqs/Screens/mcqs/mcqs_screen.dart';
import 'package:pak_mega_mcqs/Screens/mcqs/quiz_screen.dart';
import 'package:pak_mega_mcqs/screens/categories/sub_categories_page.dart';
import 'package:pak_mega_mcqs/screens/home_screen_pages/settings.dart';
import 'package:pak_mega_mcqs/screens/login/login_as_guest_page.dart';
import 'package:pak_mega_mcqs/screens/login/login_page.dart';
import 'package:pak_mega_mcqs/screens/mcqs/bookmarks_screen.dart';
import 'package:pak_mega_mcqs/screens/results/achievements_screen.dart';

import '../Screens/home/main_screen.dart';

class RouteHelper{
  static const String initRoute = "/";
  static const String homePage = "/homePage";
  static const String categoryPage = "/categoryPage";
  static const String mcqPage = "/mcqPage";
  static const String quizPage ="/quizPage";
  static const String subCategoryPage = "/subCategoryPage";
  static const String mainScreen = "/mainPage";
  static const String loginAsGuest = "/loginAsGuest";
  static const String settingsPage = "/settingPage";
  static const String achievementsPage = "/achievementsPage";
  static const String bookmarkPage = "/bookmarkPage";

  static Map<String,Widget Function(BuildContext)> routesList(BuildContext context){
    return {
      initRoute: (context)=> const LoginScreen(),
      // homePage: (context)=> const HomeScreen(),
      categoryPage:(context)=> const CategoriesScreen(),
      mcqPage:(context)=> const MCQsScreen(),
      quizPage:(context)=>const QuizScreen(),
      // subCategoryPage:(context)=>const SubCategoriesScreen(),
      mainScreen:(context)=> const MainScreen(),
      loginAsGuest:(context)=>const LoginAsGuest(),
      settingsPage:(context)=>const Settings(),
      achievementsPage: (context)=>const AchievementsScreen(),
      bookmarkPage: (context)=> const BookmarkScreen()
    };
  }
}