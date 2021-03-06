import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/basic/include.dart';

///刷新头
class MyClassicHeader extends StatelessWidget {
  const MyClassicHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const ClassicHeader(
      refreshingText: '数据加载中...',
      releaseText: '释放刷新数据',
      idleText: '下拉刷新',
      completeText: '刷新完成',
      failedText: '获取数据失败',
    );
  }
}

///加载脚
class MyClassicFooter extends StatelessWidget {
  const MyClassicFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const ClassicFooter(
        idleText: '上拉加载',
        loadingText: '加载中...',
        canLoadingText: '上拉加载更多',
        noDataText: '没有数据啦！');
  }
}

///消息加载头
class MsgClassicHeader extends StatelessWidget {
  const MsgClassicHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const ClassicHeader(
        idleText: '',
        refreshingText: '',
        completeText: '',
        failedText: '',
        releaseText: '',
        releaseIcon: Icon(Icons.autorenew, color: MyColor.mainColor),
        completeIcon: null,
        idleIcon: null);
  }
}

///消息加载脚
class MsgClassicFooter extends StatelessWidget {
  const MsgClassicFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const ClassicFooter(
        loadStyle:LoadStyle.HideAlways,
        idleText: '',
        loadingText: '',
        canLoadingText: '',
        noDataText: '',
        canLoadingIcon: null,
        noMoreIcon: null,
        failedIcon: null,
        idleIcon: null);
  }
}
