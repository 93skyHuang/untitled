import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/trend_img.dart';

import 'expandable_text.dart';

class ItemVideo extends StatelessWidget {
  Trends trends;
  VoidCallback onPressed;


  double contextWidth =
      ScreenUtil().screenWidth - ScreenUtil().setWidth(70 + 32);
  ItemVideo(
      {
        required this.trends,
        required this.onPressed,
      }
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
              Container(
                width: 70,
                child: CustomText(
                  text: '${trends.time}',
                  textStyle: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TQExpandableText(
                    '${trends.content}',
                  ),
                  if (trends.imgArr!.isNotEmpty)
                    TrendImg(
                      imgs: trends.imgArr ?? [],
                      showAll: true,
                      contextWidth: contextWidth,
                      onClick: (String img) {},
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
                        text: '${trends.fabulousSum}',
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
                        text: '${trends.commentSum}',
                        textStyle:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                        margin: EdgeInsets.only(
                            right: 20, top: 16, bottom: 2, left: 5),
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}
