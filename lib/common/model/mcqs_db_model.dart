import 'categories_model.dart';

class MCQsDbModel{
  String? _name;
  List<CategoriesModel>? _categoriesList;
  String? get name => _name;
  List<CategoriesModel>? get categoriesList => _categoriesList;

  MCQsDbModel({required name,required categories}){
    _name = name;
    _categoriesList = categories;
  }

  MCQsDbModel.fromJson(Map<String,dynamic> json){
    _name = json['name'];
    if(json['categories'] != null){
      _categoriesList = <CategoriesModel>[];
      for(var map in json['categories']){
        _categoriesList!.add(CategoriesModel.fromJson(map));
      }
    }
  }

  Map toJson(){
    return {
      "name":_name,
      "categories":_categoriesList!.map((model) => model.toJson()).toList(),
    };
  }
}