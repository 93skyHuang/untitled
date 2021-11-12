import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/network/bean/visitor_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/personcenter/user_home_page.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widget/item_visitor.dart';
import 'package:untitled/widget/loading.dart';
import 'package:untitled/widgets/my_classic.dart';

class VisitorPage extends StatefulWidget {
  VisitorPage();

  @override
  State<StatefulWidget> createState() {
    return _VisitorPageState();
  }
}

class _VisitorPageState extends State<VisitorPage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isSvip = GetStorageUtils.getSvip();

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
            Text("我的访客", style: TextStyle(fontSize: 17, color: Colors.black)),
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
                  return new ItemVisitor(
                    name: '${visitors[index].cname}',
                    img: visitors[index].headImgUrl ?? '',
                    info:
                        '${visitors[index].region}，${visitors[index].age}，${visitors[index].constellation}',
                    onPressed: () {
                      Get.to(() => UserHomePage(uid: visitors[index].uid ?? 0));
                    },
                    time: '${visitors[index].time}',
                    isSvip: isSvip,
                  );
                },
                itemCount: visitors.length,
              ),
          )),
    );
  }
  int pageNo = 1;
  List<VisitorInfo> visitors = [];

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
    getVisitor(pageNo).then((value) => {
          if (value.isOk())
            if (isLoad)
              {
                value.data == null
                    ? _refreshController.loadNoData()
                    : _refreshController.loadComplete(),
                visitors.addAll(value.data ?? []),
                updatePage(),
              }
            else
              {
                _refreshController.refreshCompleted(),
                visitors = value.data ?? [],
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

  @override
  bool get wantKeepAlive => true;
}
