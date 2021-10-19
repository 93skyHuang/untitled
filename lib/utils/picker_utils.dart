import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:untitled/basic/include.dart';

typedef _SingleClickCallBack = void Function(
    int selectedIndex, dynamic selectedData);
typedef _DateClickCallBack = void Function(
    String selectDateStr, DateTime selectDataTime);

void showSexPicker(BuildContext context,
    {required _SingleClickCallBack clickCallBack,int choice=1}) {
  List<String> sex = [
    '女',
    '男',
  ];
  showStringPicker<String>(context,
      data: sex, choice: sex[--choice], clickCallBack: clickCallBack);
}

void showEducationPicker(BuildContext context,
    {required _SingleClickCallBack clickCallBack,String choice='本科'}) {
  List<String> education = [
    '博士',
    '硕士',
    '本科',
    '专科',
    '其它',
  ];
  showStringPicker<String>(context,
      data: education, choice: choice.isEmpty?'本科':choice, clickCallBack: clickCallBack);
}

void showMonthlyIncomePicker(BuildContext context,
    {required _SingleClickCallBack clickCallBack}) {
  List<String> income = [
    '4000以下',
    '6000',
    '8000',
    '10000',
    '20000',
    '50000',
    '100000以上',
  ];
  showStringPicker<String>(context,
      data: income, choice: '8000', clickCallBack: clickCallBack);
}

final List<int> _heights = [];

void showHeightPicker(BuildContext context,
    {int choice = 170, required _SingleClickCallBack clickCallBack}) {
  if (_heights.isEmpty) {
    for (int i = 50; i < 220; i++) {
      _heights.add(i);
    }
  }
  showStringPicker<int>(context,
      data: _heights, choice: choice, clickCallBack: clickCallBack);
}

// //单列
void showStringPicker<T>(
  BuildContext context, {
  required List<T> data,
  required T choice,
  String title = '',
  PickerDataAdapter? adapter,
  required _SingleClickCallBack clickCallBack,
}) {
  openModalPicker(context,
      adapter: adapter ?? PickerDataAdapter(pickerdata: data, isArray: false),
      clickCallBack: (Picker picker, List<int> selecteds) {
    clickCallBack(selecteds[0], data[selecteds[0]]);
  }, selecteds: [data.indexOf(choice)], title: title);
}

//
// //多列
// static void showArrayPicker<T>(
//     BuildContext context,{
//       @required List<T> data,
//       String title,
//       List<int> normalIndex,
//       PickerDataAdapter adapter,
//       @required _ArrayClickCallBack clickCallBack,
//     }) {
//   openModalPicker(context, adapter: adapter??PickerDataAdapter(
//       pickerdata: data,isArray: true
//   ), clickCallBack: (Picker picker,List<int> selecteds) {
//     clickCallBack(selecteds,picker.getSelectedValues());
//   },selecteds: normalIndex,title: title);
//
//
// }
//
void openModalPicker(
  BuildContext context, {
  required PickerAdapter adapter,
  String? title,
  List<int>? selecteds,
  required PickerConfirmCallback clickCallBack,
}) {
  Picker(
          adapter: adapter,
          title: new Text(
            title ?? "请选择",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          selecteds: selecteds,
          cancelText: '取消',
          confirmText: "确定",
          cancelTextStyle: TextStyle(color: Colors.grey, fontSize: 16),
          confirmTextStyle: TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.right,
          itemExtent: 50,
          height: 300,
          selectedTextStyle: TextStyle(color: Colors.black),
          onConfirm: clickCallBack)
      .showModal(context);
}

//日期选择器
void showMyDataPicker(
  BuildContext context, {
  String title = '',
  DateTime? value,
  DateTimePickerAdapter? adapter,
  required _DateClickCallBack clickCallBack,
}) {
  openModalPicker(context,
      adapter: adapter ??
          DateTimePickerAdapter(
            type: PickerDateTimeType.kYMD,
            isNumberMonth: true,
            yearSuffix: "年",
            monthSuffix: "月",
            daySuffix: "日",
            maxValue: DateTime.now(),
            minValue: DateTime(1980),
            value: value ?? DateTime.now(),
          ),
      title: title, clickCallBack: (Picker picker, List<int> selecteds) {
    var time = (picker.adapter as DateTimePickerAdapter).value;
    String timeStr =
        '${time?.year.toString()}-${time?.month.toString()}-${time?.day.toString()}';
    clickCallBack(timeStr, time ?? DateTime.now());
  });
}
