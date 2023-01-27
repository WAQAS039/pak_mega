import 'dart:convert';

import 'options_model.dart';

class BookmarkModel{
  int? _position;
  String? _question;
  List<Options>? _options;

  int? get position => _position;
  String? get question => _question;
  List<Options>? get options => _options;

  BookmarkModel({required position,required question, required options}){
    _position = position;
    _question = question;
    _options = options;
  }

  BookmarkModel.fromJson(Map<String,dynamic> map){
    _position = map['position'];
    _question = map['question'];
    if(map['options'] != null){
      _options = <Options>[];
      for(var data in jsonDecode(map['options'])){
        _options!.add(Options.fromJson(data));
      }
    }
  }


  Map<String,dynamic> toMap(){
    return {
      'position': _position,
      'question': _question,
      'options' : _options!.map((e) => jsonEncode(e.toJson())).toList().toString()
    };
  }
}

