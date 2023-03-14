import 'package:hive/hive.dart';

class StorageServices{
  static StorageServices get to => StorageServices();

  void setString(String key,dynamic value){
    Hive.box("app_box").put(key, value);
  }

  void getString(String key){
    Hive.box("app_box").get(key);
  }

  void setBool(String key, bool value){
    Hive.box("app_box").put(key, value);
  }

  void getBool(String key){
    Hive.box("app_box").get(key);
  }

  void remove(String key){
    Hive.box("app_box").delete(key);
  }
}