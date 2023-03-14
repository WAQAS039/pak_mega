import 'package:pak_mega_mcqs/common/model/subcategory_model.dart';

class TestModel{
  String? _testName;
  List<SubCategoryModel>? _testSubCategories;
  String? get testName => _testName;
  List<SubCategoryModel>? get testSubCategories => _testSubCategories;

  TestModel({required testName, required testSubCategories}){
    _testName = testName;
    _testSubCategories = testSubCategories;
  }

  TestModel.fromJson(Map<String ,dynamic> json){
    _testName = json['test_name'];
    if(json['test_sub_categories'] != null){
      _testSubCategories = <SubCategoryModel>[];
      for(var map in json['test_sub_categories']){
        _testSubCategories!.add(SubCategoryModel.fromJson(map));
      }
    }
  }

  Map toJson(){
    return {
      "test_name":_testName,
      "test_sub_categories":_testSubCategories!.map((e) => e.toJson()).toList()
    };
  }
}