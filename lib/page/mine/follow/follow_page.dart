import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/network/bean/follow_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/personcenter/user_home_page.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_follow.dart';
import 'package:untitled/widgets/my_classic.dart';

class FollowPage extends StatefulWidget {
  FollowPage();

  @override
  State<StatefulWidget> createState() {
    return _FollowPageState();
  }
}

class _FollowPageState extends State<FollowPage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
            onPressed: () {
              Navigator.maybePop(context);
            }),
        title:
            Text("我的关注", style: TextStyle(fontSize: 17, color: Colors.black)),
        backgroundColor: Color(0xFFF5F5F5),
        centerTitle: true,
      ),
      body: RefreshConfiguration(
          // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
          hideFooterWhenNotFull: true,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: const MyClassicHeader(),
            footer: const MyClassicFooter(),
            // 配置默认底部指示器
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ItemFollow(
                  name: '${follows[index].cname}',
                  img: follows[index].headImgUrl ?? "",
                  info:
                      '${follows[index].distance}，${follows[index].age}，${follows[index].constellation}',
                  onPressed: () {
                    Get.to(() => UserHomePage(uid: follows[index].uid ?? 0));
                  },
                  onMorePressed: () {
                    showBottomOpen(context, follows[index].uid ?? 0);
                  },
                );
              },
              itemCount: follows.length,
            ),
          )),
    );
  }

  void showBottomOpen(BuildContext context, int uid) {
    showModalBottomSheet(
        enableDrag: false,
        elevation: 0,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )),
                    ),
                    Container(
                        padding: EdgeInsets.only(bottom: 20.0, top: 16),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                        ),
                        child: Column(children: <Widget>[
                          CustomText(
                              text: "操作",
                              textAlign: Alignment.center,
                              padding: EdgeInsets.only(bottom: 16),
                              textStyle:
                                  TextStyle(fontSize: 17, color: Colors.black)),
                          Divider(
                            height: 1,
                            color: Color(0xffE6E6E6),
                          ),
                          TextButton(
                              onPressed: () {
                                del(uid);
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                  text: "取消关注",
                                  textAlign: Alignment.center,
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Colors.black))),
                          Divider(
                            height: 1,
                            color: Color(0xffE6E6E6),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                  text: "取消",
                                  textAlign: Alignment.center,
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  textStyle: TextStyle(
                                      fontSize: 17, color: Color(0xffFD4343)))),
                        ]))
                  ]));
        });
  }

  int pageNo = 1;
  List<FollowInfo> follows = [];

  void _onRefresh() async {
    pageNo = 1;
    getList();
  }

  // 上拉加载更多
  void _onLoading() async {
    pageNo++;
    getList(isLoad: true);
  }

  void getList({bool isLoad = false}) {
    getFollowList(pageNo).then((value) => {
          if (value.isOk())
            if (isLoad)
              {
                _refreshController.loadComplete(),
                follows.addAll(value.data ?? []),
                updatePage(),
              }
            else
              {
                _refreshController.refreshCompleted(),
                follows = value.data ?? [],
                updatePage(),
              }
          else
            {
              isLoad
                  ? _refreshController.loadFailed()
                  : _refreshController.refreshFailed()
            }
        });
  }

  void updatePage() {
    setState(() {});
  }

  void del(int uid) {
    delFollow(uid).then((value) => {
          if (value.isOk()) {_onRefresh()}
        });
  }
}
