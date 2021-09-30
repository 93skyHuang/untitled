import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


abstract class BasePageWidget extends StatefulWidget {
  BasePageWidget({Key? key}) : super(key: key);

  @override
  BaseWidgetState createState() => getState();

  BaseWidgetState<StatefulWidget> getState();
}

///状态基类
abstract class BaseWidgetState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, RouteAware {

  ///页面是否可见
  bool isResume = false;

  ///是否是当前页面
  bool isCurPage = false;


  @override
  Widget build(BuildContext context) {
      return _normalBuild();

  }

  Widget _normalBuild() {
    return Scaffold(
      appBar: _normalAppBar(),
      // body: _pageAttribute.pageBody,
      backgroundColor: Colors.white,
    );
  }

  AppBar _normalAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 1,

      // backgroundColor: _pageAttribute.titleBgColor,
      // leading: _pageAttribute.isShowLeading
      //     ? Builder(builder: (BuildContext context) {
      //   return _pageAttribute.leading;
      // })
      //     : Text(''),
      // actions: _pageAttribute.actions,
      // bottom: _pageAttribute.appBarBottom,
    );
  }

  ///iOS:viewDidLoad Android:onCreateView 只执行一次
  @override
  @mustCallSuper
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   isResume = true;
    //   logger.i(
    //         'addPostFrameCallback');
    //   initData();
    //   resume();
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Routes.routeObserver.subscribe(this, ModalRoute.of(context)); //订阅
  }

  @override
  void didPushNext() {
    super.didPushNext();
    paused();
    isCurPage = false;
  }

  @override
  void didPush() {
    super.didPush();
    isCurPage = true;
  }

  @override
  void didPop() {
    super.didPop();
    paused();
    isCurPage = false;
  }

  @override
  void didPopNext() {
    super.didPopNext();
    resume();
    isCurPage = true;
  }

  ///iOS:viewDidDisappear Android:onDestroy 页面消失
  @override
  void dispose() {
    super.dispose();
    isResume = false;
  }

  ///生命周期监测针对app退到后台的生命周期检测
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        paused();
        break;
      case AppLifecycleState.paused:
        paused();
        break;
      case AppLifecycleState.detached:
        detached();
        break;
      default:
        break;
    }
  }

  @protected
  void resume() {
    isResume = true;
  }

  @protected
  void paused() {
    isResume = false;
    // KeyboardUtil.closeKeyboard(context);
  }

  @protected
  void detached() {}

  @protected
  void initData() {}

  // Future<T> push<T extends Object>(Widget page) {
  //   FLog.info(className: context.widget.toString(), text: 'page=$page');
  //   return Navigator.push<T>(context, MaterialPageRoute(builder: (context) {
  //     return page;
  //   }));
  // }
  //
  // Future<T> pushReplacement<T extends Object, TO extends Object>(Widget page,
  //     {TO result}) {
  //   FLog.info(className: context.widget.toString(), text: 'page=$page');
  //   return Navigator.pushReplacement(context,
  //       MaterialPageRoute(builder: (context) {
  //         return page;
  //       }));
  // }
  //
  // ///跳转到下一个页面并移除其它页面
  // Future<T> pushNamedAndRemoveUntil<T extends Object>(String routerName,
  //     {RoutePredicate predicate, Object arguments}) {
  //   if (predicate == null) {
  //     predicate = (Route<dynamic> route) => false;
  //   }
  //   FLog.info(
  //       className: context.widget.toString(), text: 'routerName=$routerName');
  //   return Navigator.pushNamedAndRemoveUntil(context, routerName, predicate,
  //       arguments: arguments);
  // }
  //
  // Future<T> pushName<T extends Object>(String routerName, {Object arguments}) {
  //   FLog.info(
  //       className: context.widget.toString(),
  //       text: 'routerName=$routerName --arguments=$arguments');
  //   return Navigator.pushNamed<T>(context, routerName, arguments: arguments);
  // }

  ///页面出栈
  void pop<T>([T? result]) {
    Navigator.pop(context, result);
  }
//
//  void popUtil(){
//    Navigator.popUntil(context, (route) => false)
//  }
}