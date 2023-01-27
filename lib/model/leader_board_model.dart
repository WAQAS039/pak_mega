class LeaderBoardModel{
  String? _name;
  String? _image;
  String? _imageType;
  int? _points;
  String? _uid;
  DateTime? _createdDateTime;
  String? _createdDate;

  String? get name => _name;
  String? get image => _image;
  String? get imageType => _imageType;
  int? get points => _points;
  String? get uid => _uid;
  DateTime? get createdDateTime => _createdDateTime;
  String? get createdDate => _createdDate;

  LeaderBoardModel({required name, required image, required imageType, required points,required uid,required time,required date}){
    _name = name;
    _image = image;
    _imageType = imageType;
    _points = points;
    _uid = uid;
    _createdDateTime = time;
    _createdDate = date;
  }

  LeaderBoardModel.fromJson(Map<String, dynamic> json){
    _name = json['name'];
    _image = json['image'];
    _imageType = json['imageType'];
    _points = json['points'];
    _uid = json['uid'];
    _createdDateTime = json['createdDateTime'].toDate();
    _createdDate = json['createdDate'];
  }

  Map<String,dynamic> toJson(){
    return {
      "name":_name,
      "image": _image,
      "imageType":_imageType,
      "points": _points,
      "uid": _uid,
      "createdDateTime": _createdDateTime,
      "createdDate": _createdDate
    };
  }

}