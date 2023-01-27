import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pak_mega_mcqs/data/api/store_cofig.dart';
import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi{
  static const apikey = "sk_tlEgfzxqsvDfixschsFSVYsXYJlOw";
  static Future init() async{
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(apikey);
    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey);
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);
    }
    await Purchases.configure(configuration);

    await Purchases.enableAdServicesAttributionTokenCollection();

    final customerInfo = await Purchases.getCustomerInfo();
  }
  static Future<List<Offering>> fetchOffers() async{
    try{
      final offering = await Purchases.getOfferings();
      final currentOffer = offering.current;
      return currentOffer == null ? [] : [currentOffer];
    }on PlatformException catch(e){
      return [];
    }
  }
}














class InAppPurchaseApi with ChangeNotifier{
  static const String testID = 'book_test';
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  // checks if the API is available on this device
  bool _isAvailable = false;
  // keeps a list of products queried from Playstore or app store
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;
// List of users past purchases
  List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> get purchases => _purchases;
// subscription that listens to a stream of updates to purchase details
  late StreamSubscription _subscription;
// used to represents consumable credits the user can buy
  int _credits = 0;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void init() async{
    _isAvailable = await _inAppPurchase.isAvailable();
    if(_isAvailable){
      await _getUserProducts();
      // await _getPastPurchases();
      // _verifyPurchases();

      _subscription = _inAppPurchase.purchaseStream.listen((event) {
        _purchases.addAll(event);
        // _verifyPurchases();
        notifyListeners();
      });
    }
  }

  Future<void> _getUserProducts() async {
    Set<String> ids = {testID};
    ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(ids);
    _products = response.productDetails;
    notifyListeners();
  }

  void buyProduct(ProductDetails prod){
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  void _verifyPurchases(){
    PurchaseDetails purchase = hasUserPurchased(testID);
    if(purchase.status == PurchaseStatus.purchased){
      _credits = 10;
    }
  }

  void spendCredit(PurchaseDetails purchaseDetails) async{
    _credits--;
    notifyListeners();
    if(_credits == 0){
      var res = await _inAppPurchase.completePurchase(purchaseDetails);
    }
  }
  PurchaseDetails hasUserPurchased(String testID){
    return _purchases.firstWhere((purchase) => purchase.productID == testID);
  }
  // Future<void> _getPastPurchases() async {
  //   Set<String> ids = {testID};
  //   QueryPurchaseDetailsResponse response = await _inAppPurchase.queryProductDetails(ids);
  // }
}

