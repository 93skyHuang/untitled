import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/network/bean/new_trends_info.dart';
import 'package:untitled/widgets/card_image.dart';


class ItemComment extends StatelessWidget {
  CommentBean? comment;
  VoidCallback onPressed;

  ItemComment({
    required this.comment,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.only(left: 16, right: 10),
      child: Row(
        children: [
          cardNetworkImage(comment!.headImgUrl ?? '',
              ScreenUtil().setWidth(44), ScreenUtil().setWidth(44)),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${comment!.cname}',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                Text('${comment!.content}',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C))),
              ],
            ),
          )),
          GestureDetector(
            onTap: onPressed,
            child: Image(
              image: AssetImage('assets/images/icon_more.png'),
              width: 20,
              height: 20,
            ),
          ),
          Text('${comment!.fabulousSum}',
              style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C))),
        ],
      ),
    );
  }
}
