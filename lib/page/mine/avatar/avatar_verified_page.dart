import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/utils/image_picker_util.dart';
import 'package:untitled/widget/custom_text.dart';

class AvatarVerifiedPage extends StatefulWidget {
  const AvatarVerifiedPage();

  @override
  State<AvatarVerifiedPage> createState() => _AvatarVerifiedPageState();
}

class _AvatarVerifiedPageState extends State<AvatarVerifiedPage> {
  //本地选择的图片路径
  String? headerImgUrlLocal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
            onPressed: () {
              Navigator.maybePop(context);
            }),
        title:
            Text("头像认证", style: TextStyle(fontSize: 17, color: Colors.black)),
        backgroundColor: Color(0xFFF5F5F5),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showBottomOpen(context);
              },
              child:  Container(
                width: 110,
                height: 110,
                margin: EdgeInsets.only(top: 60),
                child: ClipOval(
                child: headerImgUrlLocal == null
                      ?  Image.asset(
                    'assets/images/user_icon.png',
                  ) : Image.file(
                    File('$headerImgUrlLocal'),
                    fit:
                    Platform.isIOS ? BoxFit.cover : BoxFit.fill,
                  ),
                ),
              ),
            ),
            CustomText(
              textAlign: Alignment.center,
              text: '你的头像',
              textStyle: TextStyle(fontSize: 15, color: Colors.black),
            ),
            CustomText(
              textAlign: Alignment.center,
              text: '上传本人清晰良好形象照，不符合要求将无法通过',
              margin: EdgeInsets.only(top: 10, bottom: 20),
              textStyle: TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
            ),
            if(headerImgUrlLocal==null||headerImgUrlLocal=='')GestureDetector(
              onTap: () {
                showBottomOpen(context);
              },
              child: Container(
                width: 214,
                height: 40,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  border: new Border.all(width: 1, color: Color(0xff8C8C8C)),
                ),
                child: Text('提交认证',
                    style: TextStyle(color: Color(0xff8C8C8C), fontSize: 17)),
              ),
            ),
            if(headerImgUrlLocal!=null&&headerImgUrlLocal!='')GestureDetector(
              onTap: () {
              },
              child: Container(
                width: 214,
                height: 40,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Color(0xffF3CD8E),
                  borderRadius:
                  BorderRadius.all(Radius.circular(40.0)),
                ),
                child: Text('提交认证',
                    style: TextStyle(color: Colors.black, fontSize: 17)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showBottomOpen(BuildContext context) {
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
                    padding:
                        EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
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
                        text: '请上传本人高清正面靓照',
                        margin: EdgeInsets.only(top: 30),
                        textAlign: Alignment.center,
                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      CustomText(
                        text: '五官清晰的照片，会更受欢迎哦～',
                        margin: EdgeInsets.only(top: 7, bottom: 20),
                        textAlign: Alignment.center,
                        textStyle:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: AssetImage('assets/images/avatar_example.png'),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, bottom: 4, top: 2),
                              decoration: new BoxDecoration(
                                color: Color(0xff74D96B),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                              child: Text(
                                "衣着得体",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.only(
                                  left: 13, right: 13, top: 10, bottom: 10),
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, bottom: 4, top: 2),
                              decoration: new BoxDecoration(
                                color: Color(0xffE58CF5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                              child: Text(
                                "光线明亮",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, bottom: 4, top: 2),
                              decoration: new BoxDecoration(
                                color: Color(0xff8CB8F5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                              child: Text(
                                "高清正脸",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                      CustomText(
                        text: '不能通过审核的头像',
                        margin: EdgeInsets.only(bottom: 30),
                        textAlign: Alignment.center,
                        textStyle:
                            TextStyle(fontSize: 12, color: Color(0xff8C8C8C)),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image:
                                    AssetImage('assets/images/avatar_etc1.png'),
                                width: 60,
                                height: 60,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image:
                                    AssetImage('assets/images/avatar_etc2.png'),
                                width: 60,
                                height: 60,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image:
                                    AssetImage('assets/images/avatar_etc3.png'),
                                width: 60,
                                height: 60,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image:
                                    AssetImage('assets/images/avatar_etc4.png'),
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ]),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          XFile? f = await getImageFromGallery();
                          headerImgUrlLocal = f?.path;
                          setState(() {});
                        },
                        child: Container(
                          width: 214,
                          height: 40,
                          margin: EdgeInsets.only(top: 30,bottom: 16),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            color: Color(0xffF3CD8E),
                          ),
                          alignment: Alignment.center,
                          child: Text('从相册选择',
                              style: TextStyle(color: Colors.black, fontSize: 17)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 214,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            border: new Border.all(width: 1, color: Color(0xff8C8C8C)),
                          ),
                          child: Text('取消',
                              style: TextStyle(color: Color(0xff8C8C8C), fontSize: 17)),
                        ),
                      )
                    ]),
                  ),
                ],
              ));
        });
  }
}
