import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_mega_mcqs/screens/login/auth_repo.dart';
import 'package:pak_mega_mcqs/common/model/subcategory_model.dart';
import 'package:pak_mega_mcqs/common/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/common/providers/network_error_provider.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_provider.dart';
import 'package:pak_mega_mcqs/common/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/custom_screen_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/easy_loading.dart';
import 'package:pak_mega_mcqs/common/widgets/network_check.dart';
import 'package:provider/provider.dart';


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
          child: Consumer2<MCQsDbProvider,ProfileProvider>(
            builder: (context, value, user, child) {
              return ListView.builder(
                  itemCount: value.subCategories.length,
                  itemBuilder: (context,index){
                    SubCategoryModel subCategoryModel = value.subCategories[index];
                    return InkWell(
                      onTap: () async{
                        if(user.userModel!.isOfflineEnable!){
                          context.read<MCQsDbProvider>().addQuestionList(questions: subCategoryModel.questions!);
                          Navigator.of(context).pushNamed( isFromHome == "fromHome" ? RouteHelper.mcqPage : RouteHelper.quizPage, );
                        }else{
                          EasyLoadingDialog.show(context: context,radius: 20.r,);
                          var network = Networks(onError: () async{
                            EasyLoadingDialog.dismiss(context);
                            await networkErrorDialog(context);
                          },onComplete: (){
                            EasyLoadingDialog.dismiss(context);
                            context.read<MCQsDbProvider>().addQuestionList(questions: subCategoryModel.questions!);
                            Navigator.of(context).pushNamed( isFromHome == "fromHome" ? RouteHelper.mcqPage : RouteHelper.quizPage, );
                          },);
                          network.doRequest();
                        }
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
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(subCategoryModel.subCategoryIcon!,height: Dimensions.height50,width: Dimensions.height50,),
                                VerticalDivider(color: Colors.black,endIndent: Dimensions.height10,indent: Dimensions.height10,)
                              ],),
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

  // Future<void> checkInternetConnection(BuildContext context, NetworkErrorProvider internet,String isFromHome, SubCategoryModel subCategoryModel) async {
  //   int network = context.read<int>();
  //   if(network == 1){
  //     // showLoadingDialog(context);
  //     EasyLoadingDialog.show(context: context,radius: 20.r,);
  //     context.read<NetworkErrorProvider>().setNetwork(network, context);
  //     if(internet.network == 1){
  //       // Navigator.of(context).pop();
  //       context.read<MCQsDbProvider>().addQuestionList(questions: subCategoryModel.questions!);
  //       Navigator.of(context).pushNamed( isFromHome == "fromHome" ? RouteHelper.mcqPage : RouteHelper.quizPage, );
  //     }else{
  //       await networkErrorDialog(context);
  //       // Navigator.of(context).pop();
  //     }
  //   }else{
  //     await networkErrorDialog(context);
  //   }
  // }

}

Future<void> networkErrorDialog(BuildContext context) async {
  await showDialog(context: context, builder: (context) {
    return const AlertDialog(
      content: NetworkCheck(),
    );
  },);
}
