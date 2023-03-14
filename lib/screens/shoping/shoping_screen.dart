import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pak_mega_mcqs/common/providers/in_app_purchase_providers/repeatable_purchase.dart';
import 'package:pak_mega_mcqs/screens/profile/profile_provider.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/widgets/custom_screen_widget.dart';
import 'package:pak_mega_mcqs/screens/shoping/purchase/purchase_page.dart';
import 'package:provider/provider.dart';
import 'free_rewared/free_rewared_page.dart';
import 'free_rewared/provider.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<ProductDetails> _products = [];
  int currentIndex = 0;
  var pages = [const FreeRewardedPage(), const PurchasePage()];
  Timer? _timer;
  int _secondsRemaining = 8 * 60 * 60; // 8 hours in seconds

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (_secondsRemaining < 1) {
          timer.cancel();
        } else {
          _secondsRemaining -= 1;
        }
      }),
    );
  }

  String get timerText {
    final hours = _secondsRemaining ~/ 3600;
    final minutes = (_secondsRemaining % 3600) ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${hours.toString().padLeft(2, '0')}h${minutes.toString().padLeft(2, '0')}m${seconds.toString().padLeft(2, '0')}s';
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCoins();
    startTimer();
    context.read<TimerProvider>().startTimer();
  }

  @override
  void dispose() {
    _timer!.cancel();
    // TimerProvider().stopTimer();
    super.dispose();
  }

  void _loadCoins() {
    Future.delayed(const Duration(milliseconds: 1), () {
      var coins = context.read<ProfileProvider>().userModel!.coins!;
      // context.read<CoinsProvider>().setCoins(coins);
    });
  }

  Future<void> _loadProducts() async {
    final productIds = [
      'com.example.item1',
      'com.example.item2',
      'com.example.item3'
    ];
    final productResult =
        await InAppPurchase.instance.queryProductDetails(productIds.toSet());
    if (mounted) {
      setState(() {
        _products = productResult.productDetails;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final repeatablePurchase = Provider.of<RepeatablePurchase>(context);
    var color = const Color(0xFF279485);
    return CustomScreenWidget(
        title: "Rewards",
        isBack: false,
        onPress: () {},
        isShowAd: false,
        coins: buildCoinsContainer(),
        child: Consumer<ProfileProvider>(
          builder: (context, value, child) {
            return Column(
              children: [
                currentIndex == 1
                    ? buildBuyingAdFreeContainer()
                    : buildTimerContainer(),
                buildOptionsContainer(),
                Expanded(child: pages[currentIndex])
              ],
            );
          },
        ));
  }

  Container buildCoinsContainer() {
    return Container(
        margin: EdgeInsets.only(left: 10.w,right: 10.w,top: 25.h,bottom: 25.h),
        height: 30.h,
        width: 60.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: AppColors.mainColor2
        ),
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.only(top: 5.h,bottom: 5.h,left: 10.w),
                child: Image.asset("assets/icons/coins_page_icons/coin.png")),
            Consumer<ProfileProvider>(
             builder: (context, value, child) {
               return Text("   ${value.userModel!.coins}",style: TextStyle(
                   fontFamily: "Aileron",
                   fontSize: 10.sp
               ),);
             },
            )
          ],
        ),
      );
  }

  Container buildTimerContainer() {
    return Container(
                      margin: EdgeInsets.only(top: 18.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'End in: ',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Aileron',
                                    fontWeight: FontWeight.w700),
                              ),
                              const Icon(Icons.access_time),
                              Consumer<TimerProvider>(
                                builder: (context, timer, child) {
                                  return Text(
                                    " ${' ${timer.timerText}'}",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontFamily: 'Aileron',
                                        fontWeight: FontWeight.bold),
                                  );
                                },
                              )
                            ],
                          ),
                          Text(
                            'Watch  an ad video to collect rewards',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontFamily: 'Aileron',
                            ),
                          )
                        ],
                      ),
                    );
  }

  Container buildBuyingAdFreeContainer() {
    return Container(
                      margin: EdgeInsets.only(top: 18.h),
                      child: Text(
                        'Buying Ad free will not remove rewarded Ads. These ads are necessary  to reward you',
                        style: TextStyle(fontSize: 17.sp, fontFamily: "Aileron"),
                        textAlign: TextAlign.center,
                      ));
  }

  Container buildOptionsContainer() {
    return Container(
                margin: EdgeInsets.only(left: 14.w, right: 14.w, top: 30.h),
                child: Row(
                  children: List.generate(
                    2,
                    (index) => Expanded(
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            child: buildOptionContainer(
                                index == 0 ? "Free Rewards" : "Purchase",
                                index))),
                  ),
                ),
              );
  }

  Container buildOptionContainer(String title, int index) {
    return Container(
      height: 32.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: index == currentIndex
              ? AppColors.mainColor
              : AppColors.subCategoryContainerColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(5.r), topLeft: Radius.circular(5.r))),
      child: Text(title,
          style: TextStyle(
              fontSize: 13.sp,
              fontFamily: "Aileron",
              color: index == currentIndex ? Colors.white : Colors.black)),
    );
  }
}

