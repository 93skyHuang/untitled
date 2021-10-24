import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_fan.dart';
import 'fans_controller.dart';

class FanPage extends StatelessWidget {
  FanPage();

  FansController _fansController = new FansController();

  @override
  Widget build(BuildContext context) {
    _fansController.getList();
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
              Text("我的粉丝", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,
        ),
        body: Obx(() => Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return new ItemFan(
                        name: '${_fansController.fans[index].cname}',
                        img: _fansController.fans[index].headImgUrl == null
                            ? "https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg"
                            : _fansController.fans[index].headImgUrl,
                        info:
                            '${_fansController.fans[index].distance}，${_fansController.fans[index].age}，${_fansController.fans[index].constellation}',
                        onPressed: () {},
                        time: '${_fansController.fans[index].time}',
                      );
                    },
                    itemCount: _fansController.fans.length,
                  ),
                ),
                if(!GetStorageUtils.getSvip())Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: '非会员只能查看前20位粉丝哦',textStyle: TextStyle(fontSize: 10,color: Color(0xff8C8C8C)),margin: EdgeInsets.only(bottom: 30,top: 20),),
                    TextButton(
                      onPressed: () {},
                      child: CustomText(margin: EdgeInsets.only(top: 6),text: '去开通',textStyle: TextStyle(fontSize: 12,color: Color(0xffFD4343))),
                    )
                  ],
                ),
              ],
            )));
  }
}
