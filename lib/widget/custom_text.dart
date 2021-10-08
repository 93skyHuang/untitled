import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String text;
  TextStyle textStyle;
  EdgeInsetsGeometry margin; //控件的margin属性 外边距
  Alignment textAlign;

  CustomText(
      {required this.text,
      this.textStyle = const TextStyle(
        fontSize: 15.0,
        color: Colors.black
      ),
      this.textAlign = Alignment.topLeft,
      this.margin = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: textAlign,
      margin: margin,
      child: Text(text,
          style: textStyle),
    );
  }
}
