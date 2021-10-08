import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/basic/common_config.dart';
import 'package:untitled/basic/include.dart';

//通用输入框，by 黄谣
class CommonInputState extends StatefulWidget {
  TextEditingController inputController; //输入框控制器
  String hintText = ''; //提示文字
  String img = ''; //左边图标，不设置即不显示
  EdgeInsetsGeometry? margin; //控件的margin属性 外边距
  double? height; //输入框高度
  double? width; //输入框宽度
  TextStyle? textStyle; //输入框字体样式
  TextStyle? hintTextStyle; //提示文字样式
  int maxLength = 32; //输入最大长度
  Color background = Colors.transparent; //背景颜色
  bool autoFocus = false; //是否自动聚焦
  TextInputType textInputType; //键盘类型
  TextAlign textAlign; //对齐方式
  bool enable; //对齐方式
  List<TextInputFormatter>? listTextInputFormatter;

  CommonInputState(
      {required this.inputController,
      this.hintText = '',
      Key? key,
      this.textStyle,
      this.margin,
      this.height,
      this.width,
      this.hintTextStyle, //提示文字样式,
      this.img = '',
      this.maxLength = 32,
      this.background = Colors.transparent,
      this.autoFocus = false,
      this.textInputType = TextInputType.text,
      this.enable = true,
      this.textAlign = TextAlign.left,
      this.listTextInputFormatter})
      : super(key: key);

  @override
  _CommonInputState createState() => _CommonInputState();
}

class _CommonInputState extends State<CommonInputState> {
  bool showRight = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // TextField has lost focus
        showRight = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      color: widget.background,
      child: Row(
        children: <Widget>[
          if (widget.img != "")
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Image(image: AssetImage(widget.img), width: 20.0),
            ),
          Expanded(
            child: TextField(
              enabled: widget.enable,
              controller: widget.inputController,
              style: widget.textStyle,
              maxLines: 1,
              autofocus: widget.autoFocus,
              focusNode: _focusNode,
              maxLength: widget.maxLength,
              maxLengthEnforced: true,
              onChanged: (value) {
                showRight = value.length > 0;
                setState(() {});
              },
              inputFormatters: widget.listTextInputFormatter,
              keyboardType: widget.textInputType,
              textAlign: widget.textAlign,
              onTap: () {
                showRight = widget.inputController.text.isNotEmpty;
                setState(() {});
              },
              decoration: InputDecoration(
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                counterText: "",
                //此处控制最大字符是否显示
                alignLabelWithHint: true,
                hintText: widget.hintText,
                hintStyle: widget.hintTextStyle ??
                    const TextStyle(
                      fontSize: 15.0,
                      color: MyColor.HintTextColor,
                    ),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                suffix: GestureDetector(
                  onTap: () {
                    widget.inputController.clear();
                    showRight = false;
                    setState(() {});
                  },
                  ///暂时没有图片
                  child: showRight
                      ? Image(
                          image: AssetImage(
                              "assets/images/common_input_delete.png"),
                          width: 20.0)
                      : Container(
                          width: 1,
                          height: 20.0,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
