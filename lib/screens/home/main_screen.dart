import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pak_mega_mcqs/Screens/home_screen_pages/home_screen.dart';
import 'package:pak_mega_mcqs/Screens/home_screen_pages/shoping_screen.dart';
import 'package:pak_mega_mcqs/model/bookmark_model.dart';
import 'package:pak_mega_mcqs/model/mcqs_db_model.dart';
import 'package:pak_mega_mcqs/providers/admob_provider.dart';
import 'package:pak_mega_mcqs/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/providers/setting_provider.dart';
import 'package:pak_mega_mcqs/providers/them_provider.dart';
import 'package:pak_mega_mcqs/providers/user_information_provider.dart';
import 'package:pak_mega_mcqs/data/repo/mcqsdb_repo.dart';
import 'package:pak_mega_mcqs/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/screens/home_screen_pages/leader_board_screen.dart';
import 'package:pak_mega_mcqs/screens/home_screen_pages/settings.dart';
import 'package:pak_mega_mcqs/screens/results/achievements_screen.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:pak_mega_mcqs/widgets/main_screen_widget.dart';
import 'package:pak_mega_mcqs/widgets/page_transition_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/offline_database.dart';
import '../../Widgets/text_widget.dart';
import '../../Widgets/user_pic_widget.dart';
import '../../model/tests_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/points_provider.dart';
import '../../widgets/drawer_widget.dart';
import '../login/profile_page.dart';

