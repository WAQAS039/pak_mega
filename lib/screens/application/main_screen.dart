import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pak_mega_mcqs/common/database/offline_database.dart';
import 'package:pak_mega_mcqs/common/model/bookmark_model.dart';
import 'package:pak_mega_mcqs/common/model/mcqs_db_model.dart';
import 'package:pak_mega_mcqs/common/model/tests_model.dart';
import 'package:pak_mega_mcqs/common/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/common/utils/app_constants.dart';
import 'package:pak_mega_mcqs/screens/init_setup/init_setup_provider.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_provider.dart';
import 'package:pak_mega_mcqs/common/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/drawer_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/main_screen_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/page_transition_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/text_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/user_pic_widget.dart';
import 'package:pak_mega_mcqs/screens/application/provider.dart';
import 'package:pak_mega_mcqs/screens/home/home_screen.dart';
import 'package:pak_mega_mcqs/screens/leader_board/leader_board_screen.dart';
import 'package:pak_mega_mcqs/screens/settings/settings.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_page.dart';
import 'package:pak_mega_mcqs/screens/results/achievements_screen.dart';
import 'package:pak_mega_mcqs/screens/shoping/free_rewared/provider.dart';
import 'package:pak_mega_mcqs/screens/shoping/shoping_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key,}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
    // get timer after coming
    Future.delayed(Duration.zero, () {
      if(mounted){
        context.read<TimerProvider>().handleAppClose();
        checkDbStatus(context);
      }
    });
    // context.read<AdMobServicesProvider>().loadRewardedAd();
    // context.read<AdMobServicesProvider>().loadInAd();
  }


  void checkDbStatus(BuildContext context) {
    int status = Hive.box(appBox).get(dbStatus) ?? 0;
    if (status == 1) {
      context.read<MCQsDbProvider>().resetAllList();
      List<MCQsDbModel> mCQSList = context.read<InitSetUpProvider>().getCategoriesFromLocalDb();
      if(mCQSList.isNotEmpty){
        context.read<MCQsDbProvider>().addMCQsList(mCQsList: mCQSList);
      }
      List<TestModel> testList = context.read<InitSetUpProvider>().getTestsFromLocalDb();
      if(testList.isNotEmpty){
        context.read<MCQsDbProvider>().addTestList(tests: testList);
      }
      var categories = context.read<MCQsDbProvider>().categories;
      if (categories.isEmpty) {
        for (int i = 0; i < mCQSList.length; i++) {
          MCQsDbModel mcQsDbModel = mCQSList[i];
          context.read<MCQsDbProvider>().addCategoriesList(categoriesList: mcQsDbModel.categoriesList!);
        }
      }

      // print('status 1');
      // print("--------$testList----------");
      // print("----------$mCQSList-----------");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screen = [
      const ShoppingScreen(),
      const HomeScreen(),
      const LeaderBoardScreen(),
    ];
    return Scaffold(
        body: Consumer<ApplicationProvider>(
              builder: (context, value, child) {
                // show circle if home else don't show
                return value.currentPage != 0 ? MainScreenWidget(
                    mainContainerHeight: 340.h,
                    mainCircleTop: 220.h,
                    child: Positioned.fill(
                        top: Dimensions.height20,
                        child: Column(
                          children: [
                            // if home page show profile icon else don't
                            value.currentPage != 2 ? Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.only(left: Dimensions.height10, right: Dimensions.height10, top: Dimensions.height20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // builder because to open drawer
                                  Builder(builder: (context) {
                                    return IconButton(
                                        onPressed: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        icon: const Icon(Icons.list, color: Colors.white,));
                                  }),
                                  // profile icon
                                  InkWell(onTap: () {
                                    Navigator.of(context).pushNamed(RouteHelper.profile);
                                    // context.read<AdMobServicesProvider>().showInterstitialAd();
                                  }, child: Consumer<ProfileProvider>(
                                    builder: (context, value, child) {
                                      return value.userModel != null
                                          ? UserPicWidget(
                                          imageUrl: value.userModel!.image! ?? "", imageType: value.userModel!.imageType!)
                                          : const SizedBox.shrink();
                                    },
                                  ))
                                ],
                              ),
                            ) : SizedBox(height: 60.h,),
                            Expanded(child: screen[value.currentPage]),
                          ],
                        ))) : screen[value.currentPage];
              },
            ),
        drawer: Container(
          padding: EdgeInsets.only(top: 98.h),
          width: 280.w,
          child: Drawer(
            backgroundColor: AppColors.mainColor,
            elevation: 0.0,
            child: Stack(
              children: [
                // circle design
                Positioned(
                    top: -Dimensions.height135,
                    left: -Dimensions.height135,
                    child: Image.asset(
                      'assets/icons/coins_page_icons/main_circle.png',
                      height: Dimensions.height260,
                      color: Colors.white.withOpacity(0.5),
                    )),
                Positioned(
                    bottom: -Dimensions.height50,
                    right: -Dimensions.height50,
                    child: Image.asset(
                      'assets/icons/coins_page_icons/main_circle.png',
                      height: Dimensions.height260,
                      color: Colors.white.withOpacity(0.5),
                    )),
                buildDrawerItemList(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Consumer<ApplicationProvider>(
          builder: (context, value, child) {
            return BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage('assets/icons/home_page_icons/shopping.png'))),
                BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage('assets/icons/home_page_icons/home.png'))),
                BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage('assets/icons/home_page_icons/leader_board.png'))),
              ],
              currentIndex: value.currentPage,
              iconSize: 30.h,
              selectedIconTheme: IconThemeData(size: 35.h),
              unselectedIconTheme: IconThemeData(color: Colors.grey.shade500),
              selectedItemColor: AppColors.mainColor,
              onTap: (index) {
                value.setCurrentPage(index);
                if(index == 0){
                  value.setDrawerCurrent(1);
                }else if(index == 1){
                  value.setDrawerCurrent(0);
                }else if(index == 2){
                  value.setDrawerCurrent(2);
                }
              },
            );
          },
        ));
  }

  Positioned buildDrawerItemList() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Consumer<ApplicationProvider>(
        builder: (context, drawerValue, child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildUserPictureAndNameSizedBox(),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Expanded(
                  child: ListView.builder(
                      itemCount: drawrItems.length,
                      itemBuilder: (context, index) {
                        DrawerItemsModel model = drawrItems[index];
                        return Row(
                          children: [
                            Container(
                              width: 5,
                              height: Dimensions.height50,
                              color: index == drawerValue.drawerCurrentIndex ? Colors.amber : Colors.transparent,
                            ),
                            Expanded(
                              child: ListTile(
                                onTap: () async {
                                  drawerValue.setDrawerCurrent(index);
                                  if(index <= 2){
                                    // to handle bottom nav from drawer widget
                                    if(index == 0){
                                      drawerValue.setCurrentPage(1);
                                      Navigator.of(context).pop();
                                    }else if(index == 1){
                                      drawerValue.setCurrentPage(0);
                                      Navigator.of(context).pop();
                                    }else{
                                      drawerValue.setCurrentPage(2);
                                      Navigator.of(context).pop();
                                    }
                                  }else{
                                    // to handle other screens
                                    if(index == 3){
                                      Navigator.of(context).push(pageTransition(const Settings(), const Offset(-1.0, 1.0)));
                                    }else if(index == 4){
                                      Navigator.of(context).push(pageTransition(const AchievementsScreen(), const Offset(1.0, 0.2)));
                                    }else if(index == 5){
                                      context.read<MCQsDbProvider>().resetBookmarkList();
                                      List<BookmarkModel> bookmarks = await OfflineDatabase().getBookmark();
                                      context.read<MCQsDbProvider>().addBookmarkList(bookmarks: bookmarks);
                                      Navigator.of(context).pushNamed(RouteHelper.bookmarkPage);
                                    }
                                  }
                                  },
                                title: Text(model.title),
                                leading: model.icon,
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
              buildSignOutListTile()
            ],
          );
          },
      ),
    );
  }

  Consumer<ProfileProvider> buildSignOutListTile() {
    return Consumer<ProfileProvider>(
      builder: (context, value, child) {
        return ListTile(
          onTap: () async {
            SharedPreferences sharePreferences =
            await SharedPreferences.getInstance();
            if (value.userModel!.loginType == "facebook" || value.userModel!.loginType == "google") {
              showDialogForNormalUser(sharePreferences, context, value.userModel!.loginType!);
            } else if (value.userModel!.loginType == "guest") {
              showDialogForGuestUser(sharePreferences, context);
            }
            },
          leading: const Icon(Icons.logout_outlined),
          title: const Text('Sign Out'),
        );
        },
    );
  }

  SizedBox buildUserPictureAndNameSizedBox() {
    return SizedBox(
      width: double.maxFinite,
      child: DrawerHeader(
          padding: EdgeInsets.zero,
          curve: Curves.easeInOut,
          child: Consumer<ProfileProvider>(
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  value.userModel != null
                      ? CircleAvatar(radius: Dimensions.height50 + 7, backgroundColor: Colors.white, child: value.userModel!.imageType == "asset"
                      ? CircleAvatar(radius: 50, backgroundImage: AssetImage(value.userModel!.image!),) : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child:
                    CachedNetworkImage(imageUrl: value.userModel!.image!,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  )
                      : const SizedBox.shrink(),
                  TextWidget(text: value.userModel!.name!)
                ],
              );
              },
          )),
    );
  }
}