// void countDownTimer() {
//   Duration _duration = const Duration(hours: 8);
//   DateTime _startTime = DateTime.now();
//   DateTime _endTime = _startTime.add(_duration);
//   Timer.periodic(Duration(seconds: 1), (timer) {
//     Duration _remainingTime = _endTime.difference(DateTime.now());
//     if (_remainingTime.isNegative) {
//       timer.cancel();
//       print('Timer ended');
//     } else {
//       print(
//           '${_remainingTime.inHours}h ${_remainingTime.inMinutes.remainder(60)}m ${_remainingTime.inSeconds.remainder(60)}s');
//     }
//   });
// }

class CoinsModel {
  String price;
  int coins;

  CoinsModel({required this.price, required this.coins});
}

List<CoinsModel> coinsList = [
  CoinsModel(price: '20', coins: 10),
  CoinsModel(price: "40", coins: 20),
  CoinsModel(price: "60", coins: 30),
];

// Column(
// children: [
// Image.asset('assets/icons/coins_page_icons/coins_logo.png',height: Dimensions.height98,width: Dimensions.height98,),
// const SizedBox(height: 11,),
// Consumer<UserInformationProvider>(
// builder: (context, value, child) => TextWidget(text: value.userModel!.coins.toString(),fontSize: Dimensions.height30,),
// ),
// Text('Total Coins',style: TextStyle(
// decoration: TextDecoration.overline,
// fontSize: Dimensions.height20,
// color: Colors.white
// ),),
// Expanded(
// child: Container(
// width: double.maxFinite,
// margin: EdgeInsets.only(top: Dimensions.height98,left: Dimensions.height30,right: Dimensions.height30),
// padding: EdgeInsets.all(Dimensions.height20),
// decoration: BoxDecoration(
// color: AppColors.mainColor,
// borderRadius: BorderRadius.circular(Dimensions.height10)
// ),
// child: SingleChildScrollView(
// child: Column(
// children: [
// const TextWidget(text: 'BUY COINS',),
// _products.isNotEmpty ? MediaQuery.removePadding(
// context: context,
// removeTop: true,
// child: ListView.builder(
// itemCount: _products.length,
// shrinkWrap: true,
// physics: const ScrollPhysics(),
// itemBuilder: (context,index){
// ProductDetails product = _products[index];
// return Container(
// height: Dimensions.height50+10,
// margin: EdgeInsets.only(top: Dimensions.height15),
// decoration: BoxDecoration(
// color: color,
// borderRadius: BorderRadius.circular(Dimensions.height10),
// boxShadow: [
// BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 0.5),
// ],
// ),
// child: ListTile(
// leading: Image.asset('assets/icons/coins_page_icons/coin.png',height: Dimensions.height30,width: Dimensions.height30,),
// title: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Image.asset('assets/icons/coins_page_icons/coin.png',height: Dimensions.height15,width: Dimensions.height15,),
// const SizedBox(width: 8.4,),
// TextWidget(text: product.price)],),
// trailing: InkWell(
// onTap: () async{
// if(product.price == 'Free'){
// // context.read<CoinsProvider>().getFreeReward(5, context);
// }else{
// await showDialog(context: context, builder: ((context) {
// return AlertDialog(
// title: Text('Buy ${product.price} with in ${product.price}${product.currencyCode}'),
// actions: [
// TextButton(onPressed: (){
// repeatablePurchase.purchaseItem(product, value.userModel!.name!,context);
// Navigator.of(context).pop();
// }, child: const TextWidget(text: 'Pay',textColor: Colors.black,)),
// TextButton(onPressed: (){
// Navigator.of(context).pop();
// }, child: const TextWidget(text: 'Cancel',textColor: Colors.black,))
// ],
// );
// }));
// }
// },
// child: TextWidget(text: '\$${product.price}',)),
// ),
// );
// },
// ) ,
// ) : Container(
// height: Dimensions.height98,
// alignment: Alignment.center,
// child: const Text("No Offer Available yet")),
// Container(
// height: Dimensions.height50+10,
// margin: EdgeInsets.only(top: Dimensions.height15),
// decoration: BoxDecoration(
// color: color,
// borderRadius: BorderRadius.circular(Dimensions.height10),
// boxShadow: [
// BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 0.5),
// ],
// ),
// child: ListTile(
// onTap: (){
// if(!value.userModel!.isAdFree!){
// value.updateIsAdFree(true);
// }else{
// value.updateIsAdFree(false);
// }
// },
// title: Row(
// children: const [
// Icon(Icons.play_arrow),
// SizedBox(width: 8.4,),
// TextWidget(text: "Ad Free App")],),
// ),
// ),
// Container(
// height: Dimensions.height50+10,
// margin: EdgeInsets.only(top: Dimensions.height15),
// decoration: BoxDecoration(
// color: color,
// borderRadius: BorderRadius.circular(Dimensions.height10),
// boxShadow: [
// BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 0.5),
// ],
// ),
// child: ListTile(
// onTap: (){
// if(!value.userModel!.isOfflineEnable!){
// value.updateIsOfflineEnable(true);
// }else{
// value.updateIsOfflineEnable(false);
// }
// },
// title: Row(
// children: const [
// Icon(Icons.play_arrow),
// SizedBox(width: 8.4,),
// TextWidget(text: "Use App Offline")],),
// ),
// ),
// Container(
// height: Dimensions.height50+10,
// margin: EdgeInsets.only(top: Dimensions.height15),
// decoration: BoxDecoration(
// color: color,
// borderRadius: BorderRadius.circular(Dimensions.height10),
// boxShadow: [
// BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 0.5),
// ],
// ),
// child: ListTile(
// onTap: (){
// context.read<AdMobServicesProvider>().showRewardedAd(context);
// },
// title: Row(
// children: const [
// Icon(Icons.play_arrow),
// SizedBox(width: 8.4,),
// TextWidget(text: "Watch Ad")],),
// ),
// ),
// ],
// ),
// ),
// ),
// )
// ],
// )

//
// Future fetchOffer(BuildContext context) async{
//   final offer = await PurchaseApi.fetchOffers();
//   if(offer.isEmpty){
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: TextWidget(text: 'Error',)));
//   }else{
//     final list = offer.map((offering) => offering.availablePackages).expand((element) => element).toList();
//     showBottomSheet(context: context, builder: (context) {
//       return BottomSheet(onClosing: (){}, builder: (context) {
//         return Column(
//           children: [
//             const TextWidget(text: 'Offers'),
//             Flexible(child: ListView.builder(itemBuilder: (context,index){
//               var data = list[index];
//               return TextWidget(text: data.offeringIdentifier,);
//             }))
//           ],
//         );
//       },);
//     },);
//   }
// }

// context.read<CoinsProvider>().pay(model.coins);
// // var product = context.read<InAppPurchaseApi>().products;
// for(var p in product){
// var id = context.read<InAppPurchaseApi>().hasUserPurchased(p.id);
// if(id != null){
// context.read<InAppPurchaseApi>().spendCredit(id);
// }else{
// context.read<InAppPurchaseApi>().buyProduct(p);
// }
// }
