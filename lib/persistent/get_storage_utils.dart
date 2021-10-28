import 'package:get_storage/get_storage.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/find_tab_info.dart';
import 'package:untitled/network/bean/user_basic.dart';

class GetStorageUtils {
  //
  static final _accountStorage = GetStorage('AccountStorage');

  static final _commonStorage = GetStorage();

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

  static int getSex() {
    return _accountStorage.read('sex') ?? 1;
  }

  ///
  static void saveSex(int sex) {
    _accountStorage.write('sex', sex);
  }

  static bool getSvip() {
    return _accountStorage.read('svip') ?? false;
  }

  ///
  static void saveSvip(bool svip) {
    _accountStorage.write('svip', svip);
  }

  static bool getIsHead() {
    return _accountStorage.read('isHead') ?? false;
  }

  ///
  static void saveIsHead(bool isHead) {
    _accountStorage.write('isHead', isHead);
  }

  static bool getIsVideo() {
    return _accountStorage.read('isVideo') ?? false;
  }

  ///
  static void saveIsVideo(bool isVideo) {
    _accountStorage.write('isVideo', isVideo);
  }

  static List<FindTabInfo> getFindTab() {
    List<dynamic>? list = _commonStorage.read('find_tab');
    List<FindTabInfo>? infoList =
        list?.map((e) => FindTabInfo.fromJson(e)).toList();
    return infoList ?? [];
  }

  ///发现页面导航栏
  static void saveFindTab(List<FindTabInfo>? f) {
    _commonStorage.write('find_tab', f);
  }

  ///保存某个人的基本信息数据
  static void saveUserBasic(UserBasic userBasic) {
    _commonStorage.write('${userBasic.uid}', userBasic);
  }

  ///获取某个人的基本信息数据
  static UserBasic? getUserBasic(int uid) {
    final userBasicMap = _commonStorage.read('$uid');
    try {
      logger.i(userBasicMap);
      return userBasicMap;
    } catch (e) {
      logger.e(e);
      return userBasicMap == null ? null : UserBasic.fromJson(userBasicMap);
    }
  }

  static UserBasic? getMineUserBasic() {
    final userBasicMap = _commonStorage.read('${getUID()}');
    logger.i(userBasicMap);
    return userBasicMap;
  }
}
