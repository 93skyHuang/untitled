import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/network/bean/chat_user_info.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/custom_text_15radius.dart';
import 'package:untitled/widget/item_menu.dart';

class InfoPage extends StatelessWidget {
  UserBasic info;

  InfoPage({
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    List<String> verify = ['实名认证', '头像认证', '真人认证', '手机认证'];
    List<String> icons = [
      "assets/images/icon_verified_name.png",
      "assets/images/icon_verified_avatar.png",
      "assets/images/icon_verified_person.png",
      "assets/images/icon_verified_phone.png"
    ];
    List<Widget> details = [
      CustomTextRadius(
        text: '性别：男',
      ),
      CustomTextRadius(
        text: '身高：165cm',
      ),
      CustomTextRadius(
        text: '生肖：马',
      ),
      CustomTextRadius(
        text: '星座：摩羯座',
      ),
      CustomTextRadius(
        text: '城市：成都',
      ),
      CustomTextRadius(
        text: '月收入：1万-2万',
      ),
      CustomTextRadius(
        text: '学历：本科',
      )
    ];

    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: '一天前\n四川成都｜女｜20岁｜90后',
                textStyle: TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                margin: EdgeInsets.only(left: 18, top: 20, bottom: 10),
              ),
              Container(
                  margin: EdgeInsets.only(right: 18, top: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage("assets/images/icon_edit.png"),
                        ),
                        CustomText(
                          text: '编辑资料',
                          margin: EdgeInsets.only(left: 3),
                          textStyle:
                              TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                        ),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.only(left: 6, right: 6, bottom: 2),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    border: new Border.all(width: 1, color: Color(0xff8C8C8C)),
                  ))
            ],
          ),
          Divider(
            color: Color(0xffE6E6E6),
          ),
          CustomText(
            text: '我的介绍',
            textStyle: TextStyle(fontSize: 14, color: Colors.black),
            margin: EdgeInsets.only(left: 16, top: 5),
          ),
          Container(
              margin: EdgeInsets.all(16),
              child: CustomText(
                text: '我在寻求四川成都，年龄20-29岁身高165cm女生',
                textStyle: TextStyle(fontSize: 12, color: Colors.black),
              ),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 9, top: 9),
              decoration: new BoxDecoration(
                color: Color(0xffE6E6E6),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              )),
          Divider(
            color: Color(0xffE6E6E6),
          ),
          CustomText(
            text: '个人认证',
            textStyle: TextStyle(fontSize: 14, color: Colors.black),
            margin: EdgeInsets.only(left: 16, top: 5),
          ),
          Container(
            height: 75,
            padding: EdgeInsets.only(left: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return new ItemMenu(
                  margin: EdgeInsets.only(right: 30),
                  text: verify[index],
                  img: icons[index],
                  onPressed: () {},
                );
              },
              itemCount: verify.length,
            ),
          ),
          Divider(
            color: Color(0xffE6E6E6),
          ),
          CustomText(
            text: '基本资料',
            textStyle: TextStyle(fontSize: 14, color: Colors.black),
            margin: EdgeInsets.only(left: 16, top: 5),
          ),
          Wrap(
            children: details,
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(top: 18),
            color: Color(0xffE6E6E6),
          ),
          CustomText(
            text: '择偶要求',
            textStyle: TextStyle(fontSize: 14, color: Colors.black),
            margin: EdgeInsets.only(left: 16, top: 5),
          ),
          Wrap(
            children: details,
          ),
        ],
      ),
    ));
  }
}
