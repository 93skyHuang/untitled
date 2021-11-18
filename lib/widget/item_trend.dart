import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/trend_img.dart';

import 'expandable_text.dart';

class ItemTrend extends StatelessWidget {
  Trends trends;
  VoidCallback onPressed;
  VoidCallback clickLike;
  VoidCallback? deleteTrend;

  ItemTrend({
    required this.trends,
    required this.onPressed,
    required this.clickLike,
    required this.deleteTrend,
  });

  double contextWidth =
      ScreenUtil().screenWidth - ScreenUtil().setWidth(70 + 32);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 16, right: 16),
          decoration: BoxDecoration(
              color: Color(0xff242932),
              border: Border(
                  bottom: BorderSide(
                      color: Color(0xff2A2F37),
                      width: 1,
                      style: BorderStyle.solid))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                child: CustomText(
                  text: '${trends.time}',
                  textStyle: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (trends.content != null && trends.content != '')
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: TQExpandableText(
                        '${trends.content ?? ''}',
                      ),
                    ),
                  if (trends.imgArr!.isNotEmpty)
                    TrendImg(
                      imgs: trends.imgArr ?? [],
                      showAll: true,
                      contextWidth: contextWidth,
                      onClick: (int index) {
                        onPressed();
                      },
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                          //点赞
                          onTap: () {
                            clickLike.call();
                          },
                          child: Image(
                            width: 17,
                            height: 17,
                            color: trends.isTrendsFabulous == 1
                                ? Color(0xff6385FF)
                                : Colors.white,
                            image:
                                AssetImage("assets/images/like_unchecked.png"),
                          )),
                      CustomText(
                        text: '${trends.fabulousSum}',
                        textStyle:
                            TextStyle(fontSize: 14, color: Color(0xfff5f5f5)),
                        margin: EdgeInsets.only(right: 20, left: 5),
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: Image(
                              height: 20,
                              image: AssetImage(
                                  "assets/images/icon_comment.png"))),
                      CustomText(
                        text: '${trends.commentSum}',
                        textStyle:
                            TextStyle(fontSize: 14, color: Color(0xfff5f5f5)),
                        margin: EdgeInsets.only(right: 20, left: 5),
                      ),
                       Expanded(
                              child:deleteTrend == null
                                  ? Container()
                                  : GestureDetector(
                                  onTap: () {
                                    deleteTrend?.call();
                                  },
                                  child: CustomText(
                                    textAlign: Alignment.centerRight,
                                    text: '删除',
                                    textStyle: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                    margin:
                                        EdgeInsets.only(right: 5, bottom: 0),
                                  )),
                            )
                    ],
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}
