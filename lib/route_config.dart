import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:untitled/page/home_page.dart';
import 'package:untitled/page/login/add_basic_info.dart';
import 'package:untitled/page/login/login_page.dart';
import 'package:untitled/page/mine/mine_page.dart';
import 'package:untitled/page/splash_page.dart';
import 'package:untitled/widgets/photo_view_widget.dart';
import 'package:untitled/widgets/webview_page.dart';


/**
 * 各个导航界面初始化
 */
var getRouterPage = [
  GetPage(name: splashPName, page: () => const SplashPage()),
  GetPage(name: homePName, page: () => const HomePage()),
  GetPage(name: loginPName, page: () => LoginPage()),
  GetPage(name: webViewPName, page: () => WebViewPage()),
  GetPage(name: MinePName, page: () => MinePage()),
  GetPage(name: photoViewPName, page: () => PhotoViewPage()),
  GetPage(name: photoViewScalePName, page: () => PhotoViewScalePage()),
  GetPage(name: addBasicInfoPName, page: () => AddBasicInfoPage()),
];

//导航个页面name 调用Get.toName('/login') 即可进行页面跳转
const splashPName = '/';
const homePName = '/home';
const loginPName = '/login';
const webViewPName = '/webView';
const MinePName = '/mine';
const photoViewPName = '/photoViewP';
const photoViewScalePName = '/photoViewScaleP';
const addBasicInfoPName = '/addBasicInfo';
