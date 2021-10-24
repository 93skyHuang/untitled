import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/video_trends_info.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/widgets/card_image.dart';
import 'package:untitled/widgets/my_classic.dart';
import 'package:untitled/widgets/null_list_widget.dart';

import '../video_play_page.dart';

///视频页面
class VideoListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoListPageState();
  }
}

class _VideoListPageState extends State<VideoListPage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int pageNo = 1;
  List<VideoTrendsInfo> _videoList = [];

  @override
  void initState() {
    logger.i('initState');
    _onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshConfiguration(
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
        child: _getListView(),
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
    getVideoTrends(pageNo).then((value) => {
          logger.i(value),
          if (value.isOk())
            {
              if (isLoad)
                {
                  value.data == null
                      ? _refreshController.loadNoData()
                      : _refreshController.loadComplete(),
                  _videoList.addAll(value.data ?? []),
                  updatePage(),
                }
              else
                {
                  _refreshController.refreshCompleted(),
                  _videoList = value.data ?? [],
                  updatePage(),
                }
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
    logger.i('updatePage');
    setState(() {});
  }

  Widget _getListView() {
    int length = _videoList.length;
    if (length == 0) {
      return NullListWidget();
    } else {
      List<Widget> listView = [];
      for (int i = 0; i < length; i++) {
        listView.add(_itemView(_videoList[i]));
      }
      return ListView(
        children: [
          // _item1(),
          GridView.count(
            shrinkWrap: true,
            //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(),
            //禁用滑动事件
            //GridView内边距
            padding: EdgeInsets.all(ScreenUtil().setWidth(4)),
            //垂直子Widget之间间距
            mainAxisSpacing: ScreenUtil().setWidth(4),
            //一行的Widget数量
            crossAxisCount: 2,
            //子Widget宽高比例
            childAspectRatio: 182 / 242,
            children: listView,
          )
        ],
      );
    }
  }

  Widget _itemView(VideoTrendsInfo info) {
    return GestureDetector(
      onTap: () {
        Get.to(TrendVideoPlayPage(), arguments: {'videoTrendsInfo': info});
      },
      child: Container(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            cardNetworkImage('${info.imgArr}', ScreenUtil().setWidth(182),
                ScreenUtil().setHeight(242),
                radius: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(160)),
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '${info.content}',
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Color(0xffffffff)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
