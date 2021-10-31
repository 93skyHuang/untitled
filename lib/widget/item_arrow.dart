import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemArrow extends StatefulWidget {
  String text;
  String value;
  VoidCallback onPressed;
  EdgeInsetsGeometry margin; //控件的margin属性 外边距
  EdgeInsetsGeometry padding;
  bool showDivider; //是否显示下划线
  bool showArrow;//是否显示箭头

  ItemArrow({
    required this.text,
    required this.onPressed,
    this.value = '',
    this.showDivider = true,
    this.showArrow = true,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
  });

  @override
  State<StatefulWidget> createState() {
    return ItemArrowState();
  }
}

class ItemArrowState extends State<ItemArrow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: this.widget.onPressed,
          child: Container(
            height: 53,
            margin: this.widget.margin,
            padding: this.widget.padding,
            child: Row(
              children: [
                Expanded(
                    child: Text(this.widget.text,
                        style: TextStyle(fontSize: 15, color: Colors.black))),
                Text(this.widget.value,
                    style: TextStyle(fontSize: 15, color: Color(0xFF8C8C8C))),
                if (this.widget.showArrow) Icon(Icons.chevron_right, color: Color(0xFF8C8C8C)),
              ],
            ),
          ),
        ),
        if (this.widget.showDivider)
          Container(
            height: 1.0,
            color: Color(0xffE6E6E6),
          ),
      ],
    );
  }
}
