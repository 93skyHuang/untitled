import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/basic/include.dart';

//带圆角的网络图片
Widget cardNetworkImage(String url, double widget, double height,
    {ShapeBorder? shape, EdgeInsetsGeometry? margin}) {
  return Card(
    margin: margin ?? EdgeInsets.all(4),
    shape: shape ??
        RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(4)),
    clipBehavior: Clip.antiAlias,
    color: Colors.white,
    child: SizedBox(
        width: widget,
        height: height,
        child: CachedNetworkImage(
          fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
          imageUrl: url,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/image_load_failed.png',
            fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
          ),
        )),
  );
}

Widget normalNetWorkImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => const CircularProgressIndicator(),
    errorWidget: (context, url, error) => Image.asset(
      'assets/images/image_load_failed.png',
    ),
  );
}

Widget clipImage(String imagePath,
    {double circular = 4, double? width, double? height, BoxFit? fit}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(circular),
    child: Image.asset(
      imagePath,
      fit: fit,
      width: width,
      height: height,
    ),
  );
}

Widget radiusContainer(Widget child,
    {double? width, double? height, Color? c, double radius = 4.0}) {
  return Container(
      width: width,
      height: height,
      // 边框设置
      decoration: BoxDecoration(
        //背景
        color: c,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        //设置四周边框
        border: Border(),
      ),
      // 设置 child 居中
      alignment: const Alignment(0, 0),
      child: child);
}
