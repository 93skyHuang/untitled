import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';
import 'package:untitled/main.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/page/mine/vip/failed_order_bean.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/utils/location_util.dart';
import 'package:untitled/widgets/dialog.dart';

import '../route_config.dart';

class HomeController extends GetxController {
  bool isClose = false;
  bool _isJumpManualPayPage = false;

  @override
  void onInit() {
    super.onInit();
    logger.i("onInit");
  }

  @override
  void onClose() {
    logger.i("onClose");
    // FlutterInappPurchase.instance.endConnection;
    isClose = true;
  }

  @override
  void onReady() {
    logger.i("onReady");
    FailedOrderBean? failedOrderBean=  GetStorageUtils.getVerFailedOrder();
    if(failedOrderBean!=null){
      verifyOrder(
        failedOrderBean.orderid,
        failedOrderBean.receiptData,
        failedOrderBean.transactionID,
      ).then((value) =>{
        if(value.isOk()){
          GetStorageUtils.clearFailedOrder(),
        }
      } );
    }
    // if (Platform.isIOS && isIOSAutoPayListener) {
    //   isIOSAutoPayListener = false;
    //   // _iOSAutoPayListener();
    // }
    Future.delayed(Duration(seconds: 10)).then((value) => {
          if (!isClose) {_getLocation()}
        });
  }

  void _getLocation() async {
    bool hasPermission = await checkAndRequestPermission1();
    if (hasPermission) {
      await getPosition();
    }
  }

  void _getId() async {
    String deviceId = GetStorageUtils.getDeviceId();
    if (deviceId.isNotEmpty) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId = androidDeviceInfo.androidId; // unique ID on Android
      }
    }
  }

  void clearIOSPayListener() {
    if (Platform.isIOS) {
      _isJumpManualPayPage = true;
      FlutterInappPurchase.instance.endConnection;
    }
  }

  final ListQueue<PurchasedItem> _requestQueue = ListQueue(); //??????????????????
  bool isVerifying = false;

  void _iOSAutoPayListener() async {
    /// ???????????????
    await FlutterInappPurchase.instance.initConnection;
    logger.e('_iOSPay???????????????');
    /// ??????????????????
    FlutterInappPurchase.connectionUpdated.listen((connected) {
      /// ??????????????????????????????????????????toast
      logger.e('_iOSPay-------connectionUpdated$connected');
    });

    /// appStore??????????????????
    FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      logger.e('_iOSPay??????????????????----$productItem');
      //?????????????????????
      if (productItem != null && !isClose && !_isJumpManualPayPage) {
        logger.i(_toString(productItem));
        switch (productItem.transactionStateIOS) {
          case TransactionState.purchasing: // ?????????
            break;
          case TransactionState.restored: //?????????????????????????????????
            // TODO: Handle this case.
            break;
          case TransactionState.purchased: //????????????
            if (productItem.originalTransactionIdentifierIOS != null) {
              ///??????????????????
              logger.e('_iOSPay?????????????????? message');
              _verifyAutoPayOrder(productItem);
            }
            break;
          case TransactionState.failed: //???????????????
            await clearTransaction();
            break;
          case TransactionState.deferred: //??????????????????
            break;
        }
      }
    });
  }

  ///???????????????????????????
  void _verifyAutoPayOrder(PurchasedItem i) async {
    _requestQueue.add(i);
    if (!isVerifying) {
      isVerifying = true;
      while (_requestQueue.isNotEmpty) {
        PurchasedItem productItem = _requestQueue.removeFirst();
        if (productItem.productId != null) {
          final create = await createOrder(productItem.productId!);
          if (create.isOk()) {
            int orderId = create.data!.orderId;
            String transactionId = productItem.transactionId ?? '';
            String receiptData = productItem.transactionReceipt ?? '';
            final r = await verifyOrder(
              orderId,
              receiptData,
              transactionId,
            );
            if (r.isOk()) {
              GetStorageUtils.saveSvip(true);
              await _finishTransaction(productItem);
            }
          }
        }
      }
      await clearTransaction();
      isVerifying = false;
    }
  }

  String _toString(PurchasedItem i) {
    return '_iOSPay productId: ${i.productId}, '
        'transactionId: ${i.transactionId}, '
        'transactionDate: ${i.transactionDate?.toIso8601String()}, '
        'purchaseToken: ${i.purchaseToken}, '
        'originalTransactionDateIOS: ${i.originalTransactionDateIOS?.toIso8601String()}, '
        'originalTransactionIdentifierIOS: ${i.originalTransactionIdentifierIOS}, '
        'transactionStateIOS: ${i.transactionStateIOS}';
  }

  /// ????????????????????????????????????????????????
  Future clearTransaction() async {
    final r = await FlutterInappPurchase.instance.clearTransactionIOS();
    logger.i(r);
  }

  /// ????????????2
  Future _finishTransaction(PurchasedItem purchasedItem) async {
    final r =
    await FlutterInappPurchase.instance.finishTransaction(purchasedItem);
    logger.i(r);
  }
}
