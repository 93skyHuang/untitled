import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/page/mine/visitor/visitor_controller.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widget/item_visitor.dart';


class VisitorPage extends StatelessWidget {
  bool isSvip=GetStorageUtils.getSvip();
  VisitorPage();

  VisitorController _visitorController = new VisitorController();

  @override
  Widget build(BuildContext context) {
    _visitorController.getList();
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
        body: Container(
          height: double.infinity,
          child: Obx(
            () => ListView.builder(
              itemBuilder: (context, index) {
                return new ItemVisitor(
                  name: '${_visitorController.visitors[index].cname}',
                  img: _visitorController.visitors[index].headImgUrl == null
                      ? "https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg"
                      : _visitorController.visitors[index].headImgUrl,
                  info:'',
                      // '${_visitorController.visitors[index].distance}，${_visitorController.visitors[index].age}，${_visitorController.visitors[index].constellation}',
                  onPressed: () {},
                  time: '${_visitorController.visitors[index].time}',
                  isSvip: isSvip,
                );
              },
              itemCount: _visitorController.visitors.length,
            ),
          ),
        ));
  }
}
