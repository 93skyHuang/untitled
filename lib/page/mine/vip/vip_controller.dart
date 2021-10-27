import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/pay_list.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/widgets/toast.dart';

class VipController extends GetxController {
  RxString imgurl = ''.obs;
  RxString name = ''.obs;
  List<MonthlyCard> monthlyCardList =
      <MonthlyCard>[].obs;

  void closeIosConnection() async {
    await FlutterInappPurchase.instance.endConnection;
  }

  /// 销毁之前的订单，否则无法多次购买
  Future clearTransaction() async {
    return FlutterInappPurchase.instance.clearTransactionIOS();
  }

  void pay() {
    final card = monthlyCardList[3];
    if (Platform.isIOS) {
      _iosPay(card);
    } else if (Platform.isAndroid) {
      _andPay();
    }
  }

  void _iosPay(MonthlyCard card) async {
    logger.i(card.iosKey);
    final create = await createOrder(card.iosKey);
    int orderid;
    if (create.isOk()) {
      orderid = create.data!.orderId;
    } else {
      MyToast.show(create.msg);
      return;
    }
    logger.i(card.iosKey);
    List<String> key=[];
    for(int i=0;i<monthlyCardList.length;i++){
      key.add(monthlyCardList[i].iosKey);
    }
    // await _getPurchaseHistory();

    List<IAPItem> items= await FlutterInappPurchase.instance.getProducts(key);

    for(int i=0;i<items.length;i++){
      logger.i('${items[i]} ${items[i].productId}  ');
    }
    logger.i('苹果支付开始 ${items.length}' );
    /// 初始化连接
    await FlutterInappPurchase.instance.initConnection;
    logger.i('初始化连接');
    /// 连接状态监听
    FlutterInappPurchase.connectionUpdated.listen((connected) {
      /// 调起苹果支付，这时候可以关闭toast
      ///
      logger.i('链接状态监听$connected');
    });

    /// appStore购买状态监听
    FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      logger.i('购买状态监听----$productItem');
      //自有服务器校验
      if (productItem != null) {
        String transactionId = productItem.transactionId ?? '';
        String receiptData = productItem.transactionReceipt ?? '';
        final r=  await verifyOrder(orderid,receiptData,transactionId,);
        logger.i('${r.isOk()}  ${r.msg}');
        await clearTransaction();
      }
    });

    /// 错误监听
    FlutterInappPurchase.purchaseError.listen((purchaseError) async{
      print('监听到错误 purchase-error: $purchaseError');
      await clearTransaction();
      await FlutterInappPurchase.instance.endConnection;

      /// 购买错误回调

    });

     if(items.isNotEmpty){
       /// 发起支付请求，传递iosProductId
       ///
       logger.e('${items[3].productId}');
       FlutterInappPurchase.instance.requestPurchase(card.iosKey);
     }else{
       logger.e('null items  IAPItem');
     }
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
    await FlutterInappPurchase.instance.getPurchaseHistory();
    logger.i('_getPurchaseHistory${items}');
    int l=items?.length??0;
    for(int i=0;i<l;i++){
      logger.i('${items![i].toString()}');
    }
  }

  void _andPay() {}

  @override
  void onInit() {
    PayList? paylist;
    List<MonthlyCard> list;
    getPayList().then((value) => {
          if (value.isOk())
            {
              paylist = value.data,
              if (paylist != null)
                {
                  imgurl.value = '${paylist?.headImgUrl}',
                  name.value = '${paylist?.cname}',
                  monthlyCardList.clear(),
                  list = paylist?.monthlyCardList ?? [],
                  monthlyCardList.addAll(list),
                }
            }
        });
    logger.i("VipControlleronInit");
  }

  @override
  void onClose() {
    logger.i("onClose");
  }

  @override
  void onReady() {
    logger.i("onReady");
  }
}
