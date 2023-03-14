import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pak_mega_mcqs/common/providers/network_error_provider.dart';
import '../../common/model/categories_model.dart';
import '../../common/model/mcqs_db_model.dart';
import '../../common/model/questions_model.dart';
import '../../common/model/subcategory_model.dart';
import '../../common/model/tests_model.dart';
import '../../common/utils/app_constants.dart';

class InitSetUpProvider extends ChangeNotifier{
  double _progressValue = 0;
  double get progressValue => _progressValue;
  bool _gotAll = false;
  bool get gotAll => _gotAll;


  set setProgressValue(double value) {
    _progressValue = value;
    notifyListeners();
  }

  bool _isError = false;
  bool get isError => _isError;

  void getMCQsAndTestData(BuildContext context){
    Networks(
      onComplete: (){
        _isError = false;
        notifyListeners();
        getMCQs();
      },
      onError: () async{
        _isError = true;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went Wrong')));
      }
    ).doRequest();
  }



  Future<void> getMCQs() async {
    List<MCQsDbModel> mCQsList = [];

    QuerySnapshot mainCategorySnapshot = await FirebaseFirestore.instance.collection("MCQs").get();
    for (var mainCategoryDoc in mainCategorySnapshot.docs) {
      String mainCategoryName = (mainCategoryDoc.data() as Map<String, dynamic>)['name'];

      QuerySnapshot categorySnapshot = await mainCategoryDoc.reference.collection('categories').get();

      List<CategoriesModel> categories = [];

      for (var categoryDoc in categorySnapshot.docs) {
        String categoryName = (categoryDoc.data() as Map<String, dynamic>)['name'];
        String categoryIcon = (categoryDoc.data() as Map<String, dynamic>)['icon'];

        QuerySnapshot subCategorySnapshot = await categoryDoc.reference.collection('subCategory').get();

        List<SubCategoryModel> subCategories = [];

        for (var subCategoryDoc in subCategorySnapshot.docs) {
          String subCategoryName = (subCategoryDoc.data() as Map<String, dynamic>)['subcategory_name'];
          String subCategoryIcon = (subCategoryDoc.data() as Map<String, dynamic>)['subcategory_icon'];

          List<QuestionModel> questions = [];

          if((subCategoryDoc.data() as Map<String, dynamic>)['questions'] != null){
            for(var json in (subCategoryDoc.data() as Map<String, dynamic>)['questions']!){
              questions.add(QuestionModel.fromJson(json));
            }
          }

          if(questions.isNotEmpty){
            SubCategoryModel subCategory = SubCategoryModel(
                subCategoryName: subCategoryName,
                subCategoryIcon: subCategoryIcon,
                question: questions
            );
            subCategories.add(subCategory);
          }
        }

        if(subCategories.isNotEmpty){
          CategoriesModel category = CategoriesModel(
              categoryName: categoryName,
              categoryIcon: categoryIcon,
              subCategories: subCategories
          );
          categories.add(category);
        }
      }

      if(categories.isNotEmpty){
        MCQsDbModel mcqs = MCQsDbModel(
            name: mainCategoryName,
            categories: categories
        );
        mCQsList.add(mcqs);
        // _progressValue = mCQsList.length / mainCategorySnapshot.docs.length;
        // notifyListeners();
        if(mCQsList.length == mainCategorySnapshot.docs.length){
          Hive.box("app_box").put(mCQsListString, jsonEncode(mCQsList));
          await getTest();
        }
      }
    }
    // print("++++++++$mCQsList+++++++++");
  }






  Future<void> getTest() async {
    List<TestModel> testModels = [];
    try {
      QuerySnapshot testSnapshot = await FirebaseFirestore.instance.collection('Test').get();
      for (QueryDocumentSnapshot testDoc in testSnapshot.docs) {
        String testName = (testDoc.data() as Map<String,dynamic>)['test_name'];
        List<SubCategoryModel> subCategoryModels = [];
        QuerySnapshot subCategorySnapshot = await testDoc.reference.collection('test_sub_categories').get();
        for (QueryDocumentSnapshot subCategoryDoc in subCategorySnapshot.docs) {
          String subCategoryName = (subCategoryDoc.data() as Map<String,dynamic>)['subcategory_name'];
          String subCategoryIcon = (subCategoryDoc.data() as Map<String,dynamic>)['subcategory_icon'];
          List<QuestionModel> questions = [];
          if ((subCategoryDoc.data() as Map<String,dynamic>)['questions'] != null) {
            for (var map in (subCategoryDoc.data() as Map<String,dynamic>)['questions']) {
              questions.add(QuestionModel.fromJson(map));
            }
          }
          if (questions.isNotEmpty) {
            subCategoryModels.add(
              SubCategoryModel(subCategoryName: subCategoryName, subCategoryIcon: subCategoryIcon, question: questions),
            );
          }
        }
        if (subCategoryModels.isNotEmpty) {
          testModels.add(TestModel(testName: testName, testSubCategories: subCategoryModels));
          _progressValue = testModels.length / testSnapshot.docs.length;
          notifyListeners();
          if(testModels.length == testSnapshot.docs.length){
            Hive.box(appBox).put(dbStatus, 1);
            Hive.box(appBox).put(testListString, jsonEncode(testModels)).then((value) {
              Future.delayed(Duration.zero,(){
                _gotAll = true;
                notifyListeners();
              });
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }


  List<MCQsDbModel> getCategoriesFromLocalDb() {
    List mCQSList = jsonDecode(Hive.box(appBox).get(mCQsListString)) ?? [];
    List<MCQsDbModel> categories = mCQSList.map((e) => MCQsDbModel.fromJson(e)).toList();
    return categories;
  }

  List<TestModel> getTestsFromLocalDb() {
    List<dynamic> decodedTests = jsonDecode(Hive.box(appBox).get(testListString));
    List<TestModel> tests = decodedTests.map((test) => TestModel.fromJson(test)).toList();
    return tests;
  }

}