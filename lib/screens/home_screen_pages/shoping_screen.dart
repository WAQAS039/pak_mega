import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pak_mega_mcqs/providers/coins_provider.dart';
import 'package:pak_mega_mcqs/providers/user_information_provider.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:pak_mega_mcqs/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../providers/in_app_purchase_providers/repeatable_purchase.dart';


class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCoins();
  }

  void _loadCoins(){
    Future.delayed(const Duration(milliseconds: 1),(){
      var coins = context.read<UserInformationProvider>().userModel!.coins!;
      print(coins);
      context.read<CoinsProvider>().setCoins(coins);
    });
  }

  Future<void> _loadProducts() async {
    final productIds = ['com.example.item1', 'com.example.item2', 'com.example.item3'];
    final productResult = await InAppPurchase.instance.queryProductDetails(productIds.toSet());
    setState(() {
      _products = productResult.productDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repeatablePurchase = Provider.of<RepeatablePurchase>(context);
    var color = const Color(0xFF279485);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Image.asset('assets/icons/coins_page_icons/coins_logo.png',height: Dimensions.height98,width: Dimensions.height98,),
          const SizedBox(height: 11,),
          Consumer<CoinsProvider>(
            builder: (context, value, child) => TextWidget(text: value.coins.toString(),fontSize: Dimensions.height30,),
          ),
          Text('Total Coins',style: TextStyle(
              decoration: TextDecoration.overline,
              fontSize: Dimensions.height20,
              color: Colors.white
          ),),
          Expanded(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(top: Dimensions.height98,left: Dimensions.height30,right: Dimensions.height30),
              padding: EdgeInsets.all(Dimensions.height20),
              decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(Dimensions.height10)
              ),
              child: Column(
                children: [
                  const TextWidget(text: 'BUY COINS',),
                  _products.isNotEmpty ? Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context,index){
                          ProductDetails model = _products[index];
                          return Consumer<UserInformationProvider>(
                            builder: (context, value, child) {
                              return Container(
                                height: Dimensions.height50+10,
                                margin: EdgeInsets.only(top: Dimensions.height15),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(Dimensions.height10),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 0.5),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Image.asset('assets/icons/coins_page_icons/coin.png',height: Dimensions.height30,width: Dimensions.height30,),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/coins_page_icons/coin.png',height: Dimensions.height15,width: Dimensions.height15,),
                                      const SizedBox(width: 8.4,),
                                      TextWidget(text: model.price)],),
                                  trailing: InkWell(
                                      onTap: () async{
                                        if(model.price == 'Free'){
                                          context.read<CoinsProvider>().getFreeReward(5, context);
                                        }else{
                                          await showDialog(context: context, builder: ((context) {
                                            return AlertDialog(
                                              title: Text('Buy ${model.price} with in ${model.price}${model.currencyCode}'),
                                              actions: [
                                                TextButton(onPressed: (){
                                                  repeatablePurchase.purchaseItem(model, value.userModel!.name!,context);
                                                  Navigator.of(context).pop();
                                                }, child: const TextWidget(text: 'Pay',textColor: Colors.black,)),
                                                TextButton(onPressed: (){
                                                  Navigator.of(context).pop();
                                                }, child: const TextWidget(text: 'Cancel',textColor: Colors.black,))
                                              ],
                                            );
                                          }));
                                        }
                                      },
                                      child: TextWidget(text: '\$${model.price}',)),
                                ),
                              );
                            },
                          );
                        },
                      ) ,
                    ),
                  ) : const Expanded(
                    child: Center(child: Text("No Offer Available Yet",style: TextStyle(color: Colors.white),)
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class CoinsModel{
  String price;
  int coins;
  CoinsModel({required this.price,required this.coins});
}

List<CoinsModel> coinsList = [
  CoinsModel(price: '20', coins: 10),
  CoinsModel(price: "40", coins: 20),
  CoinsModel(price: "60", coins: 30),
];










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

