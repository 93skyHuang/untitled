import 'package:dio/dio.dart';
import 'package:untitled/constant/error_code.dart';
import 'package:untitled/network/bean/base_page_data.dart';
import 'package:untitled/network/bean/base_resp.dart';
import 'package:untitled/network/bean/login_resp.dart';
import 'bean/user_info.dart';
import 'dio_util.dart';
import 'logger.dart';

/**
 * 发送短信
 */
Future<BasePageData> getPhoneSms(String phone) async {
  BasePageData basePageData;
  try {
    Response response =
        await getDio().post('index/Login/sendLoginSms', data: {'phone': phone});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    return basePageData;
  } on DioError catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/**
 * 自动登录
 */
Future<BasePageData<LoginResp?>> autoLogin(
    String uid, String longitude, String latitude, String registionID) async {
  BasePageData<LoginResp?> basePageData;
  try {
    Response response = await getDio().post('index/Login/defaultLogin', data: {
      'uid': uid,
      'longitude': longitude,
      'latitude': latitude,
      'registionID': registionID,
      'packageName': 'packageName',
    });
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, LoginResp.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    return basePageData;
  } on DioError catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/**
 * 手动登录或注册
 */
Future<BasePageData<LoginResp?>> phoneLogin(String phone, String code) async {
  BasePageData<LoginResp?> basePageData;
  try {
    Response response = await getDio()
        .post('index/Login/phoneLogin', data: {'phone': phone, 'code': code});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, LoginResp.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    return basePageData;
  } on DioError catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/**
 * 获取用户信息
 */
Future<BasePageData<UserInfo?>> getUserInfo() async {
  BasePageData<UserInfo?> basePageData;
  try {
    Response response =
        await getDio().post('/index/User/getUserInfo', data: {'uid': 105324});
    logger.i('-----${response.data['data']['uid']}');
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, UserInfo.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    return basePageData;
  } on DioError catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/**
 * 检测APP版本
 */
Future<BasePageData<UserInfo?>> checkAppVersion(
    String versionCode, String versionName) async {
  BasePageData<UserInfo?> basePageData;
  try {
    Response response = await getDio().post('index/share/newVersionUpdate',
        data: {'versionCode': versionCode, 'versionName': versionName});
    logger.i('-----${response.data['data']['uid']}');
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, UserInfo.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    return basePageData;
  } on DioError catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}
