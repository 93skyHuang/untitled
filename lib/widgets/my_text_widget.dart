// 当前是否已是 "全文" 状态
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextPainter _isExpansion(String text, {double maxWidth = double.infinity}) {
  return TextPainter(
      maxLines: 3,
      text: TextSpan(
          text: text,
          style:
              TextStyle(fontSize: ScreenUtil().setSp(14), color: Colors.black)),
      textDirection: TextDirection.ltr)
    ..layout(maxWidth: maxWidth);
}

Widget singeLineText(String text, double width, TextStyle style) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: width),
    child: Text(text,
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: style),
  );
}
