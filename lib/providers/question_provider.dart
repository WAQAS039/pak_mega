import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/model/questions_model.dart';


class QuestionProvider extends ChangeNotifier{
  QuestionModel? _questionModel;
  QuestionModel? get questionModel => _questionModel;

  void setQuestionModel(QuestionModel questions){
    _questionModel = questions;
    notifyListeners();
  }

  void changeState(){

  }

}