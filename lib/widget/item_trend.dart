import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/network/bean/chat_user_info.dart';
import 'package:untitled/widget/custom_text.dart';

import 'expandable_text.dart';

class ItemTrend extends StatelessWidget {
  // Trends trends;
  // VoidCallback onPressed;

  ItemTrend(// {
      //   required this.trends,
      //   required this.onPressed,
      // }
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.only(top: 20, bottom: 16, left: 16,right: 16 ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Color(0xffE6E6E6),
                      width: 0.5,
                      style: BorderStyle.solid))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: '一天前',
                textStyle: TextStyle(fontSize: 14, color: Colors.black),
                margin: EdgeInsets.only(right: 20),
              ),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TQExpandableText(
                    '测试长测测试测试测试长 长文字折叠测试长 长文字折叠文字折叠测试长 长文字折叠文字折叠试长 长文字折叠测试长 长文字折叠测试长 长文字折叠测试长 长文字折叠测试长 长文字折叠测试长 长文字折叠测试长 长文字折叠测试长 长文字折叠长文字折叠',
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: Image(
                            image:
                                AssetImage("assets/images/icon_heart_grey.png"),
                          )),
                      CustomText(
                        text: '20',
                        textStyle:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                        margin: EdgeInsets.only(
                            right: 20, top: 16, bottom: 2, left: 5),
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: Image(
                              image: AssetImage(
                                  "assets/images/icon_comment.png"))),
                      CustomText(
                        text: '10',
                        textStyle:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                        margin: EdgeInsets.only(
                            right: 20, top: 16, bottom: 2, left: 5),
                      ),
                      Expanded(
                          child: CustomText(
                        textAlign: Alignment.centerRight,
                        text: '删除',
                        textStyle: TextStyle(fontSize: 12, color: Colors.black),
                        margin: EdgeInsets.only(right: 5, top: 13, bottom: 2),
                      )),
                    ],
                  ),
                ],
              )),
            ],
          ),
          // Divider(
          //   color: Color(0xffE6E6E6),
          // )
        ));
  }
}
