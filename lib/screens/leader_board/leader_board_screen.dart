import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pak_mega_mcqs/common/model/user_model.dart';
import 'package:pak_mega_mcqs/screens/leader_board/leaderboard_provider.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_provider.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/text_widget.dart';
import 'package:provider/provider.dart';


class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  List days = ['24 hour','Weeks',"AllTimes"];
  Color textColor = Colors.black;
  int currentIndex = 0;
  List<UserModel> leaderListAllTimes = [];
  List<UserModel> allListWithoutTopThree = [];
  int network = 0;


  @override
  void initState() {
    network = context.read<int>();
    network = context.read<int>();
    if(network == 1){
      // context.read<LeaderBoardProvider>().getAllTimeLeaderBoardList(context);
      Future.delayed(const Duration(milliseconds: 1,),(){
        context.read<LeaderBoardProvider>().getTwentyFourHourList(context);
      });
    }else{
      Future.delayed(const Duration(seconds: 1),(){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Internet'),));
        }
      });
    }
    super.initState();
  }

  void initListOtherThanTopThree(){
    allListWithoutTopThree = [];
    if(leaderListAllTimes.length > 3){
      for(int i = 3;i<leaderListAllTimes.length;i++){
        allListWithoutTopThree.add(leaderListAllTimes[i]);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    leaderListAllTimes = context.watch<LeaderBoardProvider>().leaderBoardList;
    allListWithoutTopThree = context.watch<LeaderBoardProvider>().allListWithoutTopThree;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height10,),
              Container(
                margin: EdgeInsets.only(left: Dimensions.height40,right: Dimensions.height40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(days.length, (index) {
                    if(currentIndex == 0){
                      // leaderListAllTimes = context.watch<LeaderBoardProvider>().leaderBoardList;
                      initListOtherThanTopThree();
                    }
                    if(index == currentIndex){
                      setState(() {
                        textColor = AppColors.mainColor;
                      });
                    }else{
                      setState(() {
                        textColor = Colors.black;
                      });
                    }
                    return InkWell(
                      onTap: (){
                        setState(() {
                          currentIndex = index;
                        });
                        if(currentIndex == 0){
                          context.read<LeaderBoardProvider>().getTwentyFourHourList(context);
                          initListOtherThanTopThree();
                        }else if(currentIndex == 1){
                          context.read<LeaderBoardProvider>().getOneWeekLeaderBoardList(context);
                          initListOtherThanTopThree();
                        }else if(currentIndex == 2){
                          context.read<LeaderBoardProvider>().getAllTimeLeaderBoardList(context);
                        }
                      },
                      child: Container(
                        height: Dimensions.height30,
                        width: Dimensions.height80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.height20),
                            color: Colors.white
                        ),
                        child: Center(child: Text(days[index],style: TextStyle(color: textColor),)),
                      ),
                    );
                  }),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: Dimensions.height15,right: Dimensions.height15,top: Dimensions.height15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: leaderListAllTimes.length > 2 ? List.generate(3, (index) {
                      var leaderModel = index == 0? leaderListAllTimes[1] : index == 1 ? leaderListAllTimes[0]:leaderListAllTimes[index];
                      return LeaderBoardUserWidget(
                        name: leaderModel.name!,
                        points: leaderModel.points.toString(),
                        picture: leaderModel.image!,
                        imageType: leaderModel.imageType!,
                        bigRadius: index == 1 ? Dimensions.height50+5:Dimensions.height35,
                        smallRadius: index == 1 ? Dimensions.height15: Dimensions.height10,
                        index: index,
                      );
                    }) : [],
                  )
              )
            ],
          ),
          // const TextWidget(text: 'No Data to Show')
          SizedBox(height: Dimensions.height10,),
          leaderListAllTimes.length > 2 ? Flexible(
              child: Container(
                margin: EdgeInsets.only(top: Dimensions.height50+Dimensions.height20),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      itemCount: allListWithoutTopThree.length,
                      itemBuilder: (context,index){
                        var leaderModel = allListWithoutTopThree[index];
                        return Container(
                            height: Dimensions.height50+Dimensions.height35,
                            margin: EdgeInsets.only(top: Dimensions.height10,bottom: 5,left: Dimensions.height20,right: Dimensions.height20),
                            padding: EdgeInsets.only(top: Dimensions.height15,bottom: Dimensions.height15,left: Dimensions.height20,right: Dimensions.height20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.height10),
                              color: AppColors.mainColor.withOpacity(0.11),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text((index+4).toString()),
                                    const SizedBox(width: 10,),
                                    Row(
                                      children: [
                                        leaderModel.imageType == "asset" ? CircleAvatar(backgroundImage: Image.asset(leaderModel.image!).image,radius: Dimensions.height30,) :
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.height30),
                                          child: CachedNetworkImage(
                                            imageUrl: leaderModel.image!,
                                            fit: BoxFit.cover,
                                            height: Dimensions.height50,
                                            width: Dimensions.height50,
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),),
                                        ),
                                        const SizedBox(width: 5,),
                                        Text(leaderModel.name!),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset('assets/icons/leader_board_icons/star.png',height: Dimensions.height20,width: Dimensions.height20,),
                                    const SizedBox(width: 5,),
                                    Text(leaderModel.points.toString())
                                  ],
                                )
                              ],
                            )
                        );
                      }),
                ),
              )
          ): Container(
              margin: EdgeInsets.only(top: Dimensions.height110),
              child: currentIndex != 0 ? SpinKitDancingSquare(size: Dimensions.height50,color: Colors.white,): const TextWidget(text: 'No Data to Show'))
        ],
      ),
      bottomNavigationBar: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          return Container(
              height: Dimensions.height50+Dimensions.height30,
              padding: EdgeInsets.only(top: Dimensions.height15,bottom: Dimensions.height15,left: Dimensions.height20,right: Dimensions.height20),
              decoration: const BoxDecoration(
                color: AppColors.mainColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      currentIndex == 0 ?
                      Text(value.userModel!.twentyFourHourRank == 0 ? "UnRank" : value.userModel!.twentyFourHourRank.toString()) :
                      currentIndex == 1 ? Text(value.userModel!.weeklyRank == 0 ? "UnRank" : value.userModel!.weeklyRank.toString()) :
                      Text(value.userModel!.allTimeRank.toString()),
                      const SizedBox(width: 10,),
                      Row(
                        children: [
                          value.userModel!.imageType == "asset" ? CircleAvatar(backgroundImage: Image.asset(value.userModel!.image!).image,radius: Dimensions.height30,) :
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.height30),
                            child: CachedNetworkImage(
                              imageUrl: value.userModel!.image!,
                              fit: BoxFit.cover,
                              height: Dimensions.height50,
                              width: Dimensions.height50,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),),
                          ),
                          const SizedBox(width: 5,),
                          const Text("You"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset('assets/icons/leader_board_icons/star.png',height: Dimensions.height20,width: Dimensions.height20,),
                      const SizedBox(width: 5,),
                      Text(value.userModel!.points.toString())
                    ],
                  )
                ],
              )
          );
        },
      ),
    );
  }
}



