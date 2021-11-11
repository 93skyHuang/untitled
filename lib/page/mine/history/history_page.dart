import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/network/bean/my_foot_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/personcenter/user_home_page.dart';
import 'package:untitled/widget/item_fan.dart';
import 'package:untitled/widgets/my_classic.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage();

  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends State<HistoryPage>
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
            Text("我的足迹", style: TextStyle(fontSize: 17, color: Colors.black)),
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
                return ItemFan(
                  name: '${historys[index].cname}',
                  img: historys[index].headImgUrl ?? "",
                  info:
                      '${historys[index].region}，${historys[index].age}，${historys[index].constellation}',
                  onPressed: () {
                    Get.to(() => UserHomePage(uid: historys[index].uid ?? 0));},
                  time: '${historys[index].time}',
                );
              },
              itemCount: historys.length,
            ),
          )),
    );
  }

  int pageNo = 1;
  List<MyFootInfo> historys = [];

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
    getMyFootList(pageNo).then((value) => {
          if (value.isOk())
            if (isLoad)
              {
                value.data == null
                    ? _refreshController.loadNoData()
                    : _refreshController.loadComplete(),
                historys.addAll(value.data ?? []),
                updatePage(),
              }
            else
              {
                _refreshController.refreshCompleted(),
                historys = value.data ?? [],
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
}
