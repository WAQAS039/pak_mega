import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pak_mega_mcqs/database/offline_database.dart';
import 'package:pak_mega_mcqs/model/mcqs_db_model.dart';
import 'package:pak_mega_mcqs/model/tests_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/mcqsdb_provider.dart';

class MCQsLDbRepo{
  static SharedPreferences? _sharePreferences;
  // getting categories List from Firestore
  static void saveMCQsDbInLocalDb(BuildContext context) async {
    List<dynamic> mCQsList = [];
    List<dynamic> testList = [];

    // ref.settings = const Settings(persistenceEnabled: true,ignoreUndefinedProperties: true);
    try{
      var ref = FirebaseFirestore.instance.collection('Categories');
      if(await ref.snapshots().isEmpty){
        print("error");
      }else{
        await ref.get().then((value) async{
          for(var doc in value.docs){
            mCQsList = doc.data()['mCQsDb'];
            testList = doc.data()['tests'];
            for(var map in mCQsList){
              OfflineDatabase().addCategoryListToLocalDb(
                  {
                    "categoryName": map['name'],
                    "categoryList": jsonEncode(map)
                  }
              );
            }
            for(var map in testList){
              OfflineDatabase().addTestListToLocalDb(
                  {
                    "testName": map['test_name'],
                    "testList": jsonEncode(map)
                  }
              );
            }
          }
          if(mCQsList.isNotEmpty){
            _sharePreferences = await SharedPreferences.getInstance();
            _sharePreferences!.setInt('dbStatus', 1).then((value) async{
              context.read<MCQsDbProvider>().resetAllList();
              List<MCQsDbModel> mCQsList = await MCQsLDbRepo.getCategoriesFromLocalDb();
              List<TestModel> testList = await MCQsLDbRepo.getTestsFromLocalDb();
              context.read<MCQsDbProvider>().addTestList(tests: testList);
              context.read<MCQsDbProvider>().addMCQsList(mCQsList: mCQsList);
              for(int i=0;i<mCQsList.length;i++){
                MCQsDbModel mcQsDbModel = mCQsList[i];
                context.read<MCQsDbProvider>().addCategoriesList(categoriesList: mcQsDbModel.categoriesList!);
              }
            });
          }
        }).catchError((error){
          print("-------------------$error--------------------");
        }).timeout(Duration(seconds: 1),onTimeout: (){
          print("-------------------timeout--------------------");
        });
      }
    } catch(e){
      print("444444444");
    }
  }

  // _ref.setData(newNote.toMap()).timeout(Duration(seconds: 2),onTimeout:() {
  //
  // //cancel this call here
  //
  // print("do something now");
  // });


  // List<String> mCQsDb = [];
  // for(var map in doc.data()['McqsDb']) {
  //   mCQsDb.add(jsonEncode(map));
  // }

  // static Future<List<MCQsDbModel>> getMCQsDbList() async{
  //   SharedPreferences sharePreferences = await SharedPreferences.getInstance();
  //   List<String> list = sharePreferences.getStringList('MCQsDbList')!;
  //   List<MCQsDbModel> categories = [];
  //   for(var map in list){
  //     categories.add(MCQsDbModel.fromJson(jsonDecode(map)));
  //   }
  //   getCategoriesFromLocalDb();
  //   return categories;
  // }

  static Future<List<MCQsDbModel>> getCategoriesFromLocalDb() async {
    List<MCQsDbModel> categories = await OfflineDatabase().getCategories();
    return categories;
  }

  static Future<List<TestModel>> getTestsFromLocalDb() async {
    List<TestModel> tests = await OfflineDatabase().getTests();
    return tests;
  }

}