class MainScreen extends StatefulWidget {
  final int? initPosition;
  const MainScreen({Key? key,this.initPosition = 1}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // current page is home
  int currentPage = 1;
  int currentIndex = 0;
  int network = 0;

  Future<void> checkDb() async {
      SharedPreferences sharePreferences = await SharedPreferences.getInstance();
      int? status = sharePreferences.getInt("dbStatus");
      if(status == 1){
        context.read<MCQsDbProvider>().resetMCQsList();
        context.read<MCQsDbProvider>().resetCategoriesList();
        context.read<MCQsDbProvider>().resetAllSubCategoriesList();
        context.read<MCQsDbProvider>().resetQuestionsList();
        context.read<MCQsDbProvider>().resetTestList();
        List<TestModel> testList = await MCQsLDbRepo.getTestsFromLocalDb();
        context.read<MCQsDbProvider>().addTestList(tests: testList);
        List<MCQsDbModel> mCQSList = await MCQsLDbRepo.getCategoriesFromLocalDb();
        context.read<MCQsDbProvider>().addMCQsList(mCQsList: mCQSList);
        var categories = context.read<MCQsDbProvider>().categories;
        if (categories.isEmpty) {
          print('calling from main');
          for (int i = 0; i < mCQSList.length; i++) {
            MCQsDbModel mcQsDbModel = mCQSList[i];
            context.read<MCQsDbProvider>().addCategoriesList(categoriesList: mcQsDbModel.categoriesList!);
          }
        }
      }
  }

  @override
  void initState() {
    super.initState();
    // context.read<UserInformationProvider>().getProfileImage(userName: 'waqas');
    // checkDb();
    network = context.read<int>();
    if(FirebaseAuth.instance.currentUser !=null){
      context.read<UserInformationProvider>().getUserData(FirebaseAuth.instance.currentUser!.uid,context);
    }
    currentPage = widget.initPosition!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<int>(context);
    var screen = [
      const ShoppingScreen(),
      const HomeScreen(),
      const LeaderBoardScreen(),
    ];
    // int network = Provider.of<int>(context);
    // BannerAd bannerAd = context.watch<AdMobServicesProvider>().showBanner();
    // getData(context);
    return Scaffold(
        body: Consumer<SettingsProvider>(
          builder: (context, value, child) {
            return MainScreenWidget(
                mainContainerHeight: currentPage == 1 ? Dimensions.height360 + 20 : currentPage == 0 ? Dimensions.height360 - 20 : Dimensions.height360 +60,
                mainCircleTop: Dimensions.height200,
                child: Positioned.fill(
                    top: Dimensions.height20,
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(
                              left: Dimensions.height10,
                              right: Dimensions.height10,
                              top: Dimensions.height20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Builder(builder: (context) {
                                return IconButton(
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    icon: const Icon(
                                      Icons.list,
                                      color: Colors.white,
                                    ));
                              }),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const ProfileScreen()));
                                    // UserInfoRepo().pickImage();
                                    // getUserImage();
                                  },
                                  child: Consumer<UserInformationProvider>(
                                    builder: (context, value, child) {
                                      return value.userModel != null ? UserPicWidget(imageUrl: value.userModel!.image! ?? "",imageType: value.userModel!.imageType!) : const SizedBox.shrink();
                                    },
                                  ))
                            ],
                          ),
                        ),
                        Expanded(child: screen[currentPage]),
                      ],
                    )));
          },
        ),
            // : screen[currentPage],
        drawer: Container(
          padding: EdgeInsets.only(top: Dimensions.height98),
          width: Dimensions.width280,
          child: Drawer(
            backgroundColor: AppColors.mainColor,
            elevation: 0.0,
            child: Stack(
              children: [
                Positioned(
                    top: -Dimensions.height135,
                    left: -Dimensions.height135,
                    child: Image.asset('assets/icons/coins_page_icons/main_circle.png',height: Dimensions.height260,color: Colors.white.withOpacity(0.5),)),
                Positioned(
                    bottom: -Dimensions.height50,
                    right: -Dimensions.height50,
                    child: Image.asset('assets/icons/coins_page_icons/main_circle.png',height: Dimensions.height260,color: Colors.white.withOpacity(0.5),)),
                Positioned(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              child: DrawerHeader(
                                  padding: EdgeInsets.zero,
                                  curve: Curves.easeInOut,
                                  child: Consumer<UserInformationProvider>(
                                    builder: (context, value, child) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          value.userModel != null ? CircleAvatar(
                                            radius: Dimensions.height50 + 7,
                                            backgroundColor: Colors.white,
                                            child: value.userModel!.imageType == "asset" ?CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(value.userModel!.image!),
                                            ) : ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl: value.userModel!.image!,
                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                          ) : const SizedBox.shrink(),
                                          TextWidget(
                                              text: value.userModel!.name!)
                                        ],
                                      );
                                    },
                                  )),
                            )
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: drawrItems.length,
                            itemBuilder: (context, index) {
                              DrawerItemsModel model = drawrItems[index];
                              return Row(
                                children: [
                                  Container(
                                    width: 5,
                                    height: Dimensions.height50,
                                    color: index == currentIndex
                                        ? Colors.amber
                                        : Colors.transparent,
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      onTap: () async{
                                        setState(() {
                                          currentIndex = index;
                                        });
                                        if(index == 0){
                                          setState(() {
                                            currentPage = 1;
                                          });
                                          Navigator.of(context).pop();
                                        }else if(index == 1){
                                          setState(() {
                                            currentPage = 0;
                                          });
                                          Navigator.of(context).pop();
                                        }else if(index == 2){
                                          setState(() {
                                            currentPage = 2;
                                          });
                                          Navigator.of(context).pop();
                                        }else if(index == 3){
                                          Navigator.of(context).push(pageTransition(const Settings(),const Offset(-1.0, 1.0)));
                                        }else if(index == 4){
                                          Navigator.of(context).push(pageTransition(const AchievementsScreen(),const Offset(1.0, 0.2)));
                                          // Navigator.of(context).pushNamed(RouteHelper.achievementsPage);
                                        }else if(index == 5){
                                          context.read<MCQsDbProvider>().resetBookmarkList();
                                          List<BookmarkModel> bookmarks = await OfflineDatabase().getBookmark();
                                          context.read<MCQsDbProvider>().addBookmarkList(bookmarks: bookmarks);
                                          Navigator.of(context).pushNamed(RouteHelper.bookmarkPage);
                                        }
                                      },
                                      title: Text(model.title),
                                      leading: model.icon,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Consumer<UserInformationProvider>(
                      builder: (context, value, child) {
                        return ListTile(
                          onTap: () async{
                            SharedPreferences sharePreferences = await SharedPreferences.getInstance();
                            if(value.userModel!.loginType == "google"){
                              sharePreferences.clear();
                              context.read<MCQsDbProvider>().resetAllList();

                              OfflineDatabase().deleteTestListFromLocalDb();
                              OfflineDatabase().deleteCategoriesListFromLocalDb();
                              AuthProvider().logoutFromGoogle();
                            }else if(value.userModel!.loginType == "facebook"){
                              sharePreferences.clear();
                              context.read<MCQsDbProvider>().resetAllList();
                              OfflineDatabase().deleteTestListFromLocalDb();
                              OfflineDatabase().deleteCategoriesListFromLocalDb();
                              AuthProvider().logoutFromFacebook();
                            }else if(value.userModel!.loginType == "guest"){
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                useRootNavigator: false,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text('If You Sign out your all data will be lost'),
                                    actions: [
                                      TextButton(onPressed: (){
                                        Navigator.of(context).pop();
                                      }, child: const TextWidget(text: "Cancel",textColor: Colors.black,)),
                                      TextButton(onPressed: (){
                                        sharePreferences.clear();
                                        context.read<MCQsDbProvider>().resetAllList();
                                        OfflineDatabase().deleteTestListFromLocalDb();
                                        OfflineDatabase().deleteCategoriesListFromLocalDb();
                                        AuthProvider().logoutFromGuest();
                                        Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.initRoute, (route) => false);
                                      }, child: const TextWidget(text: "Ok",textColor: Colors.black,))
                                    ],
                                  );
                                },);
                              // AuthProvider().logoutFromGuest();
                            }
                            Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.initRoute, (route) => false);
                          },
                          leading: const Icon(Icons.logout_outlined),
                          title: const Text('Sign Out'),
                        );
                      },
                    )
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage(
                        'assets/icons/home_page_icons/shopping.png'))),
                BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(
                        AssetImage('assets/icons/home_page_icons/home.png'))),
                BottomNavigationBarItem(
                    label: '',
                    icon: ImageIcon(AssetImage(
                        'assets/icons/home_page_icons/leader_board.png'))),
              ],
              currentIndex: currentPage,
              iconSize: Dimensions.height30,
              selectedIconTheme: IconThemeData(size: Dimensions.height50 - 10),
              unselectedIconTheme: IconThemeData(color: Colors.grey.shade500),
              selectedItemColor: AppColors.mainColor,
              onTap: (index) {
                setState(() {
                  currentPage = index;
                });
                // value.setCurrentPage(index);
                if(index == 1){
                  setState(() {
                    currentIndex = 0;
                  });
                }else if(index == 0){
                  setState(() {
                    currentIndex = 1;
                  });
                }else if(index == 2){
                  setState(() {
                    currentIndex = 2;
                  });
                }
              },
            ),
            // AdMobWidget(bannerAd: bannerAd,)
          ],
        ));
  }
}
