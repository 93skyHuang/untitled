import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                img,
                width: 44,
                height: 44,
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Text(name, style: TextStyle(fontSize: 14, color: Colors.black)),
                Text(info,
                    style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C))),
              ],
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
