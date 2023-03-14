import 'package:hive/hive.dart';
import 'package:pak_mega_mcqs/common/model/user_model.dart';

class UserProfileAdopter extends TypeAdapter<UserModel>{
  @override
  int get typeId => 0;

  @override
  UserModel read(BinaryReader reader) {
    final name = reader.read();
    final email = reader.read();
    final image = reader.read();
    final imageType = reader.read();
    final uid = reader.read();
    final points = reader.read();
    final totalPoints = reader.read();
    final allTimeRank = reader.read();
    final weeklyRank = reader.read();
    final twentyFourHourRank = reader.read();
    final coins = reader.read();
    final loginType = reader.read();
    final createdTime = reader.read();
    final createDate = reader.read();
    final isAdFree = reader.read();
    final isOfflineEnable = reader.read();
    return UserModel(
        name: name,
        email: email,
        image: image,
        imageType: imageType,
        uid: uid,
        points: points,
        totalPoints: totalPoints,
        allTimeRank: allTimeRank,
        weeklyRank: weeklyRank,
        twentyFourHourRank: twentyFourHourRank,
        coins: coins,
        loginType: loginType,
        createdTime: createdTime,
        createDate: createDate,
        isAdFree: isAdFree,
        isOfflineEnable: isOfflineEnable);
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.write(obj.name);
    writer.write(obj.email);
    writer.write(obj.image);
    writer.write(obj.imageType);
    writer.write(obj.uid);
    writer.write(obj.points);
    writer.write(obj.totalPoints);
    writer.write(obj.allTimeRank);
    writer.write(obj.weeklyRank);
    writer.write(obj.twentyFourHourRank);
    writer.write(obj.coins);
    writer.write(obj.loginType);
    writer.write(obj.createdTime);
    writer.write(obj.createdDate);
    writer.write(obj.isAdFree);
    writer.write(obj.isOfflineEnable);
  }

}