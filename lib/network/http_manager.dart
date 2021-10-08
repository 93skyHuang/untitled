import 'package:dio/dio.dart';
import 'package:untitled/constant/error_code.dart';
import 'package:untitled/network/bean/address.dart';
import 'package:untitled/network/bean/base_page_data.dart';
import 'package:untitled/network/bean/base_resp.dart';
import 'package:untitled/network/bean/chat_user_info.dart';
import 'package:untitled/network/bean/holder_data.dart';
import 'package:untitled/network/bean/login_resp.dart';
import 'package:untitled/network/bean/visitor_info.dart';
import 'package:untitled/persistent/sp_util.dart';
import 'bean/user_info.dart';
import 'dio_util.dart';
import 'logger.dart';

/// 发送短信
Future<BasePageData> getPhoneSms(String phone) async {
  BasePageData basePageData;
  try {
    Response response = await getDio()
        .post('/index/Login/sendLoginSms', data: {'phone': phone});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    return basePageData;
  } on DioError catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 自动登录
Future<BasePageData<LoginResp?>> autoLogin(
    String uid, String longitude, String latitude, String registionID) async {
  BasePageData<LoginResp?> basePageData;
  try {
    Response response = await getDio().post('/index/Login/defaultLogin', data: {
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

/// 手动登录或注册
Future<BasePageData<LoginResp?>> phoneLogin(String phone, String code) async {
  BasePageData<LoginResp?> basePageData;
  try {
    Response response = await getDio()
        .post('/index/Login/phoneLogin', data: {'phone': phone, 'code': code});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    logger.i(baseResp);
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

/// 获取用户信息
Future<BasePageData<UserInfo?>> getUserInfo() async {
  BasePageData<UserInfo?> basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response =
        await getDio().post('/index/User/getUserInfo', data: {'uid': uid});
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

/// 检测APP版本
Future<BasePageData<UserInfo?>> checkAppVersion(
    String versionCode, String versionName) async {
  BasePageData<UserInfo?> basePageData;
  try {
    Response response = await getDio().post('/index/share/newVersionUpdate',
        data: {'versionCode': versionCode, 'versionName': versionName});
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

/// 获取地址
Future<BasePageData<Address?>> getAddress(
    String longitude, String latitude) async {
  BasePageData<Address?> basePageData;
  try {
    Response response = await getDio().post('/index/share/GetAddress',
        data: {'longitude': longitude, 'latitude': latitude});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, Address.fromJson(baseResp.data));
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

/// 获取用户月卡到期时间
Future<BasePageData<HolderData?>> getPayTime() async {
  BasePageData<HolderData?> basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response =
        await getDio().post('/index/share/getPayTime', data: {'uid': uid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, HolderData.fromJson(baseResp.data));
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

/// 获取访客 应该是个列表，可能数据格式还需要修改
Future<BasePageData<VisitorInfo?>> getVisitor(int pageNum) async {
  BasePageData<VisitorInfo?> basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response = await getDio()
        .post('/index/share/getVisitor', data: {'uid': uid, 'page': pageNum});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, VisitorInfo.fromJson(baseResp.data));
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

/// 添加关注
/// userid 对方用户id
Future<BasePageData> addFollow(int userid) async {
  BasePageData basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response = await getDio()
        .post('/index/share/addFollow', data: {'uid': uid, 'userid': userid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
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

/// 取消关注
/// userid 对方用户id
Future<BasePageData> delFollow(int userid) async {
  BasePageData basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response = await getDio()
        .post('/index/share/delFollow', data: {'uid': uid, 'userid': userid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
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

/// 举报
/// userid 对方用户id
Future<BasePageData> addAccusation(int userid,String content) async {
  BasePageData basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response = await getDio()
        .post('/index/share/addAccusation', data: {'uid': uid, 'userid': userid, 'content': content});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
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

/// 申请注销账号
Future<BasePageData> addDeleteAccountApplication() async {
  BasePageData basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response = await getDio()
        .post('/index/share/addDeleteAccountApplication', data: {'uid': uid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
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

/// 拉黑
Future<BasePageData> addPullBlack(int userid) async {
  BasePageData basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response = await getDio()
        .post('/index/share/addPullBlack', data: {'uid': uid,'userid': userid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
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

/// 取消拉黑
Future<BasePageData> delPullBlack(int userid) async {
  BasePageData basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response = await getDio()
        .post('/index/share/delPullBlack', data: {'uid': uid,'userid': userid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
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


/// 获取聊天页面对方用户信息
/// userid 对方用户id
Future<BasePageData<ChatUserInfo?>> getChatPageUserInfo(int userid) async {
  BasePageData<ChatUserInfo?> basePageData;
  try {
    int uid = await SPUtils.getUid();
    Response response = await getDio()
        .post('/index/share/chatPageUserInfo', data: {'uid': uid, 'userid': userid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, ChatUserInfo.fromJson(baseResp.data));
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