import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pak_mega_mcqs/data/api/purchase_api.dart';
import 'package:pak_mega_mcqs/data/repo/auth_repo.dart';
import 'package:pak_mega_mcqs/data/servics/auth_servics.dart';
import 'package:pak_mega_mcqs/providers/admob_provider.dart';
import 'package:pak_mega_mcqs/providers/auth_provider.dart';
import 'package:pak_mega_mcqs/providers/click_provider.dart';
import 'package:pak_mega_mcqs/providers/coins_provider.dart';
import 'package:pak_mega_mcqs/providers/in_app_purchase_providers/repeatable_purchase.dart';
import 'package:pak_mega_mcqs/providers/leaderboard_provider.dart';
import 'package:pak_mega_mcqs/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/providers/network_provider.dart';
import 'package:pak_mega_mcqs/providers/points_provider.dart';
import 'package:pak_mega_mcqs/providers/setting_provider.dart';
import 'package:pak_mega_mcqs/providers/them_provider.dart';
import 'package:pak_mega_mcqs/providers/user_information_provider.dart';
import 'package:pak_mega_mcqs/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/screens/testing.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  List<String> testDeviceIds = ['3FF53946D0C9F8608D8BCACB8778AF92'];
  MobileAds.instance.initialize();
  // thing to add
  RequestConfiguration configuration =
  RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ClicksProvider(),),
        ChangeNotifierProvider(create: (_)=>AdMobServicesProvider(),),
        ChangeNotifierProvider(create: (_)=>MCQsDbProvider()),
        ChangeNotifierProvider(create: (_)=>UserInformationProvider()),
        ChangeNotifierProvider(create: (_)=>CoinsProvider(),),
        ChangeNotifierProvider(create: (_)=>InAppPurchaseApi()),
        ChangeNotifierProvider(create: (_)=>SettingsProvider()),
        ChangeNotifierProvider(create: (_)=>LeaderBoardProvider()),
        ChangeNotifierProvider(create: (_)=>PointsProvider()),
        ChangeNotifierProvider(create: (_)=>RepeatablePurchase()),
        // ChangeNotifierProvider(create: (_)=> AuthServicesProvider()),
        ChangeNotifierProvider(create: (_)=> AuthProvider()),
        StreamProvider<int>(create: (context)=>NetworkProvider().streamController.stream, initialData: 0)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pak Mega MCQs',
        routes: RouteHelper.routesList(context),
        // home: const Testing(),
        initialRoute: RouteHelper.initRoute,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.white,
              secondary: Colors.white,
            ),
            appBarTheme: const AppBarTheme(color: AppColors.mainColor)
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
      )
    );
  }

}