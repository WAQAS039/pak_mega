import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/Widgets/user_pic_widget.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:pak_mega_mcqs/widgets/text_widget.dart';

class DrawerWidget extends StatefulWidget {
  final String? url;
  const DrawerWidget({Key? key, this.url}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.mainColor,
      elevation: 0.0,
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
                      decoration:
                          const BoxDecoration(color: AppColors.mainColor2),
                      padding: EdgeInsets.zero,
                      curve: Curves.easeInOut,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          widget.url == "" ? const UserPicWidgetForOffline(radius: 50,)
                              : CircleAvatar(
                                  radius: Dimensions.height50 + 7,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: Image.network(widget.url!).image,
                                  ),
                                ),
                          TextWidget(
                              text: FirebaseAuth
                                  .instance.currentUser!.displayName!)
                        ],
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
                        color: index == currentIndex ? Colors.amber : Colors.transparent,
                      ),
                      Expanded(
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                            });
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
    );
  }
}

class DrawerItemsModel {
  String title;
  Widget icon;

  DrawerItemsModel({required this.title, required this.icon});
}

List<DrawerItemsModel> drawrItems = [
  DrawerItemsModel(
      title: "Home",
      icon: const ImageIcon(
        AssetImage(
          'assets/icons/home_page_icons/home.png',
        ),
        color: Colors.white,
      )),
  DrawerItemsModel(
      title: "Shop",
      icon: const ImageIcon(
        AssetImage('assets/icons/home_page_icons/shopping.png'),
        color: Colors.white,
      )),
  DrawerItemsModel(
      title: "Leaderboard",
      icon: const ImageIcon(
        AssetImage('assets/icons/home_page_icons/leader_board.png'),
        color: Colors.white,
      )),
  DrawerItemsModel(
      title: "Settings",
      icon: const Icon(
        Icons.settings,
        color: Colors.white,
      )),
  DrawerItemsModel(
      title: "Achievements",
      icon: const Icon(
        Icons.sports_golf,
        color: Colors.white,
      )),
  DrawerItemsModel(
      title: "Bookmarks",
      icon: const Icon(
        Icons.bookmark,
        color: Colors.white,
      )),
];
