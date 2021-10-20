import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/route_config.dart';
import 'basic/include.dart';
import 'messages.dart';

void main() async {
  await GetStorage.init('AccountStorage');
  runApp(GetMaterialApp(
    localizationsDelegates: const [
      // 下拉刷新控件
      RefreshLocalizations.delegate,
    ],
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
