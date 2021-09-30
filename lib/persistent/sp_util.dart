import 'dart:convert';

class SharedPreferencesData {

  static Future<String> getAccount() async {
    return "ttt";
  }

  // ///匿名分析
  // static Future<bool> getAnalysisEnable() async {
  //   return (await getSpf()).getBool(CommonKey.kAnalysisEnable) ?? true;
  // }
  //
  // ///匿名分析
  // static saveAnalysisEnable(bool enable) async {
  //   (await getSpf()).setBool(CommonKey.kAnalysisEnable, enable);
  // }
  //
  // ///日志报告
  // static getLogReportEnable() async {
  //   return (await getSpf()).getBool(CommonKey.kLogReportEnable) ?? true;
  // }
  //
  // ///日志报告
  // static saveLogReportEnable(bool enable) async {
  //   (await getSpf()).setBool(CommonKey.kLogReportEnable, enable);
  // }
  //
  // static Future<SharedPreferences> getSpf() async {
  //   SharedPreferences spf = await SharedPreferences.getInstance();
  //   return spf;
  // }
  //
  // ///上一次管理的设备
  // static Future getLastDevice() async {
  //   SharedPreferences spf = await SharedPreferences.getInstance();
  //   var lastDeviceString = spf.get(CommonKey.KLastDevice);
  //   if (lastDeviceString != null && lastDeviceString != "null" && lastDeviceString != "") {
  //     return LastDevice.fromJson(json.decode(spf.get(CommonKey.KLastDevice)));
  //   } else {
  //     return LastDevice('','','');
  //   }
  // }
  //
  // ///上一次管理的设备
  // static Future<bool> setLastDevice(LastDevice lastDevice) async {
  //   SharedPreferences spf = await SharedPreferences.getInstance();
  //   return spf.setString(CommonKey.KLastDevice, json.encode(lastDevice));
  // }
  //
  //
  // static Future getManagedDevicesSN() async {
  //   SharedPreferences spf = await SharedPreferences.getInstance();
  //   List<String> lastDeviceNum;
  //   if(spf.get(CommonKey.KManagedDevice) == null){
  //     lastDeviceNum = List();
  //   } else {
  //     lastDeviceNum = spf.getStringList(CommonKey.KManagedDevice);
  //   }
  //   return lastDeviceNum;
  // }
  //
  // static Future<bool> setManagedDevicesSN(List<String> list) async {
  //   SharedPreferences spf = await SharedPreferences.getInstance();
  //   return spf.setStringList(CommonKey.KManagedDevice, list);
  // }
  // ///获取隐私政策状态
  // static Future<bool> getPrivateStatus() async {
  //   return (await getSpf()).getBool(CommonKey.kPrintStatus) ?? false;
  // }
  //
  // ///设置隐私政策状态
  // static setPrivateStatus(bool enable) async {
  //   (await getSpf()).setBool(CommonKey.kPrintStatus, enable);
  // }
}
