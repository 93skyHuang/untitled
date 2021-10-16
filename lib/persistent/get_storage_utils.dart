import 'package:get_storage/get_storage.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/find_tab_info.dart';

class GetStorageUtils {
  static final _box = GetStorage();

  static String getRegistionID() {
    return _box.read('registionID') ?? '';
  }

  ///激光推送id
  static Future<void> saveRegistionID(String registionID) {
    return _box.write('registionID', registionID);
  }

  static String getNimToken() {
    return _box.read('nimToken') ?? '';
  }

  ///云信im token
  static Future<void> saveNimToken(String nimToken) {
    return _box.write('nimToken', nimToken);
  }

  static int getUID() {
    return _box.read('uid') ?? -1;
  }

  ///
  static Future<void> saveUid(int? uid) {
    logger.i('saveUid $uid');
    return _box.write('uid', uid);
  }

  static List<FindTabInfo>? getFindTab() {
    List<dynamic>? list = _box.read('find_tab');
    List<FindTabInfo>? infoList =
        list?.map((e) => FindTabInfo.fromJson(e)).toList();
    return infoList;
  }

  ///发现页面导航栏
  static void saveFindTab(List<FindTabInfo>? f) {
    _box.write('find_tab', f);
  }

  static int getSex() {
    return _box.read('sex') ?? 1;
  }

  ///
  static void saveSex(int sex) {
    _box.write('sex', sex);
  }
}
