import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/widgets/card_image.dart';

class TrendImg extends StatelessWidget {
  List<String?> imgs;
  bool showAll;
  bool isVideo;
  MyCallBack onClick; //这里类型用我们自定义的,more的时候显示代表查看全部图片
  double contextWidth;

  TrendImg({
    required this.imgs,
    required this.onClick,
    required this.contextWidth,
    this.showAll = false,
    this.isVideo = false,
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
                  onClick(index);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    customNetworkImage(
                      imgs[index] ?? '',
                      contextWidth / 2 - 10,
                      contextWidth / 2 - 10,
                    ),
                    isVideo
                        ? Image.asset('assets/images/bofang.png')
                        : Container(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget singlePic() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            width: contextWidth,
            margin: EdgeInsets.only(top: 5),
            child: GestureDetector(
              onTap: () {
                onClick(0);
              },
              child: normalNetWorkImage(imgs[0] ?? ''),
            )),
        isVideo ? Image.asset('assets/images/bofang.png') : Container(),
      ],
    );
  }

  Widget doublePic() {
    return Container(
      width: contextWidth,
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              onClick(0);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                customNetworkImage(
                    imgs[0] ?? '', contextWidth / 2 - 10, contextWidth / 2 - 10,
                    radius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topLeft: Radius.circular(8))),
                isVideo ? Image.asset('assets/images/bofang.png') : Container(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              onClick(1);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                customNetworkImage(
                    imgs[1] ?? '', contextWidth / 2 - 10, contextWidth / 2 - 10,
                    radius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topLeft: Radius.circular(8))),
                isVideo ? Image.asset('assets/images/bofang.png') : Container(),
              ],
            ),
          ),
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
          GestureDetector(
            onTap: () {
              onClick(0);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                customNetworkImage(imgs[0] ?? '', 2 * contextWidth / 3 - 12,
                    contextWidth * 2 / 3 - 12,
                    radius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topLeft: Radius.circular(8))),
                isVideo ? Image.asset('assets/images/bofang.png') : Container(),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  onClick(1);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    customNetworkImage(imgs[1] ?? '', 2 * contextWidth / 3 - 10,
                        contextWidth * 2 / 3 - 10,
                        radius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topLeft: Radius.circular(8))),
                    isVideo
                        ? Image.asset('assets/images/bofang.png')
                        : Container(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  onClick(2);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    customNetworkImage(imgs[2] ?? '', 2 * contextWidth / 3 - 10,
                        contextWidth * 2 / 3 - 10,
                        radius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topLeft: Radius.circular(8))),
                    isVideo
                        ? Image.asset('assets/images/bofang.png')
                        : Container(),
                  ],
                ),
              ),
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
          GestureDetector(
            onTap: () {
              onClick(0);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                customNetworkImage(imgs[0] ?? '', 2 * contextWidth / 3 - 18,
                    contextWidth * 2 / 3 - 18,
                    radius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topLeft: Radius.circular(8))),
                isVideo ? Image.asset('assets/images/bofang.png') : Container(),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  onClick(1);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    customNetworkImage(imgs[1] ?? '', contextWidth / 3 - 10,
                        contextWidth / 3 - 10,
                        radius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    isVideo
                        ? Image.asset('assets/images/bofang.png')
                        : Container(),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    onClick(0);
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

typedef MyCallBack = Function(int index);
