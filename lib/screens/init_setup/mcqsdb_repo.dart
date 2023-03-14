// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:pak_mega_mcqs/common/database/offline_database.dart';
// import 'package:pak_mega_mcqs/common/model/categories_model.dart';
// import 'package:pak_mega_mcqs/common/model/mcqs_db_model.dart';
// import 'package:pak_mega_mcqs/common/model/questions_model.dart';
// import 'package:pak_mega_mcqs/common/model/subcategory_model.dart';
// import 'package:pak_mega_mcqs/common/model/tests_model.dart';
// import 'package:pak_mega_mcqs/common/providers/mcqsdb_provider.dart';
// import 'package:pak_mega_mcqs/common/utils/app_constants.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'init_setup_provider.dart';
//
// class MCQsLDbRepo{
//   // getting categories List from Firestore
//   static void saveMCQsDbInLocalDb(BuildContext context) async {
//     // clearData(context);
//
//   }
//
//   // getMCQs(context);
//   //
//   // getTest(context);
//
//   static Future<void> clearData(BuildContext context) async {
//     SharedPreferences sharePreferences = await SharedPreferences.getInstance();
//     sharePreferences.clear();
//     context.read<MCQsDbProvider>().resetAllList();
//     await OfflineDatabase().deleteTestListFromLocalDb();
//     await OfflineDatabase().deleteCategoriesListFromLocalDb();
//   }
//
//   static Future<List<MCQsDbModel>> getCategoriesFromLocalDb() async {
//     List<MCQsDbModel> categories = await OfflineDatabase().getCategories();
//     return categories;
//   }
//
//   static Future<List<TestModel>> getTestsFromLocalDb() async {
//     List<TestModel> tests = await OfflineDatabase().getTests();
//     return tests;
//   }
//
//   static void getMCQs(BuildContext context) {
//     print('getting mcqs');
//     List<MCQsDbModel> mCQsList = [];
//     FirebaseFirestore.instance.collection("MCQs").get().then((querySnapshot) {
//       for (var mainCategoryDoc in querySnapshot.docs) {
//         String mainCategoryName = mainCategoryDoc.data()['name'];
//         // context.read<MCQsProvider>().setCategoriesName(mainCategoryDoc.data()['name']);
//         mainCategoryDoc.reference.collection('categories').get().then((categorySnapshot) {
//           List<CategoriesModel> categories = [];
//           for (var categoryDoc in categorySnapshot.docs) {
//             String categoryName = categoryDoc.data()['name'];
//             String categoryIcon = categoryDoc.data()['icon'];
//
//             categoryDoc.reference.collection('subCategory').get().then((subCategorySnapshot) {
//               List<SubCategoryModel> subCategories = [];
//               for (var subCategoryDoc in subCategorySnapshot.docs) {
//                 String subCategoryName = subCategoryDoc.data()['subcategory_name'];
//                 String subCategoryIcon = subCategoryDoc.data()['subcategory_icon'];
//                 List<QuestionModel> questions = [];
//                 if(subCategoryDoc.data()['questions'] != null){
//                   for(var json in subCategoryDoc.data()['questions']){
//                     questions.add(QuestionModel.fromJson(json));
//                   }
//                 }
//                 if(questions != []){
//                   SubCategoryModel subCategory = SubCategoryModel(
//                       subCategoryName: subCategoryName,
//                       subCategoryIcon: subCategoryIcon,
//                       question: questions
//                   );
//                   subCategories.add(subCategory);
//                 }
//               }
//               if(subCategories != []){
//                 CategoriesModel category = CategoriesModel(
//                     categoryName: categoryName,
//                     categoryIcon: categoryIcon,
//                     subCategories: subCategories
//                 );
//                 categories.add(category);
//               }
//             });
//           }
//           if(categories != []){
//             MCQsDbModel mcqs = MCQsDbModel(
//                 name: mainCategoryName,
//                 categories: categories
//             );
//             mCQsList.add(mcqs);
//             context.read<InitSetUpProvider>().setProgressValue = mCQsList.length / querySnapshot.docs.length;
//             if(context.read<InitSetUpProvider>().progressValue == 1.0){
//
//             }
//             Hive.box("app_box").put(mCQsListString, jsonEncode(mCQsList));
//           }
//         });
//       }
//     });
//     Future.delayed(const Duration(seconds: 5),(){
//       for (var mcqs in mCQsList) {
//         OfflineDatabase().addCategoryListToLocalDb(
//             {
//               "categoryName": mcqs.name,
//               "categoryList": jsonEncode(mcqs.toJson())
//             }
//         );
//       }
//       if(mCQsList.length > 1){
//         print('lenth 3');
//         Hive.box(appBox).put(mCQsListString, jsonEncode(mCQsList));
//       }
//     });
//   }
//
//   static void getTest(BuildContext context){
//     print('getting test');
//     List<TestModel> testModels = [];
//     FirebaseFirestore.instance.collection("Test").get().then((querySnapshot) {
//       for (var testDoc in querySnapshot.docs) {
//         String testName = testDoc.data()['test_name'];
//         List<SubCategoryModel> subCategoryModels = [];
//         testDoc.reference.collection('test_sub_categories').get().then((subCategorySnapshot) {
//           for (var subCategoryDoc in subCategorySnapshot.docs) {
//             String subCategoryName = subCategoryDoc.data()['subcategory_name'];
//             String subCategoryIcon = subCategoryDoc.data()['subcategory_icon'];
//             List<QuestionModel> questions = [];
//             if(subCategoryDoc.data()['questions'] != null){
//               for(var map in subCategoryDoc.data()['questions']){
//                 questions.add(QuestionModel.fromJson(map));
//               }
//             }
//             if(questions != []){
//               subCategoryModels.add(SubCategoryModel(subCategoryName: subCategoryName, subCategoryIcon: subCategoryIcon, question: questions)
//               );
//             }
//           }
//           if(subCategoryModels != []){
//             testModels.add(TestModel(testName: testName, testSubCategories: subCategoryModels));
//             Hive.box(appBox).put(testListString, jsonEncode(testModels));
//             // if(context.read<InitSetUpProvider>().gotAllMCQs){
//             //   context.read<InitSetUpProvider>().setProgressValue = testModels.length / querySnapshot.docs.length;
//             // }
//             print(context.read<InitSetUpProvider>().progressValue);
//           }
//         });
//       }
//     });
//     // Future.delayed(const Duration(seconds: 5),() async{
//     //   // Navigator.of(context).pop();
//     //   for (var test in testModels) {
//     //     OfflineDatabase().addTestListToLocalDb(
//     //         {
//     //           "testName": test.testName,
//     //           "testList": jsonEncode(test)
//     //         },
//     //       context
//     //     );
//     //   }
//     // });
//   }
//
// }