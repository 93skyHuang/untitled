import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/network/bean/user_basic.dart';
import 'package:untitled/page/global_controller.dart';

class GetStorageUtils {
  ///开启app马上需要初始化的数据
  static final _firstInitStorage = GetStorage('firstInitStorage');

  static final _commonStorage = GetStorage();

  static String getRegistionID() {
    return _firstInitStorage.read('registionID') ?? '';
  }

  ///激光推送id
  static Future<void> saveRegistionID(String registionID) {
    return _firstInitStorage.write('registionID', registionID);
  }

  static String getNimToken() {
    return _firstInitStorage.read('nimToken') ?? '';
  }

  ///云信im token
  static Future<void> saveNimToken(String nimToken) {
    return _firstInitStorage.write('nimToken', nimToken);
  }

  static String getDeviceId() {
    return _firstInitStorage.read('deviceId') ?? '';
  }

  ///云信im token
  static Future<void> saveDeviceId(String deviceId) {
    return _firstInitStorage.write('deviceId', deviceId);
  }

  static int getUID() {
    return _firstInitStorage.read('uid') ?? -1;
  }

  ///
  static Future<void> saveUid(int? uid) {
    logger.i('saveUid $uid');
    return _firstInitStorage.write('uid', uid);
  }

  static int getSex() {
    return _firstInitStorage.read('sex') ?? 1;
  }

  ///
  static void saveSex(int sex) {
    _firstInitStorage.write('sex', sex);
  }

  static bool getSvip() {
    return _firstInitStorage.read('svip') ?? false;
  }

  ///
  static void saveSvip(bool svip) {
    _firstInitStorage.write('svip', svip);
    try {
      final GlobalController _globalController = Get.find<GlobalController>();
      _globalController.isSvip.value = svip;
    } catch (e) {
      logger.e(e);
    }
  }

  static bool getIsShowVerifiedTipsInHomePage() {
    return _firstInitStorage.read('isShowVerifiedTips') ?? false;
  }

  ///
  static void saveIsShowVerifiedTipsInHomePage(bool isShowVerifiedTips) {
    _firstInitStorage.write('isShowVerifiedTips', isShowVerifiedTips);
  }

  static bool getIsHead() {
    return _firstInitStorage.read('isHead') ?? false;
  }

  ///
  static void saveIsHead(bool isHead) {
    _firstInitStorage.write('isHead', isHead);
  }

  static bool getIsVideo() {
    return _firstInitStorage.read('isVideo') ?? false;
  }

  ///
  static void saveIsVideo(bool isVideo) {
    _firstInitStorage.write('isVideo', isVideo);
  }

  static Position? getLocation() {
    _firstInitStorage.read('position');
  }

  static void saveLocation(Position position) {
    _firstInitStorage.write('position', position);
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
    final userBasicMap = getUserBasic(getUID());
    logger.i(userBasicMap);
    return userBasicMap;
  }
}
