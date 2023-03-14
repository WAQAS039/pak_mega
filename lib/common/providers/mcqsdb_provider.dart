import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/screens/init_setup/mcqsdb_repo.dart';
import 'package:pak_mega_mcqs/common/model/bookmark_model.dart';
import 'package:pak_mega_mcqs/common/model/categories_model.dart';
import 'package:pak_mega_mcqs/common/model/mcqs_db_model.dart';
import 'package:pak_mega_mcqs/common/model/questions_model.dart';
import 'package:pak_mega_mcqs/common/model/subcategory_model.dart';
import 'package:pak_mega_mcqs/common/model/tests_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MCQsDbProvider with ChangeNotifier{
  List<MCQsDbModel> _mCQsList = [];
  List<MCQsDbModel> get mCQsList => _mCQsList;
  List<CategoriesModel> _categories = [];
  List<CategoriesModel> get categories => _categories;
  List<SubCategoryModel> _subCategories = [];
  List<SubCategoryModel> get subCategories => _subCategories;
  List<QuestionModel> _questionList = [];
  List<QuestionModel> get questionList =>_questionList;
  List<TestModel> _testList = [];
  List<TestModel> get testList => _testList;
  List<BookmarkModel> _bookmarkList = [];
  List<BookmarkModel> get bookmarkList => _bookmarkList;
  bool _isAdded = false;
  bool get isAdded => _isAdded;

  void setAdded(bool added){
    _isAdded = added;
    notifyListeners();
  }

  void addMCQsList({required List<MCQsDbModel> mCQsList}){
    _mCQsList.addAll(mCQsList);
    notifyListeners();
  }

  void resetMCQsList(){
    _mCQsList = [];
    notifyListeners();
  }

  void addCategoriesList({required List<CategoriesModel> categoriesList}){
    _categories.addAll(categoriesList);
    notifyListeners();
  }

  void resetCategoriesList(){
    _categories = [];
    notifyListeners();
  }

  void addSubCategoriesList({required List<SubCategoryModel> subCategories}){
    _subCategories.addAll(subCategories);
    notifyListeners();
  }


  void resetAllSubCategoriesList(){
    // print('called');
    _subCategories = [];
    notifyListeners();
  }

  void addQuestionList({required List<QuestionModel> questions}){
    _questionList.addAll(questions);
    notifyListeners();
  }

  void resetQuestionsList(){
    _questionList = [];
    notifyListeners();
  }

  void addTestList({required List<TestModel> tests}){
    _testList.addAll(tests);
    notifyListeners();
  }

  void resetTestList(){
    _testList = [];
    notifyListeners();
  }

  void addBookmarkList({required List<BookmarkModel> bookmarks}){
    _bookmarkList.addAll(bookmarks);
    // print(_bookmarkList[0].options.runtimeType);
    notifyListeners();
  }

  void resetBookmarkList(){
    _bookmarkList = [];
    notifyListeners();
  }

  void deleteBookmark(int index){
    _bookmarkList.removeAt(index);
    notifyListeners();
  }


  void resetAllList(){
    print('called');
    _mCQsList = [];
    _categories = [];
    _testList = [];
    _subCategories = [];
    _questionList = [];
    notifyListeners();
  }


  void changeState(bool state){
    for(int i=0;i<_questionList.length;i++){
      _questionList[i].isLock = state;
      notifyListeners();
    }
  }

  // Future<void> setAllData() async {
  //   SharedPreferences sharePreferences = await SharedPreferences.getInstance();
  //   sharePreferences.setInt('dbStatus', 1).then((value) async{
  //     resetAllList();
  //     List<MCQsDbModel> mCQsList = await MCQsLDbRepo.getCategoriesFromLocalDb();
  //     List<TestModel> testList = await MCQsLDbRepo.getTestsFromLocalDb();
  //     addTestList(tests: testList);
  //     addMCQsList(mCQsList: mCQsList);
  //     for(int i=0;i<mCQsList.length;i++){
  //       MCQsDbModel mcQsDbModel = mCQsList[i];
  //       addCategoriesList(categoriesList: mcQsDbModel.categoriesList!);
  //     }
  //   });
  // }
}