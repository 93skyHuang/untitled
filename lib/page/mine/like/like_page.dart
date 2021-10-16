import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_follow.dart';

import 'like_controller.dart';

class LikePage extends StatelessWidget {
  LikePage();

  LikeController _likeController = new LikeController();

  @override
  Widget build(BuildContext context) {
    _likeController.getList();
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
              Text("我喜欢的", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,
        ),
        body: Container(
          height: double.infinity,
          child: Obx(
            () => ListView.builder(
              itemBuilder: (context, index) {
                return new ItemFollow(
                  name: '${_likeController.likes[index].cname}',
                  img: _likeController.likes[index].headImgUrl == null
                      ? "https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg"
                      : _likeController.likes[index].headImgUrl,
                  info:
                      '${_likeController.likes[index].distance}，${_likeController.likes[index].age}，${_likeController.likes[index].constellation}',
                  onPressed: () {},
                  onMorePressed: () {
                    showBottomOpen(context,_likeController.likes[index].uid);
                  },
                );
              },
              itemCount: _likeController.likes.length,
            ),
          ),
        ));
  }

  void showBottomOpen(BuildContext context,int uid) {
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
                                _likeController.del(uid);
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                  text: "不喜欢",
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
}
