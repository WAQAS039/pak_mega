import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/providers/points_provider.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:pak_mega_mcqs/widgets/custom_screen_widget.dart';
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
        scaffoldColor: AppColors.mainColor,
        child: ListView.builder(
            itemCount: achievementsList.length,
            itemBuilder: (context, index) {
              var model  = achievementsList[index];
              return Consumer<PointsProvider>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Image.asset(model.icon,height: Dimensions.height40,width: Dimensions.width25,),
                        title: Text('${model.name}\n${model.description}'),
                        trailing: value.obtainScore >= model.requirePoints ? const Icon(Icons.check_circle,color: Colors.white,) : const Icon(Icons.check_circle_outline,color: Colors.white,),
                      ),
                      Divider(color: Colors.white,endIndent: Dimensions.height20+3,indent: Dimensions.height20+3,)
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
  AchievementsModel(name: "Rookie", description: "get more than 1000 points",requirePoints: 1000,icon: 'assets/icons/achievement_icons/rookie.png'),
  AchievementsModel(name: "Silver", description: "get more than 100000 points",requirePoints: 100000,icon: 'assets/icons/achievement_icons/silver.png'),
  AchievementsModel(name: "Gold", description: "get more than 5000 points",requirePoints: 5000,icon: 'assets/icons/achievement_icons/gold.png'),
  AchievementsModel(name: "Diamond", description: "get more than 100000 points",requirePoints: 100000,icon: 'assets/icons/achievement_icons/diamond.png'),
];
