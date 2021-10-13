import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/basic/common_config.dart';

///垂直分割线
class VDivider extends StatelessWidget {
  EdgeInsetsGeometry? padding;
  double? width;
  double? height;

  VDivider({Key? key, this.padding, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.only(
              left: ScreenUtil().setWidth(6), right: ScreenUtil().setWidth(6)),
      child: SizedBox(
        width: width ?? ScreenUtil().setWidth(1),
        height: height ?? ScreenUtil().setHeight(12),
        child: const DecoratedBox(
          decoration: BoxDecoration(color: MyColor.dividerColor),
        ),
      ),
    );
  }
}
