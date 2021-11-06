import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/network/bean/pay_list.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/route_config.dart';
import 'package:untitled/widget/loading.dart';
import 'package:untitled/widgets/toast.dart';

class VipController extends GetxController {
  RxString imgurl = ''.obs;
  RxString name = ''.obs;
  List<MonthlyCard> monthlyCardList = <MonthlyCard>[].obs;
  RxInt selectedIndex = 0.obs;
  RxString money = "".obs;
  bool _isClose=false;

  void closeIosConnection() async {
    await FlutterInappPurchase.instance.endConnection;
  }

  void setSelectedCard(int index) {
    selectedIndex.value = index;
    money.value = monthlyCardList[index].money;
  }

  /// 销毁之前的订单，否则无法多次购买
  Future clearTransaction() async {
    return FlutterInappPurchase.instance.clearTransactionIOS();
  }

  void pay() {
    if (Platform.isIOS) {
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

    List<IAPItem> items = await FlutterInappPurchase.instance.getProducts(key);
    logger.i('苹果支付开始 ${items.length}');

    /// 初始化连接
    await FlutterInappPurchase.instance.initConnection;
    logger.i('初始化连接');
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
      if (productItem != null&&!_isClose) {
        logger.i('transactionStateIOS===${productItem.transactionStateIOS} --- ${productItem.transactionId}');
        switch (productItem.transactionStateIOS) {
          case TransactionState.purchasing: // 购买中
            // TODO: Handle this case.
            await clearTransaction();
            break;
          case TransactionState.restored: //恢复用户先前购买的交易
            // TODO: Handle this case.
            break;
          case TransactionState.purchased: //购买完成
            logger.i('${productItem.originalTransactionIdentifierIOS} ----${productItem.originalTransactionDateIOS}');
            String transactionId = productItem.transactionId ?? '';
            if (productItem.originalTransactionIdentifierIOS != null) {
              //自动续费订单
              logger.e('自动续费订单 message');
              // transactionId = productItem.originalTransactionIdentifierIOS ?? '';
            } else {
              //普通购买或第一次购买

            }
            transactionId = productItem.transactionId ?? '';
            String receiptData = productItem.transactionReceipt ?? '';
            final r = await verifyOrder(
              orderid,
              receiptData,
              transactionId,
            );
            logger.i('${r.isOk()}  ${r.msg}');
            Loading.dismiss(getApplication()!);
            if (r.isOk()) {
              MyToast.show(r.msg);
              FlutterInappPurchase.instance.endConnection;
              GetStorageUtils.saveSvip(true);
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
      await clearTransaction();
      await FlutterInappPurchase.instance.endConnection;

      /// 购买错误回调
    });

    if (items.isNotEmpty) {
      /// 发起支付请求，传递iosProductId
      ///
      FlutterInappPurchase.instance.requestPurchase(card.iosKey);
    } else {
      logger.e('null items  IAPItem');
    }
  }

  void iosResumePurchase() async {
  final r=await  resumePurchaseIOS(monthlyCardList[selectedIndex.value].iosKey);
  Loading.dismiss(getApplication()!);
  MyToast.show(r.msg);
  if(r.isOk()){
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
      logger.i('${items![i].transactionStateIOS}');
      logger.i('${items![i].toString()}');
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
    _isClose=true;
  }

  @override
  void onReady() {
    logger.i("onReady");
  }
}
