import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextRadius extends StatelessWidget {
  String text;
  TextStyle textStyle;
  EdgeInsetsGeometry margin; //控件的margin属性 外边距
  Alignment textAlign;

  CustomTextRadius(
      {required this.text,
      this.textStyle = const TextStyle(fontSize: 12.0, color: Colors.black),
      this.textAlign = Alignment.topLeft,
      this.margin = const EdgeInsets.only(right: 16,top: 10)});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        decoration: new BoxDecoration(
          color: Color(0xFFE2E2E2),
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        alignment: textAlign,
        margin: margin,
        padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 5),
        child: Text(text, style: textStyle),
      )
    ]);
  }
}
