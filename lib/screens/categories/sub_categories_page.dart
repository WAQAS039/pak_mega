import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/model/subcategory_model.dart';
import 'package:pak_mega_mcqs/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:pak_mega_mcqs/widgets/custom_screen_widget.dart';
import 'package:provider/provider.dart';

import '../../routes/routes_helper.dart';
import '../../utils/app_colors.dart';

class SubCategoriesScreen extends StatelessWidget {
  final String title;
  const SubCategoriesScreen({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? isFromHome = ModalRoute.of(context)!.settings.arguments as String;
    return CustomScreenWidget(
        title: title,
        onPress: (){
          context.read<MCQsDbProvider>().resetAllSubCategoriesList();
          Navigator.of(context).pop();
        },
        appBarColor: AppColors.mainColor,
        child: WillPopScope(
          onWillPop: () async{
            context.read<MCQsDbProvider>().resetAllSubCategoriesList();
            return true;
          },
          child: Consumer<MCQsDbProvider>(
            builder: (context, value, child) {
              return ListView.builder(
                  itemCount: value.subCategories.length,
                  itemBuilder: (context,index){
                    SubCategoryModel subCategoryModel = value.subCategories[index];
                    return InkWell(
                      onTap: () async{
                        context.read<MCQsDbProvider>().addQuestionList(questions: subCategoryModel.questions!);
                        Navigator.of(context).pushNamed( isFromHome == "fromHome" ? RouteHelper.mcqPage : RouteHelper.quizPage, );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: Dimensions.height10,right: Dimensions.height10,top: Dimensions.height10,bottom: 3),
                        height: Dimensions.height80,
                        decoration: BoxDecoration(
                            color: AppColors.subCategoryContainerColor,
                            borderRadius: BorderRadius.circular(Dimensions.height10),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.5),offset: const Offset(0.5,0.5),blurRadius: 2)
                            ]
                        ),
                        child: Center(
                          child: ListTile(
                            leading: isFromHome != "fromTest" ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(subCategoryModel.subCategoryIcon!,height: Dimensions.height50,width: Dimensions.height50,),
                                VerticalDivider(color: Colors.black,endIndent: Dimensions.height10,indent: Dimensions.height10,)
                              ],) : const SizedBox.shrink(),
                            title: Text(subCategoryModel.subCategoryName!,style: TextStyle(fontSize: Dimensions.height15+2),),
                            trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black,),
                          ),
                        ),
                      ),
                    );
                  });
            },
          )
        ));
  }
}
