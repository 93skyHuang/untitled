import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/widget/item_fan.dart';
import 'beliked_controller.dart';

class BelikedPage extends StatelessWidget {
  BelikedPage();

  BelikedController _belikedController = new BelikedController();

  @override
  Widget build(BuildContext context) {
    _belikedController.getList();
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
        body: Container(
          height: double.infinity,
          child: Obx(
                () => ListView.builder(
              itemBuilder: (context, index) {
                return new ItemFan(
                  name: '${_belikedController.fans[index].cname}',
                  img: _belikedController.fans[index].headImgUrl == null
                      ? "https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg"
                      : _belikedController.fans[index].headImgUrl,
                  info:
                  '${_belikedController.fans[index].distance}，${_belikedController.fans[index].age}，${_belikedController.fans[index].constellation}',
                  onPressed: () {},
                  time: '${_belikedController.fans[index].time}',
                );
              },
              itemCount: _belikedController.fans.length,
            ),
          ),
        ));
  }
}
