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

  static Future<String> getUid() async {
    return (await _getSpf()).getString('uid') ?? '';
  }

  static void saveUid(String uid) async {
    (await _getSpf()).setString('uid', uid);
  }

}
