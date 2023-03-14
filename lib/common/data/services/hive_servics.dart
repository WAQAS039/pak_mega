import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


class HiveService {
  static Future<void> initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox('app_box');
  }

  static Box get timerStateBox => Hive.box('app_box');
}