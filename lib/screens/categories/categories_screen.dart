import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/Widgets/custom_screen_widget.dart';
import 'package:pak_mega_mcqs/model/mcqs_db_model.dart';
import 'package:pak_mega_mcqs/model/subcategory_model.dart';
import 'package:pak_mega_mcqs/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/providers/points_provider.dart';
import 'package:pak_mega_mcqs/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/screens/categories/sub_categories_page.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:pak_mega_mcqs/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../../model/categories_model.dart';
import '../../widgets/categories_container_widget.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScreenWidget(
      title: "Categories",
      onPress: () {
        Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
      },
      child: Consumer<MCQsDbProvider>(
        builder: (context, value, child) {
          return ListView.builder(
              itemCount: value.mCQsList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                MCQsDbModel mCQSModel = value.mCQsList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 5,bottom: Dimensions.height10),
                        padding: EdgeInsets.all(Dimensions.height10),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withOpacity(0.8),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.height20),bottomRight: Radius.circular(Dimensions.height20))
                        ),
                        child: TextWidget(text: mCQSModel.name!,fontSize: Dimensions.height20,)),
                    Container(
                      margin: EdgeInsets.only(left: Dimensions.height10,right: Dimensions.height10),
                      child: GridView.builder(
                          itemCount: mCQSModel.categoriesList!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 3,childAspectRatio: 1.0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: Dimensions.height15,
                            mainAxisExtent: Dimensions.height135 + 5,
                            crossAxisSpacing: 1,
                          ),
                          itemBuilder: (context, index) {
                            CategoriesModel categoriesModel = mCQSModel.categoriesList![index];
                            return InkWell(
                                onTap: () {
                                  context.read<MCQsDbProvider>().addSubCategoriesList(subCategories: categoriesModel.subCategories!);
                                  context.read<PointsProvider>().setAttemptCategory(categoriesModel.categoryName!);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SubCategoriesScreen(title: categoriesModel.categoryName!,),settings: const RouteSettings(
                                      arguments: "FromQuiz"
                                  )));
                                },
                                child: CategoriesContainerWidget(
                                  categoriesModel: categoriesModel,
                                ));
                          }),
                    ),
                  ],
                );
              });
        },
      )
    );
  }
}