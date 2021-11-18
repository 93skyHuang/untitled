import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextRadius extends StatelessWidget {
  String text;
  TextStyle textStyle;
  EdgeInsetsGeometry margin; //控件的margin属性 外边距
  Alignment textAlign;
  Color bgColor;

  CustomTextRadius(
      {required this.text,
      this.textStyle = const TextStyle(fontSize: 14.0, color: Color(0xfff5f5f5)),
      this.textAlign = Alignment.topLeft,
      this.bgColor =const Color(0xFFE2E2E2),
      this.margin = const EdgeInsets.only(right: 6,top: 10)});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      if(text!='')
      Container(
        decoration: new BoxDecoration(
          color: bgColor,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        alignment: textAlign,
        margin: margin,
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Text(text, style: textStyle),
      )
    ]);
  }
}
