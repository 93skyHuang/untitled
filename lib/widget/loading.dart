import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  static void show(BuildContext context, {bool isAutoDismiss = true}) {
    if (isAutoDismiss) {
      Future.delayed(Duration(seconds: 10)).then((value) => {
            dismiss(context),
          });
    }
    showDialog(
      context: context,
      barrierDismissible: false, //点击外部遮罩区域是否可以关闭dialog
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, //关键代码
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Loading(),
          ),
        );
      },
    );
  }

  static void dismiss(context) {
    if (context != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
