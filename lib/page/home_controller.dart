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
    FlutterInappPurchase.instance.endConnection;
    isClose = true;
  }

  @override
  void onReady() {
    logger.i("onReady");
    if (Platform.isIOS && isIOSAutoPayListener) {
      isIOSAutoPayListener = false;
      _iOSAutoPayListener();
    }
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

  final ListQueue<PurchasedItem> _requestQueue = ListQueue(); //消息请求队列
  bool isVerifying = false;

  void _iOSAutoPayListener() async {
    /// 初始化连接
    await FlutterInappPurchase.instance.initConnection;
    logger.e('_iOSPay初始化连接');
    /// 连接状态监听
    FlutterInappPurchase.connectionUpdated.listen((connected) {
      /// 调起苹果支付，这时候可以关闭toast
      logger.e('_iOSPay-------connectionUpdated$connected');
    });

    /// appStore购买状态监听
    FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      logger.e('_iOSPay购买状态监听----$productItem');
      //自有服务器校验
      if (productItem != null && !isClose && !_isJumpManualPayPage) {
        logger.i(_toString(productItem));
        switch (productItem.transactionStateIOS) {
          case TransactionState.purchasing: // 购买中
            break;
          case TransactionState.restored: //恢复用户先前购买的交易
            // TODO: Handle this case.
            break;
          case TransactionState.purchased: //购买完成
            if (productItem.originalTransactionIdentifierIOS != null) {
              ///自动续费订单
              logger.e('_iOSPay自动续费订单 message');
              _verifyAutoPayOrder(productItem);
            }
            break;
          case TransactionState.failed: //失败的交易
            await clearTransaction();
            break;
          case TransactionState.deferred: //队列中的交易
            break;
        }
      }
    });
  }

  ///验证自动续期的订单
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
        'orderId: ${i.orderId},'
        'originalTransactionDateIOS: ${i.originalTransactionDateIOS?.toIso8601String()}, '
        'originalTransactionIdentifierIOS: ${i.originalTransactionIdentifierIOS}, '
        'transactionStateIOS: ${i.transactionStateIOS}';
  }

  /// 销毁之前的订单，否则无法多次购买
  Future clearTransaction() async {
    final r = await FlutterInappPurchase.instance.clearTransactionIOS();
    logger.i(r);
  }

  /// 完成订单2
  Future _finishTransaction(PurchasedItem purchasedItem) async {
    final r =
    await FlutterInappPurchase.instance.finishTransaction(purchasedItem);
    logger.i(r);
  }
}
