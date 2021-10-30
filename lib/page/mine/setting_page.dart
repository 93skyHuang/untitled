import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/network/bean/app_version_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/page/login/login_page.dart';
import 'package:untitled/page/report/report_page.dart';
import 'package:untitled/widget/item_arrow.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/widget/loading.dart';
import 'package:untitled/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../route_config.dart';

class SettingPage extends StatefulWidget {
  const SettingPage();

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String size = '0kb';

  @override
  void initState() {
    super.initState();
    loadApplicationCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: new IconButton(
            icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
            onPressed: () {
              Navigator.maybePop(context);
            }),
        title: Text("设置", style: TextStyle(fontSize: 17, color: Colors.black)),
        backgroundColor: Color(0xFFF5F5F5),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 8.0,
              color: Color(0xffE6E6E6),
            ),
            ItemArrow(
              onPressed: () {
                clearApplicationCache();
              },
              text: '清理缓存',
              value: '$size',
              padding: EdgeInsets.only(left: 16, right: 16),
            ),
            ItemArrow(
              onPressed: () {
                Get.toNamed(webViewPName, arguments: {
                  'url': 'http://www.sancun.vip/yhxy',
                  'title': '用户协议'
                });
              },
              text: '用户协议',
              padding: EdgeInsets.only(left: 16, right: 16),
            ),
            ItemArrow(
              onPressed: () {
                Get.toNamed(webViewPName, arguments: {
                  'url': 'http://www.sancun.vip/ysxy',
                  'title': '隐私声明'
                });
              },
              text: '隐私条款',
              showDivider: false,
              padding: EdgeInsets.only(left: 16, right: 16),
            ),
            Container(
              height: 8.0,
              color: Color(0xffE6E6E6),
            ),
            ItemArrow(
              onPressed: () {
                Get.to(() => ReportPage(-1, isFeedback: true));
              },
              text: '意见反馈',
              padding: EdgeInsets.only(left: 16, right: 16),
            ),
            ItemArrow(
              onPressed: () {
                update();
              },
              text: '软件版本',
              value: 'V1.0.0',
              showArrow: false,
              padding: EdgeInsets.only(left: 16, right: 16),
            ),
            Container(
              width: 214,
              height: 40,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 45),
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: Colors.white),
              child: GestureDetector(
                onTap: () {
                  NimNetworkManager.instance.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false);
                },
                child: Text('退出',
                    style: TextStyle(color: Color(0xffFD4343), fontSize: 17)),
              ),
            ),
            Container(
              width: 214,
              height: 40,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  cancelAccount();
                },
                child: Text('注销',
                    style: TextStyle(color: Color(0xff8C8C8C), fontSize: 17)),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppVersionInfo appVersionInfo = new AppVersionInfo();

  void update() async {
    Loading.show(context);
    checkAppVersion(1, '1.0.0').then((value) => {
          Loading.dismiss(context),
          if (value.isOk())
            {
              appVersionInfo = value.data!,
              if (appVersionInfo != null && appVersionInfo.versionIsUp == 0)
                {
                  MyToast.show('已是最新版本'),
                }
              else
                {
                  showUpdateDialog(),
                }
            }
        });
  }

  void cancelAccount() async {
    Loading.show(context);
    addDeleteAccountApplication().then((value) => {
          Loading.dismiss(context),
          if (value.isOk())
            {
              MyToast.show('申请注销成功，我们将在7个工作日内对您的账号进行注销，再此期间请不要重复操作。7天内如果再次登录将视为主动取消该操作。'),
              NimNetworkManager.instance.logout(),
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false),
            }
        });
  }

  showUpdateDialog() {
    Widget cancelButton = TextButton(
      child: Text(
        "暂不升级",
        style: TextStyle(color: MyColor.grey8C8C8C),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(0, 0)),
          visualDensity: VisualDensity.compact,
          padding:
              MaterialStateProperty.all(EdgeInsets.only(left: 6, right: 6)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
          backgroundColor: MaterialStateProperty.all(MyColor.mainColor)),
      child: Text(
        "立即升级",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      onPressed: () {
        _launchUrl('${appVersionInfo.versionUrl}');
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("版本升级"),
      content: Text("${appVersionInfo.versionDescription}"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      MyToast.show('升级失败');
    }
  }

  static Future<double> getTotalSizeOfFilesInDir(
      final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  String formatSize(double value) {
    if (null == value) {
      return '0';
    }
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  Future<Null> loadApplicationCache() async {
    //获取文件夹
    Directory docDirectory = await getApplicationDocumentsDirectory();
    Directory tempDirectory = await getTemporaryDirectory();

    double fsize = 0;

    if (docDirectory.existsSync()) {
      fsize += await getTotalSizeOfFilesInDir(docDirectory);
    }
    if (tempDirectory.existsSync()) {
      fsize += await getTotalSizeOfFilesInDir(tempDirectory);
    }
    size = formatSize(fsize);
    setState(() {});
  }

  static Future<Null> deleteDirectory(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteDirectory(child);
        await child.delete();
      }
    }
  }

  /// 删除缓存
  void clearApplicationCache() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    Directory tempDirectory = await getTemporaryDirectory();

    if (docDirectory.existsSync()) {
      await deleteDirectory(docDirectory);
      loadApplicationCache();
    }

    if (tempDirectory.existsSync()) {
      await deleteDirectory(tempDirectory);
      loadApplicationCache();
    }
  }
}
