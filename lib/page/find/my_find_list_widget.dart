//
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/discover_info.dart';
import 'package:untitled/network/http_manager.dart';

import 'find_controller.dart';

///发现页面列表页面 需要传入发现id
class MyFindListWidget extends StatefulWidget {
  int id;

  MyFindListWidget(this.id, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyFindListWidgetState();
  }
}

class _MyFindListWidgetState extends State<MyFindListWidget>
    with AutomaticKeepAliveClientMixin {
  List<DiscoverInfo> _list = [];
  int pageNo = 1;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    logger.i(widget.id);
    super.build(context);
    return RefreshConfiguration(
      // Viewport不满一屏时,禁用上拉加载更多功能,应该配置更灵活一些，比如说一页条数大于等于总条数的时候设置或者总条数等于0
      hideFooterWhenNotFull: true,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        footer: const ClassicFooter(),
        // 配置默认底部指示器
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: GridView.count(
          padding: const EdgeInsets.all(20.0),
          crossAxisSpacing: 10.0,
          crossAxisCount: 2,
          // children: _getWidgets(),
          children: <Widget>[
            const Text('我喜欢看电视'),
            const Text('我喜欢上网'),
            const Text('我喜欢游泳'),
            const Text('我喜欢打乒乓球'),
            const Text('我喜欢打篮球'),
            const Text('我喜欢健身')
          ]
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onRefresh() async {
    logger.i("_onRefresh");
    pageNo = 1;
    getData();
  }

  // 上拉加载更多
  void _onLoading() async {
    logger.i("_onLoading");
    pageNo++;
    getData(isLoad: true);
  }

  void getData({bool isLoad = false}) {
    getDiscoverList(pageNo, widget.id).then((value) => {
          if (value.isOk())
            {
              if (isLoad)
                {
                  _refreshController.loadComplete(),
                  _list.addAll(value.data!),
                }
              else
                {_list = value.data!, _refreshController.refreshCompleted()}
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

  List<Widget> _getWidgets() {
    List<Widget> list = [];
    int length = _list.length;
    for (int i = 0; i < length; i++) {
      list.add(_item(_list[i]));
    }
    return list;
  }

  Widget _item(DiscoverInfo discoverInfo) {
    return Column(
      children: [
        _imageWrapper(discoverInfo),
      ],
    );
  }

  Widget _imageWrapper(DiscoverInfo discoverInfo) {
    return SizedBox(
      width: 150,
      height: 150,
      child: CachedNetworkImage(
        imageUrl: discoverInfo.constellation!,
        placeholder: (context, url) => Image.asset('images/image-default.png'),
      ),
    );
  }
}
