import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pak_mega_mcqs/Widgets/text_widget.dart';
import 'package:pak_mega_mcqs/model/tests_model.dart';
import 'package:pak_mega_mcqs/providers/coins_provider.dart';
import 'package:pak_mega_mcqs/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/screens/categories/sub_categories_page.dart';
import 'package:pak_mega_mcqs/screens/home/main_screen.dart';
import 'package:pak_mega_mcqs/screens/login/profile_page.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:pak_mega_mcqs/widgets/main_screen_widget.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../Widgets/background_container.dart';
import '../../Widgets/button_widget.dart';
import '../../Widgets/drawer_widget.dart';
import '../../Widgets/user_pic_widget.dart';
import '../../model/categories_model.dart';
import '../../model/mcqs_db_model.dart';
import '../../providers/user_information_provider.dart';
import '../../widgets/categories_container_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ItemScrollController? itemScrollController;
  int currentIndex = 0;
  int length = 6;
  bool viewALl = false;
  IconData viewIcon = Icons.keyboard_arrow_down_rounded;
  String view = "View All";
  CountDownController countDownController = CountDownController();
  String? imagePath = '';
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();

    // itemPositionsListener.itemPositions.addListener(() {
    //   var positions = itemPositionsListener.itemPositions.value.map((e) =>e.index).toList();
    //   currentIndex = positions[0];
    // });
    imagePath = FirebaseAuth.instance.currentUser?.photoURL  ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: viewALl ? AppColors.mainColor:Colors.transparent,
      body: Consumer2<MCQsDbProvider,CoinsProvider>(
        builder: (ctx, mcqvalue, coinsValue, child) {
          return mcqvalue.mCQsList.isNotEmpty ? viewALl ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimensions.height20,),
                    Center(child: TextWidget(text: "PK MCQS", fontSize: Dimensions.height30,)),
                    SizedBox(height: Dimensions.height25,),
                    Consumer<CoinsProvider>(
                      builder: (ctx, value, child) {
                        return InkWell(
                            onTap: ()async{
                              if(value.coins == 0){
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.mainColor,
                                      title: const Text('You are out of coins',style: TextStyle(fontSize: 20,color: Colors.white),),
                                      content: Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(onPressed: (){
                                              coinsValue.getFreeReward(value.coins + 20, context);
                                              Navigator.of(ctx).pop();

                                            }, child: Row(
                                              children:  [
                                                const CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: AppColors.mainColor,
                                                  child: Icon(Icons.play_arrow,size: 15,color: Colors.white,),
                                                ),
                                                const SizedBox(width: 5,),
                                                Text("Watch Ad",style: TextStyle(fontSize: Dimensions.height10,color: AppColors.mainColor),),
                                              ],
                                            )),
                                          ),
                                          const SizedBox(width: 5,),
                                          Expanded(
                                            child: ElevatedButton(onPressed: (){
                                              // valMain.setCurrentPage(0);
                                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const MainScreen(initPosition: 0,)), (route) => false);
                                            }, child: Row(
                                              children: [
                                                const CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: AppColors.mainColor,
                                                  child: Icon(Icons.play_for_work_outlined,size: 15,color: Colors.white,),
                                                ),
                                                const SizedBox(width: 5,),
                                                Text("Buy Coins",style: TextStyle(fontSize: Dimensions.height10,color: AppColors.mainColor),),
                                              ],
                                            )),
                                          ),
                                        ],
                                      ),
                                    );
                                  },);
                              }else{
                                Navigator.of(context).pushNamed(RouteHelper.categoryPage);
                              }
                            },
                            child: ButtonWidget(text: "START QUIZ",textSize: Dimensions.height20-2,textColor: AppColors.mainColor,radius: Dimensions.height30,));
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.height30,top: Dimensions.height10-2,bottom: Dimensions.height15,right: Dimensions.height30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(text: 'MCQS', fontSize: Dimensions.height20,),
                          InkWell(
                              onTap: (){
                                if(!viewALl){
                                  setState(() {
                                    viewALl = true;
                                    viewIcon = Icons.keyboard_arrow_up_outlined;
                                    view = "Hide";
                                  });
                                }else{
                                  setState(() {
                                    viewALl = false;
                                    viewIcon = Icons.keyboard_arrow_down_rounded;
                                    view = "View All";
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  TextWidget(text: view, fontSize: Dimensions.height15,),
                                  Icon(viewIcon,color: Colors.white,)
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      itemCount: mcqvalue.mCQsList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        MCQsDbModel mCQSModel = mcqvalue.mCQsList[index];
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
                ),
                const SizedBox(height: 5,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      margin: EdgeInsets.only(top: 5,bottom: Dimensions.height10),
                      padding: EdgeInsets.all(Dimensions.height10),
                      decoration: BoxDecoration(
                          color: viewALl ? AppColors.circleColor:Colors.transparent,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.height20),bottomRight: Radius.circular(Dimensions.height20))
                      ),
                      child: TextWidget(text: "Exams Preparation",fontSize: Dimensions.height20+2,textColor: Colors.white,)),
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: viewALl ? const NeverScrollableScrollPhysics():const ScrollPhysics(),
                      itemCount: mcqvalue.testList.length,
                      itemBuilder: (context,index){
                        TestModel testModel = mcqvalue.testList[index];
                        return InkWell(
                            onTap: (){
                              context.read<MCQsDbProvider>().addSubCategoriesList(subCategories: testModel.testSubCategories!);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SubCategoriesScreen(title: testModel.testName!),settings: const RouteSettings(arguments: "no")));
                            },
                            child: ButtonWidget(text: testModel.testName!,buttonColor: viewALl ? Colors.white:AppColors.mainColor,radius: Dimensions.height20,height: Dimensions.height70 + 3,textColor: viewALl ? AppColors.mainColor:Colors.white,));
                      }),
                ),
              ],
            ),
          ):Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: TextWidget(text: "PK MCQS", fontSize: Dimensions.height30,)),
                  SizedBox(height: Dimensions.height25,),
                  Consumer<CoinsProvider>(
                    builder: (ctx, value,child) {
                      return InkWell(
                          onTap: () async{
                            if(value.coins == 0){
                              await showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.mainColor,
                                    title: const Text('You are out of coins',style: TextStyle(fontSize: 20,color: Colors.white),),
                                    content: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(onPressed: (){
                                            ctx.read<CoinsProvider>().getFreeReward(value.coins + 20, context);
                                            Navigator.of(ctx).pop();

                                          }, child: Row(
                                            children:  [
                                              const CircleAvatar(
                                                radius: 10,
                                                backgroundColor: AppColors.mainColor,
                                                child: Icon(Icons.play_arrow,size: 15,color: Colors.white,),
                                              ),
                                              const SizedBox(width: 5,),
                                              Text("Watch Ad",style: TextStyle(fontSize: Dimensions.height10,color: AppColors.mainColor),),
                                            ],
                                          )),
                                        ),
                                        const SizedBox(width: 5,),
                                        Expanded(
                                          child: ElevatedButton(onPressed: (){
                                            // valMain.setCurrentPage(0);
                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const MainScreen(initPosition: 0,)), (route) => false);
                                          }, child: Row(
                                            children: [
                                              const CircleAvatar(
                                                radius: 10,
                                                backgroundColor: AppColors.mainColor,
                                                child: Icon(Icons.play_for_work_outlined,size: 15,color: Colors.white,),
                                              ),
                                              const SizedBox(width: 5,),
                                              Text("Buy Coins",style: TextStyle(fontSize: Dimensions.height10,color: AppColors.mainColor),),
                                            ],
                                          )),
                                        ),
                                      ],
                                    ),
                                  );
                                },);
                            }else{
                              Navigator.of(context).pushNamed(RouteHelper.categoryPage);
                            }
                          },
                          child: ButtonWidget(text: "START QUIZ",textSize: Dimensions.height20-2,textColor: AppColors.mainColor,radius: Dimensions.height30,));
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(left: Dimensions.height30,top: Dimensions.height10-2,bottom: Dimensions.height15,right: Dimensions.height30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(text: 'MCQS', fontSize: Dimensions.height20,),
                        InkWell(
                            onTap: (){
                              if(!viewALl){
                                setState(() {
                                  viewALl = true;
                                  viewIcon = Icons.keyboard_arrow_up_outlined;
                                  view = "Hide";
                                });
                              }else{
                                setState(() {
                                  viewALl = false;
                                  viewIcon = Icons.keyboard_arrow_down_rounded;
                                  view = "View All";
                                });
                              }
                            },
                            child: Row(
                              children: [
                                TextWidget(text: view, fontSize: Dimensions.height15,),
                                Icon(viewIcon,color: Colors.white,)
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  InkWell(
                      onTap:(){
                        currentIndex = checkIndex(currentIndex - 1);
                        itemScrollController!.scrollTo(index: currentIndex, duration: const Duration(milliseconds: 250));
                      },
                      child: Icon(Icons.arrow_back_ios_rounded,size: Dimensions.height20,)),
                  Expanded(
                      child: SizedBox(
                        height: Dimensions.height135+3,
                        child: ScrollablePositionedList.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            initialScrollIndex: currentIndex,
                            itemCount: mcqvalue.categories.length,
                            itemScrollController: itemScrollController,
                            itemPositionsListener: itemPositionsListener,
                            itemBuilder: (context,index){
                              final CategoriesModel categoriesModel = mcqvalue.categories[index];
                              length = mcqvalue.categories.length;
                              return InkWell(
                                  onTap: (){
                                    context.read<MCQsDbProvider>().addSubCategoriesList(subCategories: categoriesModel.subCategories!);
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SubCategoriesScreen(title: categoriesModel.categoryName!,),settings: const RouteSettings(arguments: "fromHome")));
                                    // Navigator.of(context).pushNamed(RouteHelper.mcqPage);
                                  },
                                  child: CategoriesContainerWidget(categoriesModel: categoriesModel,));
                            }),
                      )
                  ),
                  InkWell(
                      onTap: (){
                        if(currentIndex < length - 1){
                          currentIndex++;
                          itemScrollController!.scrollTo(index: currentIndex, duration: const Duration(milliseconds: 250));
                        }
                      },
                      child: Icon(Icons.arrow_forward_ios_rounded,size: Dimensions.height20,)),
                ],
              ),
              const SizedBox(height: 5,),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: Dimensions.height30,bottom: Dimensions.height20),
                    padding: EdgeInsets.only(top: Dimensions.height10,),
                    child: TextWidget(text: "Exams Preparation",fontSize: Dimensions.height25,textColor: Colors.black,)),
              ),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      itemCount: mcqvalue.testList.length,
                      itemBuilder: (context,index){
                        TestModel testModel = mcqvalue.testList[index];
                        return InkWell(
                            onTap: (){
                              context.read<MCQsDbProvider>().addSubCategoriesList(subCategories: testModel.testSubCategories!);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SubCategoriesScreen(title: testModel.testName!,),settings: const RouteSettings(arguments: "fromTest")));
                            },
                            child: ButtonWidget(text: testModel.testName!,buttonColor: AppColors.mainColor,radius: Dimensions.height20,height: Dimensions.height70 + 3,));
                      }),
                ),
              ),
            ],
          ) : const SpinKitDancingSquare(
            color: AppColors.mainColor,
          );
        },
      ),
    );
  }
  int checkIndex(int index){
    if(index < 0){
      return 0;
    }else{
      return index;
    }
  }
}
