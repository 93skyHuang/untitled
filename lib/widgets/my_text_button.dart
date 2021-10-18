import 'package:untitled/basic/include.dart';

/*复制粘贴使用*/
Widget getTextButton(String s, VoidCallback? onPressed) {
  return TextButton(
    style: ButtonStyle(
      //去除点击效果
        // overlayColor: MaterialStateProperty.all(Colors.transparent),
        minimumSize: MaterialStateProperty.all(const Size(0, 0)),
        visualDensity: VisualDensity.compact,
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        //圆角
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15))),
        //背景
        backgroundColor: MaterialStateProperty.all(Colors.white)),
    onPressed: onPressed,
    child: Text(s,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(12),
          color: MyColor.redFd4343,
        )),
  );
}