import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class ItemMenu extends StatefulWidget {
  String text;
  String img;
  VoidCallback onPressed;
  TextStyle textStyle;
  EdgeInsets margin;

  ItemMenu({
    required this.text,
    required this.onPressed,
    required this.img,
    this.textStyle = const TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
    this.margin = const EdgeInsets.all(0),
  });

  @override
  State<StatefulWidget> createState() {
    return ItemMenuState();
  }
}

class ItemMenuState extends State<ItemMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: this.widget.margin,
      child: GestureDetector(
        onTap: this.widget.onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage(this.widget.img),
            ),
            CustomText(
              textAlign: Alignment.center,
              text: this.widget.text,
              margin: EdgeInsets.only(left: 3, top: 4),
              textStyle: this.widget.textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
