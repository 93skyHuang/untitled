import 'package:flutter/material.dart';
import 'package:untitled/widget/custom_text.dart';

void showBottomImageSource(BuildContext context, VoidCallback? action1,
    VoidCallback? action2,{String title="选择照片来源",String action1Str="拍照",String action2Str="从相册中选择",}) {
  showModalBottomSheet(
      enableDrag: false,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            alignment: Alignment.bottomCenter,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 20.0, top: 16),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      child: Column(children: <Widget>[
                        CustomText(
                            text: title,
                            textAlign: Alignment.center,
                            padding: EdgeInsets.only(bottom: 16),
                            textStyle:
                                TextStyle(fontSize: 17, color: Colors.black)),
                        Divider(
                          height: 1,
                          color: Color(0xffE6E6E6),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              action2?.call();
                            },
                            child: CustomText(
                                text: action1Str,
                                textAlign: Alignment.center,
                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                textStyle: TextStyle(
                                    fontSize: 17, color: Colors.black))),
                        Divider(
                          height: 1,
                          color: Color(0xffE6E6E6),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              action1?.call();
                            },
                            child: CustomText(
                                text: action2Str,
                                textAlign: Alignment.center,
                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                textStyle: TextStyle(
                                    fontSize: 17, color: Colors.black))),
                        Divider(
                          height: 1,
                          color: Color(0xffE6E6E6),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: CustomText(
                                text: "取消",
                                textAlign: Alignment.center,
                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                textStyle: TextStyle(
                                    fontSize: 17, color: Color(0xffFD4343)))),
                      ]))
                ]));
      });
}

/**
 * 取消关注弹窗
 */
void showBottomCancelFocus(BuildContext context,VoidCallback? action) {
  showModalBottomSheet(
      enableDrag: false,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            alignment: Alignment.bottomCenter,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                  ),
                  Container(
                      padding: EdgeInsets.only(bottom: 20.0, top: 16),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      child: Column(children: <Widget>[
                        CustomText(
                            text: "操作",
                            textAlign: Alignment.center,
                            padding: EdgeInsets.only(bottom: 16),
                            textStyle:
                            TextStyle(fontSize: 17, color: Colors.black)),
                        Divider(
                          height: 1,
                          color: Color(0xffE6E6E6),
                        ),
                        TextButton(
                            onPressed: () {
                              action?.call();
                              Navigator.pop(context);
                            },
                            child: CustomText(
                                text: "取消关注",
                                textAlign: Alignment.center,
                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                textStyle: TextStyle(
                                    fontSize: 17, color: Colors.black))),
                        Divider(
                          height: 1,
                          color: Color(0xffE6E6E6),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: CustomText(
                                text: "取消",
                                textAlign: Alignment.center,
                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                textStyle: TextStyle(
                                    fontSize: 17, color: Color(0xffFD4343)))),
                      ]))
                ]));
      });
}