import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/widgets/card_image.dart';

class TrendImg extends StatelessWidget {
  List<String?> imgs;
  bool showAll;
  MyCallBack onClick; //这里类型用我们自定义的,more的时候显示代表查看全部图片
  double contextWidth;

  TrendImg({
    required this.imgs,
    required this.onClick,
    required this.contextWidth,
    this.showAll = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showAll) {
      return showAllPic();
    } else {
      if (imgs.length == 1) {
        return singlePic();
      } else if (imgs.length == 2) {
        return doublePic();
      } else if (imgs.length == 3) {
        return triPic();
      } else {
        return multPic();
      }
    }
  }

  Widget showAllPic() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imgs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              GestureDetector(
                onTap: () {
                  onClick(imgs[index] ?? '');
                },
                child: customNetworkImage(
                  imgs[index] ?? '',
                  contextWidth / 2 - 10,
                  contextWidth / 2 - 10,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget singlePic() {
    return Container(
      width: contextWidth,
      margin: EdgeInsets.only( top: 5),
      child: normalNetWorkImage(imgs[0] ?? ''),
    );
  }

  Widget doublePic() {
    return Container(
      width: contextWidth,
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          customNetworkImage(
              imgs[0] ?? '', contextWidth / 2 - 10, contextWidth / 2 - 10,
              radius: BorderRadius.only(
                  bottomLeft: Radius.circular(8), topLeft: Radius.circular(8))),
          customNetworkImage(
              imgs[1] ?? '', contextWidth / 2 - 10, contextWidth / 2 - 10,
              radius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8))),
        ],
      ),
    );
  }

  Widget triPic() {
    return Container(
      width: contextWidth,
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          customNetworkImage(imgs[0] ?? '', 2 * contextWidth / 3 - 12,
              contextWidth * 2 / 3 - 12,
              radius: BorderRadius.only(
                  bottomLeft: Radius.circular(8), topLeft: Radius.circular(8))),
          Column(
            children: [
              customNetworkImage(
                  imgs[1] ?? '', contextWidth / 3 - 10, contextWidth / 3 - 10,
                  radius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              customNetworkImage(
                  imgs[2] ?? '', contextWidth / 3 - 10, contextWidth / 3 - 10,
                  radius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
            ],
          )
        ],
      ),
    );
  }

  Widget multPic() {
    return Container(
      width: contextWidth,
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          customNetworkImage(imgs[0] ?? '', 2 * contextWidth / 3 - 18,
              contextWidth * 2 / 3 - 18,
              radius: BorderRadius.only(
                  bottomLeft: Radius.circular(8), topLeft: Radius.circular(8))),
          Column(
            children: [
              customNetworkImage(
                  imgs[1] ?? '', contextWidth / 3 - 10, contextWidth / 3 - 10,
                  radius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              GestureDetector(
                  onTap: () {
                    onClick('more');
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            width: contextWidth / 3 - 10,
                            height: contextWidth / 3 - 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(124, 127, 115, .3),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(imgs[2] ?? ''),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              //可以看源码
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (Color.fromRGBO(225, 225, 225, 1))
                                      .withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '+${imgs.length - 2}',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          )
                        ],
                      )))
            ],
          )
        ],
      ),
    );
  }
}

typedef MyCallBack = Function(String string);
