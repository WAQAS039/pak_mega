import 'package:pak_mega_mcqs/model/subcategory_model.dart';

class CategoriesModel{
  String? _categoryName;
  String? _categoryIcon;
  List<SubCategoryModel>? _subCategories;


  String? get categoryName => _categoryName;
  String? get categoryIcon => _categoryIcon;
  List<SubCategoryModel>? get subCategories => _subCategories;
  CategoriesModel({required categoryName, required categoryIcon,required subCategories}){
    _categoryName = categoryName;
    _categoryIcon = categoryIcon;
    _subCategories = subCategories;
  }

  CategoriesModel.fromJson(Map<String,dynamic> json){
    _categoryName = json['category_name'];
    _categoryIcon = json['category_icon'];
    if(json['sub_categories'] != null){
      _subCategories = <SubCategoryModel>[];
      for(var map in json['sub_categories']){
        _subCategories!.add(SubCategoryModel.fromJson(map));
      }
    }
  }
  Map toJson(){
    return {
      'category_name':_categoryName,
      'category_icon':_categoryIcon,
      'sub_category':_subCategories!.map((model) => model.toJson()).toList(),
    };
  }
}



// Category List to be Displayed on main page
List<CategoriesModel> categoriesList = [];