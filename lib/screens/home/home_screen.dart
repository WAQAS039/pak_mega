import 'dart:convert';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:pak_mega_mcqs/common/model/categories_model.dart';
import 'package:pak_mega_mcqs/common/model/mcqs_db_model.dart';
import 'package:pak_mega_mcqs/common/model/tests_model.dart';
import 'package:pak_mega_mcqs/common/providers/admob_provider.dart';
import 'package:pak_mega_mcqs/common/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_provider.dart';
import 'package:pak_mega_mcqs/common/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/button_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/categories_container_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/text_widget.dart';
import 'package:pak_mega_mcqs/screens/application/provider.dart';
import 'package:pak_mega_mcqs/screens/categories/sub_categories/sub_categories_page.dart';
import 'package:pak_mega_mcqs/screens/home/provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // this index is for horizontal list on home page
  int _currentIndex = 0;
  // to handle view all or not
  bool _viewALl = false;
  IconData _viewIcon = Icons.keyboard_arrow_down_rounded;
  String _view = "View All";

  // to handle list scrolling
  ItemScrollController? itemScrollController;
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    // itemPositionsListener.itemPositions.addListener(() {
    //   var positions = itemPositionsListener.itemPositions.value.map((e) =>e.index).toList();
    //   currentIndex = positions[0];
    // });
  }
  @override
  Widget build(BuildContext context) {
    _viewALl = context.watch<HomeProvider>().viewAll;
    return Scaffold(
      backgroundColor: _viewALl ? AppColors.mainColor:Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h,),
            Center(child: TextWidget(text: "PK MCQS", fontSize: 28.sp,)),
            SizedBox(height: 20.h,),
            Consumer<ProfileProvider>(
              builder: (context, coinsValue, child) {
                return InkWell(
                    onTap: () async{
                      if(coinsValue.userModel!.coins == 0){
                        await outOfCoinsDialog(context);
                      }else{
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(RouteHelper.categoryPage);
                      }
                    },
                    child: ButtonWidget(text: "START QUIZ",textSize: 18.sp,textColor: AppColors.mainColor,radius: 30.r,));
              },
            ),
            buildMCQsRowContainer(context),
            Consumer2<MCQsDbProvider,HomeProvider>(
              builder: (context, mCQValue,home, child) {
                return mCQValue.mCQsList.isNotEmpty ? home.viewAll ? buildViewAllList(context, mCQValue):buildNotViewAllList(mCQValue, context) : const SpinKitDancingSquare(
                  color: AppColors.mainColor,
                );
              },
            ),
            const SizedBox(height: 5,),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.only(top: _viewALl ? 5.h : 0, bottom: _viewALl ? 10.h : 20.h,left: _viewALl ? 0 :25.w),
                  padding: _viewALl ? EdgeInsets.all(10.h) : EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: _viewALl ? AppColors.circleColor:Colors.transparent,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20.r),bottomRight: Radius.circular(20.r))
                  ),
                  child: TextWidget(text: "Exams Preparation",fontSize: 22.sp,textColor: _viewALl ? Colors.white : Colors.black,)),
            ),
            Consumer<MCQsDbProvider>(
              builder: (context, mCQValue, child) {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: _viewALl ? const NeverScrollableScrollPhysics():const ScrollPhysics(),
                      itemCount: mCQValue.testList.length,
                      itemBuilder: (context,index){
                        TestModel testModel = mCQValue.testList[index];
                        return InkWell(
                            onTap: (){
                              context.read<MCQsDbProvider>().addSubCategoriesList(subCategories: testModel.testSubCategories!);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SubCategoriesScreen(title: testModel.testName!),settings: const RouteSettings(arguments: "no")));
                            },
                            child: ButtonWidget(text: testModel.testName!,buttonColor: _viewALl ? Colors.white:AppColors.mainColor,radius: Dimensions.height20,height: Dimensions.height70 + 3,textColor: _viewALl ? AppColors.mainColor:Colors.white,));
                      }),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Container buildMCQsRowContainer(BuildContext context) {
    return Container(
          padding: EdgeInsets.only(left: 25.w,top: 8.h,bottom: 15.h,right: 25.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(text: 'MCQS', fontSize: 18.sp,),
              InkWell(
                  onTap: (){
                    if(!_viewALl){
                      context.read<HomeProvider>().setViewAll(true);
                      _viewIcon = Icons.keyboard_arrow_up_outlined;
                      _view = "Hide";
                    }else{
                      context.read<HomeProvider>().setViewAll(false);
                      _viewIcon = Icons.keyboard_arrow_down_rounded;
                      _view = "View All";
                    }
                  },
                  child: Row(
                    children: [
                      TextWidget(text: _view, fontSize: Dimensions.height15,),
                      Icon(_viewIcon,color: Colors.white,)
                    ],
                  )),
            ],
          ),
        );
  }

  Widget buildNotViewAllList(MCQsDbProvider mCQValue, BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap:(){
              if(mCQValue.categories.length > 5){
                _currentIndex = checkIndex(_currentIndex - 1);
                itemScrollController!.scrollTo(index: _currentIndex, duration: const Duration(milliseconds: 250));
              }
            },
            child: Container(
                margin: EdgeInsets.only(left: 2.w),
                child: Icon(Icons.arrow_back_ios_rounded,size: 20.h,))),
        Expanded(
            child: SizedBox(
              height: Dimensions.height135+3,
              child: ScrollablePositionedList.builder(
                  scrollDirection: Axis.horizontal,
                  // initialScrollIndex: currentIndex,
                  itemCount: mCQValue.categories.length,
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemBuilder: (context,index){
                    final CategoriesModel categoriesModel = mCQValue.categories[index];
                    return InkWell(
                        onTap: (){
                          context.read<MCQsDbProvider>().addSubCategoriesList(subCategories: categoriesModel.subCategories!);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SubCategoriesScreen(title: categoriesModel.categoryName!,),settings: const RouteSettings(arguments: "fromHome")));
                        },
                        child: CategoriesContainerWidget(categoriesModel: categoriesModel,));
                  }),
            )
        ),
        InkWell(
            onTap: (){
              if(_currentIndex < mCQValue.categories.length - 1){
                _currentIndex++;
                itemScrollController!.scrollTo(index: _currentIndex, duration: const Duration(milliseconds: 250));
              }
            },
            child: Container(
                margin: EdgeInsets.only(right: 2.w),
                child: Icon(Icons.arrow_forward_ios_rounded,size: 20.h,))),
      ],
    );
  }

  Widget buildViewAllList(BuildContext context, MCQsDbProvider mCQValue) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
          itemCount: mCQValue.mCQsList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            MCQsDbModel mCQSModel = mCQValue.mCQsList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 5,bottom: Dimensions.height10),
                    padding: EdgeInsets.all(Dimensions.height10),
                    decoration: BoxDecoration(
                        color: AppColors.circleColor,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.height20),bottomRight: Radius.circular(Dimensions.height20))
                    ),
                    child: TextWidget(text: mCQSModel.name!,fontSize: Dimensions.height20,textColor: Colors.white,)),
                Container(
                  margin: EdgeInsets.only(left: Dimensions.height10,right: Dimensions.height10),
                  child: GridView.builder(
                      itemCount: mCQSModel.categoriesList!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 3,childAspectRatio: 1.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: Dimensions.height10,
                        mainAxisExtent: Dimensions.height135 + 5,
                        crossAxisSpacing: 1,
                      ),
                      itemBuilder: (context, index) {
                        CategoriesModel categoriesModel = mCQSModel.categoriesList![index];
                        return InkWell(
                            onTap: () {
                              context.read<MCQsDbProvider>().addSubCategoriesList(subCategories: categoriesModel.subCategories!);
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
          }),
    );
  }

  Future<void> outOfCoinsDialog(BuildContext context) async {
     await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.mainColor,
          title: const Text('You are out of coins',style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: "aileron"),),
          content: Row(
            children: [
              Expanded(
                child: ElevatedButton(onPressed: (){
                  context.read<AdMobServicesProvider>().showRewardedAd(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
                }, child: Row(
                  children:  [
                    CircleAvatar(
                      radius: 10.r,
                      backgroundColor: AppColors.mainColor,
                      child: Icon(Icons.play_arrow,size: 15.h,color: Colors.white,),
                    ),
                    SizedBox(width: 5.w,),
                    Text("Watch Ad",style: TextStyle(fontSize: 10.sp,color: AppColors.mainColor),),
                  ],
                )),
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: ElevatedButton(onPressed: (){
                  context.read<ApplicationProvider>().setCurrentPage(0);
                  Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
                }, child: Row(
                  children: [
                    CircleAvatar(
                      radius: 10.r,
                      backgroundColor: AppColors.mainColor,
                      child: Icon(Icons.play_for_work_outlined,size: 15.h,color: Colors.white,),
                    ),
                    SizedBox(width: 5.w,),
                    Text("Buy Coins",style: TextStyle(fontSize: 10.sp,color: AppColors.mainColor),),
                  ],
                )),
              ),
            ],
          ),
        );
      },);
  }

  // to check horizontal listview index
  int checkIndex(int index){
    if(index < 0){
      return 0;
    }else{
      return index;
    }
  }
}


