import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/page/mine/verified_page.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/item_menu.dart';

class VerifyCenterPage extends StatefulWidget {
  const VerifyCenterPage();

  @override
  State<VerifyCenterPage> createState() => _VerifyCenterPageState();
}

class _VerifyCenterPageState extends State<VerifyCenterPage> {
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
            Text("认证中心", style: TextStyle(fontSize: 17, color: Colors.black)),
        backgroundColor: Color(0xFFF5F5F5),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 220,
                margin:
                    EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
                padding:
                    EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  children: [
                    Text('实名认证',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    CustomText(
                      text: '迅速提升吸引力，更容易被人喜欢',
                      textStyle:
                          TextStyle(fontSize: 12, color: Color(0xFF8C8C8C)),
                      textAlign: Alignment.center,
                      margin: EdgeInsets.only(top: 2, bottom: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ItemMenu(
                          text: '认证标识',
                          img: "assets/images/icon_verified_name.png",
                          onPressed: () {},
                        ),
                        ItemMenu(
                          text: '提升推荐',
                          img: "assets/images/verify_center_recommond.png",
                          onPressed: () {},
                        ),
                        ItemMenu(
                          text: '加速曝光',
                          img: "assets/images/verify_center_arrow.png",
                          onPressed: () {},
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(()=>VerifiedPage());
                      },
                      child:Container(
                          height: 40,
                          alignment: Alignment.center,
                          width: 214,
                          margin: EdgeInsets.only(top: 20),
                          decoration: new BoxDecoration(
                            color: Color(0xffF3CD8E),
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          ),
                          child: Text(
                            "立即认证",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          )) ,
                    )

                  ],
                )),
          ],
        ),
      ),
    );
  }
}
