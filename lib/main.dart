import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/nim/nim_sdk_options.dart';
import 'package:untitled/page/global_controller.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/route_config.dart';
import 'basic/include.dart';
import 'messages.dart';
import 'network/http_manager.dart';

bool isIOSAutoPayListener=true;///iOS自动订阅购买监听

void main() async {
  await _init();
  runApp(GetMaterialApp(
    localizationsDelegates: const [
      // 下拉刷新控件
      RefreshLocalizations.delegate,
    ],
    navigatorKey:navigatorKey,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      appBarTheme: const AppBarTheme(brightness: Brightness.dark),
      // light为黑色 dark为白色
      primaryColor: MyColor.mainColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    translations: Messages(),
    // 你的翻译
    locale: const Locale('zh', 'CN'),
    // 将会按照此处指定的语言翻译
    fallbackLocale: const Locale('zh', 'CN'),

    /// 初始化路由
    getPages: getRouterPage,
  ));
}

Future<void> _init() async {
  Get.put(GlobalController());
  await GetStorage.init('firstInitStorage');
  await _autoLogin();
  nimSdkInit();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,   // 竖屏 Portrait 模式
      DeviceOrientation.portraitDown,
      // DeviceOrientation.landscapeLeft, // 横屏 Landscape 模式
      // DeviceOrientation.landscapeRight,
    ],
  );
  isIOSAutoPayListener=true;
}

Future<void> _autoLogin() async {
  int uid = GetStorageUtils.getUID();
  if (uid != -1) {
    final v = await autoLogin();
    if (v.isOk()) {
      isAutoLoginSuccess = true;
    } else {
      isAutoLoginSuccess = false;
    }
  } else {
    isAutoLoginSuccess = false;
  }
}
