import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:untitled/page/login_page.dart';
import 'package:untitled/page/splash_page.dart';

import 'main.dart';

/**
 * 各个导航界面初始化
 */
var getRouterPage = [
  GetPage(name: splashPName, page: () => const SplashPage()),
  GetPage(name: homePName, page: () => const MyApp()),
  GetPage(name: loginPName, page: () => LoginPage()),
];

//导航个页面name 调用Get.toName('/login') 即可进行页面跳转
const splashPName = '/splash';
const homePName = '/home';
const loginPName = '/login';
