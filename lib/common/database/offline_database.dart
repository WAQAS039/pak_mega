import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pak_mega_mcqs/common/model/bookmark_model.dart';
import 'package:pak_mega_mcqs/common/model/mcqs_db_model.dart';
import 'package:pak_mega_mcqs/common/model/tests_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class OfflineDatabase{
  // database Name and Version
  final String _databaseName = 'MCQsDatabase.db';
  final int dbVersion = 1;
  // table and it's fields
  final String _bookmarkTable = 'BookmarkTable';
  final String _index = 'position';
  final String _question = 'question';
  final String _options = "options";
  // table of categories and it's fields
  final String _categoriesTable = "categoriesTable";
  final String _categoryName = "categoryName";
  final String _categoryList = "categoryList";
  // table of tests and it's fields
  final String _testsTable = "testsTable";
  final String _testName = "testName";
  final String _testList = "testList";

  // SQFLite database
  late Database _database;

  Future<Database> _openDatabase() async{
    final String queryForBookmarkTable = "create table $_bookmarkTable"
        "("
        "$_index integer not null,"
        " $_question text not null,"
        " $_options text not null"
        ")";
    final String queryForCategoryTable = "create table $_categoriesTable"
        "("
        "$_categoryName text not null unique,"
        " $_categoryList text not null unique"
        ")";
    final String queryForTestTable = "create table $_testsTable"
        "("
        "$_testName text not null unique,"
        " $_testList text not null unique"
        ")";
   var mCQsDatabase = await openDatabase(
       join(await getDatabasesPath(), _databaseName),
       onCreate: (database, version) async{
         await database.execute("DROP TABLE IF EXISTS $_categoriesTable");
         await database.execute("DROP TABLE IF EXISTS $_bookmarkTable");
         await database.execute("DROP TABLE IF EXISTS $_testsTable");
         await database.execute(queryForBookmarkTable);
         await database.execute(queryForCategoryTable);
         await database.execute(queryForTestTable);
       },
       version: dbVersion
   );
   return mCQsDatabase;
  }

  // Add Bookmark MCQs to SQLite DB
  Future<int> addBookmark(BookmarkModel bookmarkModel) async{
    _database = await _openDatabase();
    int added = await _database.insert(_bookmarkTable, bookmarkModel.toMap());
    return added;
  }
  // Delete MCQs from SQLite DB
  Future<int> deleteBookmark(String question) async{
    _database = await _openDatabase();
    int deleted = await _database.delete(_bookmarkTable,where: '  $_question = ?',whereArgs: [question]);
    return deleted;
  }


  // Get MCQs List from SQLite DB
  Future<List<BookmarkModel>> getBookmark() async {
    var bookmarkList = <BookmarkModel>[];
    _database = await _openDatabase();
    var list = await _database.query(_bookmarkTable);
    if(list.isNotEmpty){
      for(var map in list){
        bookmarkList.add(BookmarkModel.fromJson(map));
      }
    }
    return bookmarkList;
  }

  Future<int> addCategoryListToLocalDb(Map<String,dynamic> categoriesMap) async {
    _database = await _openDatabase();
    int addedCategory = await _database.insert(_categoriesTable, categoriesMap);
    return addedCategory;
  }

  deleteCategoriesListFromLocalDb() async {
    _database = await _openDatabase();
    await _database.delete(_categoriesTable);
  }

  Future<List<MCQsDbModel>> getCategories() async {
    var mCQsList = <MCQsDbModel>[];
    _database = await _openDatabase();
    var listOfMCQs = await _database.query(_categoriesTable);
    if(listOfMCQs.isNotEmpty){
      for(var map in listOfMCQs){
        mCQsList.add(MCQsDbModel.fromJson(jsonDecode(map[_categoryList].toString())));
      }
    }
    return mCQsList;
  }
  Future<int> addTestListToLocalDb(Map<String, dynamic> testsMap,BuildContext context) async {
    _database = await _openDatabase();
    int result = await _database.insert(_testsTable, testsMap);
    return result;
  }


  Future<List<TestModel>> getTests() async {
    var testList = <TestModel>[];
    _database = await _openDatabase();
    var testListFromDb = await _database.query(_testsTable);
    if(testListFromDb.isNotEmpty){
      for(var map in testListFromDb){
        testList.add(TestModel.fromJson(jsonDecode(map[_testList] as String)));
      }
    }
    return testList;
  }

  deleteTestListFromLocalDb() async {
    _database = await _openDatabase();
    await _database.delete(_testsTable);
  }


}