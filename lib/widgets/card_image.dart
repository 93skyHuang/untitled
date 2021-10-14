import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/basic/include.dart';

//带圆角的网络图片
Widget cardNetworkImage(String url,double widget,double height, {ShapeBorder? shape}) {
  return Card(
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
