import 'package:get_storage/get_storage.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/find_tab_info.dart';

class GetStorageUtils {

  //
  static final _accountStorage = GetStorage('AccountStorage');

  static final _otherStorage = GetStorage('OtherStorage');

  static String getRegistionID() {
    return _accountStorage.read('registionID') ?? '';
  }

  ///激光推送id
  static Future<void> saveRegistionID(String registionID) {
    return _accountStorage.write('registionID', registionID);
  }

  static String getNimToken() {
    return _accountStorage.read('nimToken') ?? '';
  }

  ///云信im token
  static Future<void> saveNimToken(String nimToken) {
    return _accountStorage.write('nimToken', nimToken);
  }

  static int getUID() {
    return _accountStorage.read('uid') ?? -1;
  }

  ///
  static Future<void> saveUid(int? uid) {
    logger.i('saveUid $uid');
    return _accountStorage.write('uid', uid);
  }

  static List<FindTabInfo>? getFindTab() {
    List<dynamic>? list = _accountStorage.read('find_tab');
    List<FindTabInfo>? infoList =
        list?.map((e) => FindTabInfo.fromJson(e)).toList();
    return infoList;
  }

  ///发现页面导航栏
  static void saveFindTab(List<FindTabInfo>? f) {
    _accountStorage.write('find_tab', f);
  }

  static int getSex() {
    return _accountStorage.read('sex') ?? 1;
  }

  ///
  static void saveSex(int sex) {
    _accountStorage.write('sex', sex);
  }
}
