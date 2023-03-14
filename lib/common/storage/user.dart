import 'package:pak_mega_mcqs/common/model/user_model.dart';
import 'package:pak_mega_mcqs/common/storage/storage.dart';
import 'package:pak_mega_mcqs/common/utils/app_constants.dart';

class UserStorage{

  //profile
  void getProfile() async {
    StorageServices.to.getString(storageUserProfileKey);
  }

  // saving profile
  Future<void> saveProfile(UserModel profile) async {
    StorageServices.to.setString(storageUserProfileKey, profile);
    StorageServices.to.setBool(loginStatus, true);
  }

  // during logout I
  Future<void> onLogout() async {
    StorageServices.to.remove(storageUserProfileKey);
    StorageServices.to.setBool(loginStatus, false);
    // Get.offAllNamed(AppRoutes.signIn);
  }
}