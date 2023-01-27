
import 'options_model.dart';

class QuestionModel{
  String? _questionText;
  List<Options>? _options;
  bool? isLock;
  Options? selectedOption;

  // getter
  String? get questionText => _questionText;
  List<Options>? get options => _options;

  QuestionModel({required questionText, required options, this.isLock = false, this.selectedOption}){
    _questionText = questionText;
    _options = options;
  }

  QuestionModel.fromJson(Map<String,dynamic> json){
    _questionText = json['question'];
    if(json['options'] != null){
      _options = <Options>[];
      for(var map in json['options']){
        _options!.add(Options.fromJson(map));
      }
    }
    isLock = json['isClick'];
  }

  Map toJson(){
    return {
      'questionText': _questionText,
      'options':_options!.map((model) => model.toJson()).toList(),
    };
  }
}