import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemFan extends StatelessWidget {
  String name;
  String img;
  String info;
  String time;
  VoidCallback onPressed;

  ItemFan({
    required this.name,
    required this.img,
    required this.info,
    required this.time,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 64,
        padding: EdgeInsets.only(left: 16, right: 20),
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
            Text(time,
                style: TextStyle(fontSize: 10, color: Color(0xFF8C8C8C))),
          ],
        ),
      ),
    );
  }
}
