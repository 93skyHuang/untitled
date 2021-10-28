import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/widgets/card_image.dart';

class ItemFollow extends StatelessWidget {
  String name;
  String img;
  String info;
  VoidCallback onPressed;
  VoidCallback onMorePressed;

  ItemFollow({
    this.name = "",
    this.img = "",
    this.info = "",
    required this.onPressed,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 64,
        padding: EdgeInsets.only(left: 16, right: 10),
        child: Row(
          children: [
            cardNetworkImage(
                img, ScreenUtil().setWidth(44), ScreenUtil().setHeight(44),
                radius: 8),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                  Text(info,
                      style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C))),
                ],
              ),
            )),
            GestureDetector(
              onTap: onMorePressed,
              child: Image(
                image: AssetImage('assets/images/icon_more.png'),
                width: 20,
                height: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
