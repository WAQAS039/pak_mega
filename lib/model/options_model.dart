class Options{
  String? _text;
  bool? _isCorrect;

  //getters
  String? get text => _text;
  bool? get isCorrect => _isCorrect;

  Options({required text, required isCorrect}){
    _text = text;
    _isCorrect = isCorrect;
  }
  Options.fromJson(Map<String,dynamic> json){
    _text = json['text'];
    _isCorrect = json['isCorrect'];
  }

  Map toJson(){
    return {
      'text': _text,
      'isCorrect':_isCorrect
    };
  }

  @override
  String toString() {
    return "{$_text , $_isCorrect}";
  }
}