class LeaderBoardUserWidget extends StatelessWidget {
  final String name;
  final String points;
  final String picture;
  final String imageType;
  final double bigRadius;
  final double smallRadius;
  final int index;
  const LeaderBoardUserWidget({
    Key? key,
    required this.name,
    required this.points,
    required this.picture,
    required this.imageType,
    required this.bigRadius,
    required this.smallRadius,
    required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimensions.height35+5,),
        Stack(
          clipBehavior: Clip.none,
          children: [
            index != 1 ? imageType == "asset" ? CircleAvatar(
              radius: bigRadius,
              backgroundImage: Image.asset(picture).image,
            ): ClipRRect(
              borderRadius: BorderRadius.circular(bigRadius),
              child: CachedNetworkImage(
                imageUrl: picture,
                fit: BoxFit.cover,
                height: Dimensions.height80-5,
                width: Dimensions.height80-5,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ) : CircleAvatar(
              radius: Dimensions.height50+10,
              backgroundColor: Colors.amber,
              child: imageType == "asset" ? CircleAvatar(
                radius: bigRadius,
                backgroundImage: Image.asset(picture).image,
              ) : ClipRRect(
                borderRadius: BorderRadius.circular(bigRadius),
               child: CachedNetworkImage(
                 fit: BoxFit.cover,
                 imageUrl: picture,
                 height: Dimensions.height110,
                 width: Dimensions.height110,
                 placeholder: (context, url) => const CircularProgressIndicator(),
                 errorWidget: (context, url, error) => const Icon(Icons.error),
               ),
              )
            ),
            index == 1 ? Positioned(
              top: -28.h,
                left: 0,
                right: 0,
                child: Image.asset('assets/icons/leader_board_icons/crowns.png',height: Dimensions.height35,width: Dimensions.height30+6,)):const SizedBox.shrink(),
            Positioned(
                bottom: Dimensions.height10,
                right: -5.w,
                child: CircleAvatar(
                  backgroundColor: index==1 ? Colors.amber:index==0?Colors.purpleAccent:Colors.grey,
                  radius: smallRadius,child: Center(child: TextWidget(text: '${index == 0 ? 2 : index == 1 ? 1 : index == 2 ? 3 : ''}',),),))
          ],
        ),
        const SizedBox(height: 3,),
        Text(name,style: TextStyle(fontSize: 10.h,color: Colors.white),),
        Container(
            width: Dimensions.height50+26,
            height: 1,
            margin: const EdgeInsets.only(top: 3,bottom: 3),
            color: Colors.white
        ),
        Row(
          children: [
            Image.asset('assets/icons/leader_board_icons/star.png',height: Dimensions.height20,width: Dimensions.height20,),
            SizedBox(width: 5.w,),
            Text(points,style: TextStyle(fontSize: 15.h,color: Colors.white),)
          ],
        ),
      ],
    );
  }
}

