import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class RepeatablePurchase with ChangeNotifier {
  int _itemCount = 0;
  int get itemCount => _itemCount;


  void purchaseItem(ProductDetails productDetails,String userName,BuildContext context) async {
    final purchaseParam = PurchaseParam(
        productDetails: ProductDetails(
            id: productDetails.id,
            title: productDetails.title,
            description: productDetails.description,
            price: productDetails.price,
            currencyCode: productDetails.currencyCode, rawPrice: productDetails.rawPrice
        ),
        applicationUserName: userName,
    );
    final success = await InAppPurchase.instance.buyConsumable(
        purchaseParam: purchaseParam);
    if (success) {
      _itemCount += 1;
      notifyListeners();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error occur")));
    }
  }
}