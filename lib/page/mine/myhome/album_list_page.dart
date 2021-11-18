import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/album_bean.dart';
import 'package:untitled/network/logger.dart';
import 'package:untitled/widgets/card_image.dart';

class AlbumListPage extends StatefulWidget {
  int uid;

  AlbumListPage(this.uid);

  @override
  State<StatefulWidget> createState() {
    return _AlbumListPageState(uid);
  }
}

class _AlbumListPageState extends State with AutomaticKeepAliveClientMixin {
  int uid;

  _AlbumListPageState(this.uid);

  List<AlbumBean> _list = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      logger.i('addPostFrameCallback');
      getInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _photo();
  }

  Widget _photo() {
    return ListView.builder(
        itemCount: _list.length,
        //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
        itemBuilder: (BuildContext context, int index) {
          //Widget Function(BuildContext context, int index)
          AlbumBean a = _list[index];
          return
            Padding(padding: EdgeInsets.only(left: 16,right: 16),child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${a.date}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  height: 17,
                ),
                GridView.builder(
                    shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                    physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                    itemCount: a.imgArr?.length,
                    //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                        crossAxisCount: 3,
                        //纵轴间距
                        mainAxisSpacing: 10.0,
                        //横轴间距
                        crossAxisSpacing: 10.0,
                        //子组件宽高长度比例
                        childAspectRatio: 1.0),
                    itemBuilder: (BuildContext context, int index) {
                      //Widget Function(BuildContext context, int index)
                      String url = a.imgArr![index];
                      return cardNetworkImage(url, ScreenUtil().setWidth(90), ScreenUtil().setWidth(90));
                    }),
                SizedBox(
                  height: 17,
                ),
              ],
            ),);
        });
  }

  final s =
      "http://moshengapp.oss-cn-beijing.aliyuncs.com/2021/11/11/2d73220211111203021264.jpg";

  void getInfo() {
    AlbumBean albumBean = AlbumBean();
    albumBean.imgArr = [s, s, s, s];
    albumBean.date = '11/9月';
    AlbumBean albumBean1 = AlbumBean();
    albumBean1.imgArr = [s, s, s, s];
    albumBean1.date = '11/9月';
    AlbumBean albumBean2 = AlbumBean();
    albumBean2.date = '11/9月';
    albumBean2.imgArr = [s, s, s, s];
    AlbumBean albumBean3 = AlbumBean();
    albumBean3.imgArr = [s, s, s, s];
    albumBean3.date = '11/9月';
    _list.add(albumBean);
    _list.add(albumBean1);
    _list.add(albumBean2);
    _list.add(albumBean3);
    setInfo();
    // getAlbumBeanList(uid).then((value) => {if (value.isOk()) {}});
  }

  void setInfo() {
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
