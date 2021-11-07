import 'dart:async';
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
  late final StreamSubscription nimEventSubscription;
  bool isClose = false;
  bool _isJumpManualPayPage = false;///如果跳转到手动支付页面这个页面的请求不能使用
  void nimEventListener() {
    nimEventSubscription =
        NimCore.instance.authService.authStatus.listen((event) {
      if (event is NIMKickOutByOtherClientEvent) {
        logger.e('监听到被踢事件${event.status}');
        if (getApplication() != null) {
          NimNetworkManager.instance.logout();
          showKickOutByOtherClientDialog(getApplication()!);
        }

        /// 监听到被踢事件
      } else if (event is NIMAuthStatusEvent) {
        /// 监听到其他事件
        logger.e(event.status);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    logger.i("onInit");
  }

  @override
  void onClose() {
    logger.i("onClose");
    nimEventSubscription.cancel();
    FlutterInappPurchase.instance.endConnection;
    isClose=true;
  }

  @override
  void onReady() {
    logger.i("onReady");
    nimEventListener();
    if(Platform.isIOS&&isIOSAutoPayListener){
      isIOSAutoPayListener=false;
      _iOSPay();
    }
    Future.delayed(Duration(seconds: 10)).then((value) => {
      if(!isClose){ _getLocation(),_getId()}
     });
  }

  void _getLocation() async {
    bool hasPermission = await checkAndRequestPermission1();
    if (hasPermission) {
      await getPosition();
    }
  }

  void _getId() async {
    String deviceId=GetStorageUtils.getDeviceId();
    if(deviceId.isNotEmpty){
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        deviceId= iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId= androidDeviceInfo.androidId; // unique ID on Android
      }
    }
  }

  void clearIOSPayListener(){
    if(Platform.isIOS){
      _isJumpManualPayPage=true;
      FlutterInappPurchase.instance.endConnection;
    }
  }

  void _iOSPay() async{
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
      if (productItem != null&&!isClose&&!_isJumpManualPayPage) {
        logger.i('_iOSPay transactionStateIOS===${productItem.transactionStateIOS}'
            ' --- ${productItem.transactionId} --${productItem.orderId}');
        logger.i(_toString(productItem));
        switch (productItem.transactionStateIOS) {
          case TransactionState.purchasing: // 购买中
            await clearTransaction();
            break;
          case TransactionState.restored: //恢复用户先前购买的交易
          // TODO: Handle this case.
            break;
          case TransactionState.purchased: //购买完成
            logger.i('${productItem.originalTransactionIdentifierIOS} ----${productItem.originalTransactionDateIOS}');
            if (productItem.originalTransactionIdentifierIOS != null) {///自动续费订单
              //自动续费订单
              logger.e('_iOSPay自动续费订单 message');
              if(productItem.productId!=null) {
                final create = await createOrder(productItem.productId!);
                int orderId;
                if (create.isOk()) {
                  orderId = create.data!.orderId;
                  String transactionId = productItem.transactionId ?? '';
                  String receiptData = productItem.transactionReceipt ?? '';
                  final r = await verifyOrder(
                    orderId,
                    receiptData,
                    transactionId,
                  );
                  if(r.isOk()){
                    GetStorageUtils.saveSvip(true);
                    await clearTransaction();
                  }
                await FlutterInappPurchase.instance.endConnection;
                }
              }
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

  String _toString(PurchasedItem i){
   return 'productId: ${i.productId}, '
        'transactionId: ${i.transactionId}, '
        'transactionDate: ${i.transactionDate?.toIso8601String()}, '
        'purchaseToken: ${i.purchaseToken}, '
        'orderId: ${i.orderId},'

         /// ios specific
        'originalTransactionDateIOS: ${i.originalTransactionDateIOS?.toIso8601String()}, '
        'originalTransactionIdentifierIOS: ${i.originalTransactionIdentifierIOS}, '
        'transactionStateIOS: ${i.transactionStateIOS}';
  }

  /// 销毁之前的订单，否则无法多次购买
  Future clearTransaction() async {
    return FlutterInappPurchase.instance.clearTransactionIOS();
  }
}
