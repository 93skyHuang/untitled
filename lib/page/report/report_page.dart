import 'dart:io';

import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/network/http_manager.dart';
import 'package:untitled/utils/image_picker_util.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/loading.dart';
import 'package:untitled/widgets/bottom_pupop.dart';
import 'package:untitled/widgets/toast.dart';

class ReportPage extends StatefulWidget {
  int uid;
  bool isFeedback;

  ReportPage(this.uid,{this.isFeedback=false});

  @override
  State<ReportPage> createState() => _ReportPageState(uid,isFeedback);
}

class _ReportPageState extends State<ReportPage> {
  bool isFeedback;
  int uid;
  _ReportPageState(this.uid,this.isFeedback);
  final TextEditingController _controllerInfo = TextEditingController();

  List<String> imageUrls = [];

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
              Text(isFeedback?"意见反馈":"举报用户", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                if(isFeedback){
                  addFeed();
                }else{
                  addReport();
                }},
              child: Container(
                  alignment: Alignment.center,
                  child: Container(
                      height: 27,
                      width: 60,
                      margin: EdgeInsets.only(right: 16),
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Color(0xffF3CD8E),
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Text(
                        "提交",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ))),
            ),
          ]),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _textFieldInfo(),
              SizedBox(
                height: 10,
              ),
              _photoAndVideoGridView(),
              GestureDetector(
                onTap: () {
                  if (imageUrls.length == 3) {
                    MyToast.show('一次最多只能提交3张图片');
                    return;
                  }
                  showBottomImageSource(context, _choicePicture, _tokePhoto);
                },
                child: Container(
                  height: 120,
                  width: 120,
                  margin: EdgeInsets.only(right: 16),
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: Color(0xffE6E6E6),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 38,
                    color: Color(0xFF8C8C8C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldInfo() {
    return TextField(
      maxLines: 5,
      //最多多少行
      minLines: 5,
      //最多多少行
      style: TextStyle(
        fontSize: ScreenUtil().setSp(15),
        color: MyColor.blackColor,
      ),
      decoration: InputDecoration(
        filled: false,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0)),
        counterText: '',
        //此处控制最大字符是否显示
        alignLabelWithHint: true,
        hintText: isFeedback?'请填写反馈理由和上传截图':'请填写举报理由和上传截图',
        hintStyle: TextStyle(
          fontSize: ScreenUtil().setSp(15),
          color: MyColor.grey8C8C8C,
        ),
      ),
      controller: _controllerInfo,
    );
  }

  Widget _pictureItem(String url) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8, top: 8),
          child: Image.file(
            File(url),
            fit: Platform.isIOS ? BoxFit.cover : BoxFit.fill,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: () {
                imageUrls.remove(url);
                setState(() {});
              },
              child: Container(
                child: Icon(Icons.remove_circle, size: 16, color: Colors.red),
              )),
        )
      ],
    );
  }

  Widget _photoAndVideoGridView() {
    return GridView.count(
      shrinkWrap: true,
      //为true可以解决子控件必须设置高度的问题
      physics: NeverScrollableScrollPhysics(),
      //禁用滑动事件
      //GridView内边距
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      crossAxisSpacing: ScreenUtil().setWidth(10),
      //垂直子Widget之间间距
      mainAxisSpacing: ScreenUtil().setWidth(4),
      //一行的Widget数量
      crossAxisCount: 4,
      //子Widget宽高比例
      childAspectRatio: 1,
      children: _listView(),
    );
  }

  List<Widget> _listView() {
    List<Widget> list = [];
    //picture
    int length = imageUrls.length;
    for (int i = 0; i < length; i++) {
      list.add(_pictureItem(imageUrls[i]));
    }
    return list;
  }

  void _choicePicture() async {
    XFile? f = await getImageFromGallery();
    if (f != null) {
      imageUrls.add(f.path);
      setState(() {});
    }
  }

  //拍照
  void _tokePhoto() async {
    XFile? f = await getPhoto();
    if (f != null) {
      imageUrls.add(f.path);
      setState(() {});
    }
  }
 void addReport() async {
   Loading.show(context);
    addAccusation(uid,_controllerInfo.text,imageUrls)
        .then((value) => {
      Loading.dismiss(context),
      if (value.isOk())
        {
          MyToast.show('提交成功'),
          Get.back()
        }
    });
  }
  void addFeed() async {
    Loading.show(context);
    addFeedback(_controllerInfo.text,imageUrls)
        .then((value) => {
      Loading.dismiss(context),
      if (value.isOk())
        {
          MyToast.show('提交成功'),
          Get.back()
        }
    });
  }
}
