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
    String longText = '超过最大行数三行的多行文本超过最大行数三行的多行文本超过最大行数三行的多行文本'
        '超过最大行数三行的多行文本超过最大行数三行的多行文本超过最大行数三行的多行文本超过最大行数三行的多行文本';
    return GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(text: '一天前',textStyle: TextStyle(fontSize: 14,color: Colors.black),margin: EdgeInsets.only(left: 18,top: 20),),
                  // CustomText(text: '不知道说点什么，那就随便说几句。凑凑字数啊～今天很开心的',textStyle: TextStyle(fontSize: 14,color: Color(0xff8C8C8C)),margin: EdgeInsets.only(left: 20,top: 20,right: 18)),
                  // TQExpandableText(
                  //   text: longText,
                  //   maxLines: 3,
                  //   style: TextStyle(fontSize: 15, color: Colors.black),
                  //   expand: false,
                  // ),  TQExpandableText(

                  Expanded(
                    child: TQExpandableText(
                        '测试长文字折叠 文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠测试长文字折叠',
                      ),
                  ),

                ],
              ),
              Text('data'),
              Divider(
                color: Color(0xffE6E6E6),
              )
            ],
          ),
        ));
  }  }
