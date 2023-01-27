class UserModel{
  String? _name;
  String? _email;
  String? _image;
  String? _imageType;
  String? _uid;
  int? _points;
  int? _totalPoints;
  int? _allTimeRank;
  int? _weeklyRank;
  int? _twentyFourHourRank;
  int? _coins;
  String? _loginType;
  DateTime? _createdTime;

  String? get name => _name;
  String? get email => _email;
  DateTime? get createdTime => _createdTime;
  String? get loginType => _loginType;
  int? get points => _points;
  String? get uid => _uid;
  String? get image => _image;
  String? get imageType => _imageType;
  int? get allTimeRank => _allTimeRank;
  int? get weeklyRank => _weeklyRank;
  int? get twentyFourHourRank => _twentyFourHourRank;
  int? get coins => _coins;
  int? get totalPoints => _totalPoints;

  set setAllTimeRank(int value) {
    _allTimeRank = value;
  }

  set setWeeklyRank(int value) {
    _weeklyRank = value;
  }

  set setTwentyFourHourRank(int value) {
    _twentyFourHourRank = value;
  }

  set setImage(String value) {
    _image = value;
  }

  set setImageType(String value) {
    _imageType = value;
  }

  set setCoins(int coins){
    _coins = coins;
  }

  UserModel({
    required name,
    required email,
    required image,
    required imageType,
    required uid,
    required points,
    required totalPoints,
    required allTimeRank,
    required weeklyRank,
    required twentyFourHourRank,
    required coins,
    required loginType,
    required createdTime}){
    _name = name;
    _email = email;
    _image = image;
    _imageType = imageType;
    _uid = uid;
    _points = points;
    _totalPoints = totalPoints;
    _allTimeRank = allTimeRank;
    _weeklyRank = weeklyRank;
    _twentyFourHourRank = twentyFourHourRank;
    _coins = coins;
    _loginType = loginType;
    _createdTime = createdTime;
  }

  UserModel.fromJson(Map<String,dynamic>? json){
    _name = json!['name'];
    _email = json['email'];
    _image = json['image'];
    _imageType = json['imageType'];
    _uid = json['uid'];
    _points = json['points'];
    _totalPoints = json['totalPoints'];
    _allTimeRank = json['allTimeRank'];
    _weeklyRank = json['weeklyRank'];
    _twentyFourHourRank = json['twentyFourHourRank'];
    _coins = json['coins'];
    _loginType = json['loginType'];
    _createdTime = json['createdTime'].toDate();
  }


  Map<String,dynamic> toJson(){
    return {
      "name": _name,
      "email": _email,
      "image": _image,
      "imageType":_imageType,
      "uid": _uid,
      "points": _points,
      "totalPoints": _totalPoints,
      "allTimeRank": _allTimeRank,
      "weeklyRank": _weeklyRank,
      "twentyFourHourRank": _twentyFourHourRank,
      "coins": _coins,
      "loginType": _loginType,
      "createdTime": _createdTime,
    };
  }
}