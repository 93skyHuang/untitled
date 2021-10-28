import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/widgets/card_image.dart';

class ItemVisitor extends StatelessWidget {
  String name;
  String img;
  String info;
  String time;
  bool isSvip;
  VoidCallback onPressed;

  ItemVisitor(
      {required this.name,
      required this.img,
      required this.info,
      required this.time,
      required this.onPressed,
      this.isSvip = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSvip ? onPressed : null,
      child: Container(
        height: 64,
        padding: EdgeInsets.only(left: 16, right: 20),
        child: Row(
          children: [
            cardNetworkImage(
                img, ScreenUtil().setWidth(44), ScreenUtil().setHeight(44),
                radius: 8),
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                        Text(info,
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF8C8C8C))),
                      ],
                    ))),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isSvip)
                  Image(
                    image: AssetImage('assets/images/icon_lock.png'),
                    width: 9,
                    height: 12,
                  ),
                Text(time,
                    style: TextStyle(fontSize: 10, color: Color(0xFF8C8C8C))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
