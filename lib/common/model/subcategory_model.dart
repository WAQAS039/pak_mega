
import 'package:pak_mega_mcqs/common/model/questions_model.dart';

class SubCategoryModel{
  String? _subCategoryName;
  String? _subCategoryIcon;
  List<QuestionModel>? _questions;
  String? get subCategoryName => _subCategoryName;
  String? get subCategoryIcon => _subCategoryIcon;
  List<QuestionModel>? get questions => _questions;

  SubCategoryModel({subCategoryName, subCategoryIcon, question}){
    _subCategoryName = subCategoryName;
    _subCategoryIcon = subCategoryIcon;
    _questions = question;
  }


  set setSubCategoryIcon(String value) {
    _subCategoryIcon = value;
  }

  SubCategoryModel.fromJson(Map<String,dynamic> json){
    _subCategoryName = json['subcategory_name'];
    _subCategoryIcon = json['subcategory_icon'];
    if(json['questions'] != null){
      _questions = <QuestionModel>[];
      for(var map in json['questions']){
        _questions!.add(QuestionModel.fromJson(map));
      }
    }
  }

  Map toJson(){
    return {
      'subcategory_name':_subCategoryName,
      'subcategory_icon':_subCategoryIcon,
      'questions':_questions!.map((model) => model.toJson()).toList()
    };
  }
}