// await showDialog(
//   context: context,
//   builder: (ctx) {
//     return AlertDialog(
//       backgroundColor: AppColors.mainColor,
//       title: const Text('You are out of coins',style: TextStyle(fontSize: 20,color: Colors.white),),
//       content: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(onPressed: (){
//               context.read<AdMobServicesProvider>().showRewardedAd(context);
//               Navigator.of(context).pushReplacementNamed(RouteHelper.mainScreen);
//             }, child: Row(
//               children:  [
//                 const CircleAvatar(
//                   radius: 10,
//                   backgroundColor: AppColors.mainColor,
//                   child: Icon(Icons.play_arrow,size: 15,color: Colors.white,),
//                 ),
//                 const SizedBox(width: 5,),
//                 Text("Watch Ad",style: TextStyle(fontSize: Dimensions.height10,color: AppColors.mainColor),),
//               ],
//             )),
//           ),
//           const SizedBox(width: 5,),
//           Expanded(
//             child: ElevatedButton(onPressed: (){
//               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const MainScreen(initPosition: 0,)), (route) => false);
//             }, child: Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 10,
//                   backgroundColor: AppColors.mainColor,
//                   child: Icon(Icons.play_for_work_outlined,size: 15,color: Colors.white,),
//                 ),
//                 const SizedBox(width: 5,),
//                 Text("Buy Coins",style: TextStyle(fontSize: Dimensions.height10,color: AppColors.mainColor),),
//               ],
//             )),
//           ),
//         ],
//       ),
//     );
//   },);