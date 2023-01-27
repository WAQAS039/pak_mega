import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoRepo{
  final _storageReference = FirebaseStorage.instance.ref();

  void pickImage() async{
    var imagePath = await ImagePicker().pickImage(source: ImageSource.gallery);
    cropImage(imagePath);
  }

  void cropImage(var imagePath) async{
    if(imagePath != null){
      var cropImagePath = await ImageCropper().cropImage(
          sourcePath: imagePath!.path,
          cropStyle: CropStyle.circle
      );
      // Upload Image
      _storageReference.child('images/waqas').putFile(File(cropImagePath!.path));
    }
  }

  Future<String> getImage(String userName) async{
    var path = await _storageReference.child('images/$userName').getDownloadURL();
    return path;
  }
}