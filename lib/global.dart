import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pak_mega_mcqs/common/hive_adopters/mcqs_adopter.dart';
import 'package:pak_mega_mcqs/common/hive_adopters/user_profile.dart';
import 'package:path_provider/path_provider.dart';

class Global{
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await ScreenUtil.ensureScreenSize();
    await Firebase.initializeApp();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    MobileAds.instance.initialize();
    Directory dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    Hive.registerAdapter(UserProfileAdopter());
    Hive.registerAdapter(MCQsAdopter());
    await Hive.openBox('app_box');
  }
}