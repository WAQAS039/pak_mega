import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/common/providers/points_provider.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/custom_screen_widget.dart';
import 'package:provider/provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScreenWidget(
        title: "Achievements",
        onPress: (){
          Navigator.of(context).pop();
        },
        appBarColor: AppColors.appBarColor,
        child: ListView.builder(
            itemCount: achievementsList.length,
            itemBuilder: (context, index) {
              var model  = achievementsList[index];
              return Consumer<PointsProvider>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      Container(
                        height: Dimensions.height98,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: Dimensions.height15,right: Dimensions.height15,bottom: Dimensions.height10,top: Dimensions.height10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.height15),
                          color: AppColors.subCategoryContainerColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.16),
                              offset: Offset(0,3),
                              blurRadius: 6,
                            )
                          ]
                        ),
                        child:  Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                    height: 46,
                                    width: 46,
                                  margin: EdgeInsets.only(left: Dimensions.height20,right: Dimensions.height10),
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                        image: AssetImage(model.icon,),
                                        opacity: value.obtainScore >= model.requirePoints ? 1.0 : 0.5,
                                        scale: 1.5
                                      ),
                                    ),),
                                value.obtainScore >= model.requirePoints ? const SizedBox.shrink() : const Positioned(
                                  right: 10,
                                  bottom: 0,
                                  child: SizedBox(
                                    height: 13,
                                    width: 13,
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.greyBlue,
                                      child: Icon(Icons.lock,size: 8,color: AppColors.checkButton,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(model.name,style: const TextStyle(fontSize: 16),),
                                Text(model.description,style: const TextStyle(fontSize: 14),),
                              ],
                            ),
                            const Spacer(),
                            Container(
                                margin: EdgeInsets.only(right: Dimensions.height10),
                                child: Icon(Icons.check_circle_outline,color: value.obtainScore >= model.requirePoints ? Colors.black : AppColors.checkButton,)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },));
  }
}


class AchievementsModel{
  String name;
  String description;
  String icon;
  int requirePoints;
  AchievementsModel({required this.name,required this.description,required this.icon,required this.requirePoints});
}

List<AchievementsModel> achievementsList = [
  AchievementsModel(name: "Rookie", description: "Get more than 10000 points",requirePoints: 10000,icon: 'assets/icons/achievement_icons/rookie.png'),
  AchievementsModel(name: "Silver", description: "get more than 50000 points",requirePoints: 500000,icon: 'assets/icons/achievement_icons/silver.png'),
  AchievementsModel(name: "Gold", description: "get more than 100000 points",requirePoints: 5000,icon: 'assets/icons/achievement_icons/gold.png'),
  AchievementsModel(name: "Diamond", description: "get more than 5000000 points",requirePoints: 100000,icon: 'assets/icons/achievement_icons/diamond.png'),
];
