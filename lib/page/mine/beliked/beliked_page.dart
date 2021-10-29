import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/network/bean/receive_fabulous_msg.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/page/mine/vip/vip_page.dart';
import 'package:untitled/page/personcenter/user_home_page.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_fan.dart';
import 'package:untitled/widgets/my_classic.dart';

class BelikedPage extends StatefulWidget {
  BelikedPage();

  @override
  State<StatefulWidget> createState() {
    return _BelikedPageState();
  }
}

class _BelikedPageState extends State<BelikedPage>
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
              Text("喜欢我的", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,
        ),
        body: Column(
              children: [
                Expanded(
                    child: RefreshConfiguration(
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
                                name: '${belikes[index].cname}',
                                img: belikes[index].headImgUrl ?? "",
                                info:
                                    '${belikes[index].region}，${belikes[index].age}，${belikes[index].constellation}',
                                onPressed: () {
                                  Get.to(() => UserHomePage(uid: belikes[index].id ?? 0));},
                                time: '${belikes[index].time}',
                              );
                            },
                            itemCount: belikes.length,
                          ),
                        ))),
                if (!GetStorageUtils.getSvip())
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: '非会员只能查看前20位哦',
                        textStyle:
                            TextStyle(fontSize: 10, color: Color(0xff8C8C8C)),
                        margin: EdgeInsets.only(bottom: 30, top: 20),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => VipPage());},
                        child: CustomText(
                            margin: EdgeInsets.only(top: 6),
                            text: '去开通',
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xffFD4343))),
                      )
                    ],
                  ),
              ],
            ));
  }

  int pageNo = 1;
  List<ReceiveFabulousMsg> belikes = [];

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
    getReceiveFabulousList(pageNo).then((value) => {
          if (value.isOk())
            if (isLoad)
              {
                _refreshController.loadComplete(),
                belikes.addAll(value.data ?? []),
                updatePage(),
              }
            else
              {
                _refreshController.refreshCompleted(),
                belikes = value.data ?? [],
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
