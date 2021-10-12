import 'package:get_storage/get_storage.dart';
import 'package:untitled/network/bean/find_tab_info.dart';

class GetStorageUtils {
  static final _box = GetStorage();

  static Future<String> getRegistionID() async {
    return _box.read('registionID') ?? '';
  }

  ///激光推送id
  static void saveRegistionID(String registionID) async {
    return _box.write('registionID', registionID);
  }

  static Future<int> getUID() async {
    return _box.read('uid') ?? -1;
  }

  ///
  static void saveUid(int? uid) async {
    return _box.write('uid', uid);
  }

  static  Future<List<FindTabInfo>?> getFindTab() async {
    return _box.read('find_tab');
  }

  ///发现页面导航栏
  static void saveFindTab(List<FindTabInfo>? f) async {
    return _box.write('find_tab', f);
  }
}
