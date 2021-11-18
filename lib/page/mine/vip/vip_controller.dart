import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/pay_list.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/page/home_controller.dart';
import 'package:untitled/page/mine/vip/failed_order_bean.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/route_config.dart';
import 'package:untitled/widget/loading.dart';
import 'package:untitled/widgets/toast.dart';

class VipController extends GetxController {
  RxString imgurl = ''.obs;
  RxString name = ''.obs;
  RxInt svip = 0.obs;
  List<MonthlyCard> monthlyCardList = <MonthlyCard>[].obs;
  RxInt selectedIndex = 0.obs;
  RxString money = "".obs;
  bool _isClose = false;

  void closeIosConnection() async {
    await FlutterInappPurchase.instance.endConnection;
  }

  void setSelectedCard(int index) {
    selectedIndex.value = index;
    money.value = monthlyCardList[index].money;
  }

  /// 销毁之前的订单，否则无法多次购买
  Future clearTransaction() async {
    final r = await FlutterInappPurchase.instance.clearTransactionIOS();
    logger.i(r);
  }

  /// 完成订单
  Future _finishTransactionIOS(String transactionId) async {
    final r =
        await FlutterInappPurchase.instance.finishTransactionIOS(transactionId);
    logger.i(r);
  }

  /// 完成订单2
  Future _finishTransaction(PurchasedItem purchasedItem) async {
    final r =
        await FlutterInappPurchase.instance.finishTransaction(purchasedItem);
    logger.i(r);
  }

  void pay() {
    if (Platform.isIOS) {
      // Get.find<HomeController>().clearIOSPayListener();
      _iosPay(monthlyCardList[selectedIndex.value]);
    } else if (Platform.isAndroid) {
      Loading.dismiss(getApplication()!);
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
    List<String> key = [];
    for (int i = 0; i < monthlyCardList.length; i++) {
      key.add(monthlyCardList[i].iosKey);
    }
    List<IAPItem> items = await FlutterInappPurchase.instance.getProducts([card.iosKey]);
    if(items.isNotEmpty){
      logger.i('苹果支付开始初始化 ${items.first.toString()}');
    }else{
      MyToast.show('获取商品订单失败,请重新尝试');
      return;
    }


    /// 初始化连接
    final initConnection=await FlutterInappPurchase.instance.initConnection;
    logger.i('初始化连接$initConnection');

    /// 连接状态监听
    FlutterInappPurchase.connectionUpdated.listen((connected) {
      /// 调起苹果支付，这时候可以关闭toast
      ///
      logger.i('-------connectionUpdated$connected');
    });

    /// appStore购买状态监听
    FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      logger.i('购买状态监听----$productItem');
      //自有服务器校验
      if (productItem != null && !_isClose) {
        logger.i(_toString(productItem));
        logger.i(
            'transactionStateIOS===${productItem.transactionStateIOS} --- ${productItem.transactionId}');
        switch (productItem.transactionStateIOS) {
          case TransactionState.purchasing: // 购买中
            // TODO: Handle this case.
            // await clearTransaction();
            break;
          case TransactionState.restored: //恢复用户先前购买的交易
            // TODO: Handle this case.
            break;
          case TransactionState.purchased: //购买完成
            logger.i(
                '${productItem.originalTransactionIdentifierIOS} ----${productItem.originalTransactionDateIOS}');
            if (productItem.originalTransactionIdentifierIOS != null) {
              //自动续费订单
              logger.e('自动续费订单 message');
              // transactionId = productItem.originalTransactionIdentifierIOS ?? '';
            } else {
              //普通购买或第一次购买
            }
            String transactionId = productItem.transactionId ?? '';
            String receiptData = productItem.transactionReceipt ?? '';
            GetStorageUtils.saveFailedOrder(FailedOrderBean(orderid,receiptData,transactionId));
            final r = await verifyOrder(
              orderid,
              receiptData,
              transactionId,
            );
            logger.i('${r.isOk()}  ${r.msg}');
            Loading.dismiss(getApplication()!);
            if (r.isOk()) {
              await _finishTransaction(productItem);
              await FlutterInappPurchase.instance.endConnection;
              MyToast.show(r.msg);
              GetStorageUtils.saveSvip(true);
              GetStorageUtils.clearFailedOrder();
              Get.back();
            } else {
              MyToast.show(r.msg);
            }
            await clearTransaction();
            break;
          case TransactionState.failed: //失败的交易
            await clearTransaction();
            break;
          case TransactionState.deferred: //队列中的交易
            break;
        }
      }
    });

    /// 错误监听
    FlutterInappPurchase.purchaseError.listen((purchaseError) async {
      logger.e('监听到错误 purchase-error: $purchaseError');
      Loading.dismiss(getApplication()!);
      /// 购买错误回调
    });

    if (items.isNotEmpty) {
      /// 发起支付请求，传递iosProductId
      logger.i('开始下单${card.iosKey}');
      FlutterInappPurchase.instance.requestPurchase(card.iosKey);
    } else {
      logger.e('null items  IAPItem');
    }
  }

  String _toString(PurchasedItem i) {
    return 'productId: ${i.productId}, '
        'transactionId: ${i.transactionId}, '
        'transactionDate: ${i.transactionDate?.toIso8601String()}, '
        'purchaseToken: ${i.purchaseToken}, '
        /// ios specific
        'originalTransactionDateIOS: ${i.originalTransactionDateIOS?.toIso8601String()}, '
        'originalTransactionIdentifierIOS: ${i.originalTransactionIdentifierIOS}, '
        'transactionStateIOS: ${i.transactionStateIOS}';
  }

  void iosResumePurchase() async {
    final r =
        await resumePurchaseIOS(monthlyCardList[selectedIndex.value].iosKey);
    Loading.dismiss(getApplication()!);
    MyToast.show(r.msg);
    if (r.isOk()) {
      Get.back();
    }
  }

  Future _getPurchaseHistory() async {
    logger.i('_getPurchaseHistory}');
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    logger.i('_getPurchaseHistory${items?.length}');
    int l = items?.length ?? 0;
    for (int i = 0; i < l; i++) {
      logger.i(_toString(items![i]));
    }
  }

  void _andPay() {}

  @override
  void onInit() {
    super.onInit();
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
                  svip.value=paylist!.svip??0,
                  list = paylist?.monthlyCardList ?? [],
                  monthlyCardList.addAll(list),
                  setSelectedCard(0),
                }
            }
        });
    logger.i("VipControlleronInit");
  }

  @override
  void onClose() {
    logger.i("onClose");
    FlutterInappPurchase.instance.endConnection;
    _isClose = true;
  }

  @override
  void onReady() {
    logger.i("onReady");
    // _getPurchaseHistory();
  }
}
