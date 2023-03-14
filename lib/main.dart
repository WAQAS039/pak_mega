import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_mega_mcqs/global.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/screens/application/provider.dart';
import 'package:pak_mega_mcqs/screens/home/provider.dart';
import 'package:pak_mega_mcqs/screens/init_setup/init_setup_provider.dart';
import 'package:pak_mega_mcqs/screens/shoping/free_rewared/provider.dart';
import 'package:provider/provider.dart';
import 'common/providers/admob_provider.dart';
import 'screens/login/login_provider.dart';
import 'common/providers/in_app_purchase_providers/repeatable_purchase.dart';
import 'screens/leader_board/leaderboard_provider.dart';
import 'common/providers/mcqsdb_provider.dart';
import 'common/providers/network_provider.dart';
import 'common/providers/network_provider2.dart';
import 'common/providers/points_provider.dart';
import 'common/providers/setting_provider.dart';
import 'screens/profile/profile_provider.dart';
import 'common/routes/routes_helper.dart';


void main() async{
  await Global.init();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ApplicationProvider()),
        ChangeNotifierProvider(create: (_)=>InitSetUpProvider()),
        ChangeNotifierProvider(create: (_)=>HomeProvider()),
        ChangeNotifierProvider(create: (_)=>AdMobServicesProvider(),),
        ChangeNotifierProvider(create: (_)=>MCQsDbProvider()),
        ChangeNotifierProvider(create: (_)=>ProfileProvider()),
        ChangeNotifierProvider(create: (_)=>SettingsProvider()),
        ChangeNotifierProvider(create: (_)=>LeaderBoardProvider()),
        ChangeNotifierProvider(create: (_)=>PointsProvider()),
        ChangeNotifierProvider(create: (_)=>RepeatablePurchase()),
        ChangeNotifierProvider(create: (_)=> LoginProvider()),
        ChangeNotifierProvider(create: (_)=> CheckInternet()),
        ChangeNotifierProvider(create: (_)=>TimerProvider()),
        StreamProvider<int>(create: (context)=>NetworkProvider().streamController.stream, initialData: 0)],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(Dimensions.width,Dimensions.height),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pak Mega MCQs',
          routes: RouteHelper.routesList(context),
          initialRoute: RouteHelper.initRoute,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.white,
                secondary: Colors.white,
              ),
              appBarTheme: const AppBarTheme(color: AppColors.mainColor)
          ),
        );
      },
    );
  }
}