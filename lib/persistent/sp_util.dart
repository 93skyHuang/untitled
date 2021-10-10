import 'package:shared_preferences/shared_preferences.dart';

/**
 * SharePreference 数据存储
 */
class SPUtils {
  static Future<SharedPreferences> _getSpf() async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    return spf;
  }

  static Future<String> getAccount() async {
    return (await _getSpf()).getString('account') ?? '';
  }

  static void saveAccount(String account) async {
    (await _getSpf()).setString('account', account);
  }

  static Future<String> getRegistionID() async {
    return (await _getSpf()).getString('registionID') ?? '';
  }

  ///激光推送id
  static void saveRegistionID(String registionID) async {
    (await _getSpf()).setString('registionID', registionID);
  }

  static Future<int> getUid() async {
    return (await _getSpf()).getInt('uid') ?? -1;
  }

  static void saveUid(int? uid) async {
    uid ??= -1;
    (await _getSpf()).setInt('uid', uid);
  }
}
