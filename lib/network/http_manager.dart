import 'dart:io';

import 'package:dio/dio.dart';
import 'package:untitled/basic/include.dart';
import 'package:untitled/constant/error_code.dart';
import 'package:untitled/network/bean/address.dart';
import 'package:untitled/network/bean/base_page_data.dart';
import 'package:untitled/network/bean/base_resp.dart';
import 'package:untitled/network/bean/chat_user_info.dart';
import 'package:untitled/network/bean/discover_info.dart';
import 'package:untitled/network/bean/login_resp.dart';
import 'package:untitled/network/bean/my_foot_info.dart';
import 'package:untitled/network/bean/nearby_info.dart';
import 'package:untitled/network/bean/new_trends_info.dart';
import 'package:untitled/network/bean/visitor_info.dart';
import 'package:untitled/nim/nim_network_manager.dart';
import 'package:untitled/persistent/get_storage_utils.dart';
import 'package:untitled/widgets/toast.dart';
import 'bean/add_comment_resp.dart';
import 'bean/app_version_info.dart';
import 'bean/black_info.dart';
import 'bean/comment_info.dart';
import 'bean/cover_follow_info.dart';
import 'bean/find_tab_info.dart';
import 'bean/follow_info.dart';
import 'bean/pay_time.dart';
import 'bean/receive_comment_msg.dart';
import 'bean/receive_fabulous_msg.dart';
import 'bean/send_comment_msg.dart';
import 'bean/send_fabulous_msg.dart';
import 'bean/trends_details.dart';
import 'bean/trends_like_info.dart';
import 'bean/trends_tpoic_type_info.dart';
import 'bean/order.dart';
import 'bean/pay_list.dart';
import 'bean/user_basic.dart';
import 'bean/user_info.dart';
import 'bean/video_trends_info.dart';
import 'dio_util.dart';
import 'logger.dart';

/// 发送短信 接口测试通过
Future<BasePageData> getPhoneSms(String phone) async {
  BasePageData basePageData;
  try {
    Response response = await getDio()
        .post('/index/Login/sendLoginSms', data: {'phone': phone});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 自动登录  接口测试通过
Future<BasePageData<LoginResp?>> autoLogin() async {
  BasePageData<LoginResp?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/Login/defaultLogin', data: {
      'uid': uid,
      'longitude': 0.0,
      'latitude': 0.0,
      'registionID': 'registionID',
      'packageName': 'packageName',
    });
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, LoginResp.fromJson(baseResp.data));
      //执行云信登录
      String token = basePageData.data?.loginToken ?? "";
      GetStorageUtils.saveNimToken(token);
      GetStorageUtils.saveSex(basePageData.data?.sex ?? 1);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 手动登录或注册 接口测试通过
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
      //保存相关信息
      String token = basePageData.data?.loginToken ?? "";
      int uid = basePageData.data?.uid ?? -1;
      GetStorageUtils.saveUid(uid);
      GetStorageUtils.saveNimToken(token);
      GetStorageUtils.saveSex(basePageData.data?.sex ?? 1);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 获取兴趣爱好
Future<BasePageData<List<String>?>> getHobby() async {
  BasePageData<List<String>?> basePageData;
  try {
    Response response = await getDio().post('/index/User/getHobby');
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<String> s =
          (baseResp.data as List<dynamic>).map((e) => e.toString()).toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, s);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 获取用户信息 接口测试通过
Future<BasePageData<UserInfo?>> getUserInfo() async {
  BasePageData<UserInfo?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response =
        await getDio().post('/index/User/getUserInfo', data: {'uid': uid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, UserInfo.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i('$basePageData');
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 保存编辑个人信息
// * uid [用户uid]
// * phone [用户手机号码]
// * 非必要条件字段
// * headImgUrl [用户头像]
// * cname [用户昵称]
// * birthday [生日][格式 1999-09-09]
// * height [身高]
// * monthlyIncome [收入]
// * 地址这里 1、region [区域]（这里需要提示对方开启定位，如果没有开启定位就将原来的值给我或者为空或0）
// *         2、如果用户已经获取了定位，就传longitude 和 latitude，注意不要传region
// * autograph [签名]
Future<BasePageData> updateUserInfo({
  String? headImgUrl,
  String? cname,
  String? birthday,
  int? height,
  int? sex,
  String? autograph,
  String? region,
  String? province,
  String? monthlyIncome,
  String? education,
  double? longitude,
  double? latitude,
}) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Map<String, dynamic> data;
    if (longitude != null && latitude != null) {
      data = {
        'uid': uid,
        'sex': sex,
        'birthday': birthday,
        'height': height,
        'headImgUrl': headImgUrl,
        'autograph': autograph,
        'monthlyIncome': monthlyIncome,
        'education': education,
        'longitude': longitude,
        'latitude': latitude
      };
    } else {
      data = {
        'uid': uid,
        'sex': sex,
        'birthday': birthday,
        'height': height,
        'headImgUrl': headImgUrl,
        'autograph': autograph,
        'region': region,
        'province': province,
        'monthlyIncome': monthlyIncome,
        'education': education,
      };
    }
    Response response =
        await getDio().post('/index/User/updateUserInfo', data: data);
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  MyToast.show(basePageData.msg);
  return basePageData;
}

///保存/择偶要求和兴趣爱好
///          * uid [用户uid]
//      * 非必要条件字段
//      * expectAge [交友年龄]
//      * expectRegion [期望对象城市]
//      * expectHeight [期望对象身高]
//      * expectConstellation [期望对象星座]
//      * expectType [你在这里寻找什么]
//      * hobby [我的兴趣爱好](兴趣爱好以数组格式传递)
Future<BasePageData> updateUserData({
  String? expectAge,
  String? expectHeight,
  String? expectRegion,
  String? expectConstellation,
  String? expectType,
  List<String>? hobby,
}) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response =
        await getDio().post('/index/User/updateUserData', data: {
      'uid': uid,
      'expectAge': expectAge,
      'expectHeight': expectHeight,
      'expectRegion': expectRegion,
      'expectConstellation': expectConstellation,
      'expectType': expectType,
      'hobby': hobby,
    });
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///获取别人个人中心-主页-基本信息
Future<BasePageData<UserBasic?>> getHomeUserData(int userId) async {
  BasePageData<UserBasic?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/User/getHomeUserData',
        data: {'myUid': uid, 'userId': userId});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, UserBasic.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i('$basePageData');
  } on DioError catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 获取自己个人中心-主页-基本信息都可以用这个接口

Future<BasePageData<UserBasic?>> getUserBasic() async {
  BasePageData<UserBasic?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/User/getMyHomeUserData', data: {'myUid': uid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, UserBasic.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i('$basePageData');
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 检测APP版本 接口测试通过
Future<BasePageData<AppVersionInfo?>> checkAppVersion(
    int versionCode, String versionName) async {
  BasePageData<AppVersionInfo?> basePageData;
  try {
    Response response = await getDio().post('/index/share/newVersionUpdate',
        data: {'versionCode': versionCode, 'versionName': versionName});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, AppVersionInfo.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 获取地址
Future<BasePageData<Address?>> getAddress(
    double longitude, double latitude) async {
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
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 获取用户月卡到期时间 接口测试通过
Future<BasePageData<PayTime?>> getPayTime() async {
  BasePageData<PayTime?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response =
        await getDio().post('/index/share/getPayTime', data: {'uid': uid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, PayTime.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 获取访客 应该是个列表，接口测试通过
Future<BasePageData<List<VisitorInfo>?>> getVisitor(int pageNum) async {
  BasePageData<List<VisitorInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/getVisitor', data: {'uid': uid, 'page': pageNum});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<VisitorInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => VisitorInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
      basePageData.toString();
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 添加关注
/// userid 对方用户id 接口测试通过
Future<BasePageData> addFollow(int userid) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/addFollow', data: {'uid': uid, 'userid': userid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 取消关注
/// userid 对方用户id 接口测试通过
Future<BasePageData> delFollow(int userid) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/delFollow', data: {'uid': uid, 'userid': userid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 举报
/// userid 对方用户id 接口测试通过
Future<BasePageData> addAccusation(int userid, String content) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/share/addAccusation',
        data: {'uid': uid, 'userid': userid, 'content': content});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 申请注销账号 接口测试通过
Future<BasePageData> addDeleteAccountApplication() async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/addDeleteAccountApplication', data: {'uid': uid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 拉黑  接口测试通过
Future<BasePageData> addPullBlack(int userid) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/share/addPullBlack',
        data: {'uid': uid, 'userid': userid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 取消拉黑 接口测试通过
Future<BasePageData> delPullBlack(int userid) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/share/delPullBlack',
        data: {'uid': uid, 'userid': userid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 获取聊天页面对方用户信息
/// userid 对方用户id 接口测试通过
Future<BasePageData<ChatUserInfo?>> getChatPageUserInfo(int userId) async {
  BasePageData<ChatUserInfo?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/share/chatPageUserInfo',
        data: {'uid': uid, 'userId': userId});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, ChatUserInfo.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///发现页面导航栏 接口测试通过
Future<BasePageData<List<FindTabInfo>?>> getFindTab() async {
  BasePageData<List<FindTabInfo>?> basePageData;
  try {
    Response response = await getDio().post('/index/Index/getType');
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<FindTabInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => FindTabInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///关注列表页面 接口测试通过
Future<BasePageData<List<FollowInfo>?>> getFollowList(int page) async {
  BasePageData<List<FollowInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/followList', data: {'uid': uid, 'page': page});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<FollowInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => FollowInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i(basePageData);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///被关注列表 - 粉丝 接口测试通过
Future<BasePageData<List<CoverFollowInfo>?>> getCoverFollowList(
    int page) async {
  BasePageData<List<CoverFollowInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/coverFollowList', data: {'uid': uid, 'page': page});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<CoverFollowInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => CoverFollowInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i(basePageData);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 反馈  oss接口返回的图片路径 img  接口测试通过 img未测试
Future<BasePageData> addFeedback(
  String content,
  String img,
) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/share/addFeedback',
        data: {'uid': uid, 'content': content, 'img': img});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///收到的消息 - 评论 暂时没有数据
Future<BasePageData<List<ReceiveCommentMsg>?>> getReceiveCommentList(
    int page) async {
  BasePageData<List<ReceiveCommentMsg>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/receiveComment', data: {'uid': uid, 'page': page});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<ReceiveCommentMsg>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => ReceiveCommentMsg.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i(basePageData);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///收到的消息 - 赞 暂时没有数据
Future<BasePageData<List<ReceiveFabulousMsg>?>> getReceiveFabulousList(
    int page) async {
  BasePageData<List<ReceiveFabulousMsg>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/receiveFabulous', data: {'uid': uid, 'page': page});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<ReceiveFabulousMsg>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => ReceiveFabulousMsg.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i(basePageData);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///发出的消息 - 评论 暂时没有数据
Future<BasePageData<List<SendCommentMsg>?>> getSendCommentList(int page) async {
  BasePageData<List<SendCommentMsg>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/sendComment', data: {'uid': uid, 'page': page});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<SendCommentMsg>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => SendCommentMsg.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i(basePageData);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///发出的消息 - 赞 暂时没有数据
Future<BasePageData<List<SendFabulousMsg>?>> getSendFabulousList(
    int page) async {
  BasePageData<List<SendFabulousMsg>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/sendFabulous', data: {'uid': uid, 'page': page});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<SendFabulousMsg>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => SendFabulousMsg.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i(basePageData);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///需要依赖于oss接口
///认证提交 [认证类型 1-视频认证,2-身份认证,3-头像认证]  files oss上传的url只有视频认证和头像认证才上传
Future<BasePageData> addCertification(int type,
    {List<String> files = const []}) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response;
    response = await getDio().post('/index/share/addCertification',
        data: {'uid': uid, 'type': type, 'files': files});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 黑名单列表  接口测试通过
Future<BasePageData<List<BlackInfo>?>> getPullBlackList(int page) async {
  BasePageData<List<BlackInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/share/getPullBlackList',
        data: {'uid': uid, 'page': page});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<BlackInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => BlackInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i(basePageData);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 接口测试通过
///   * 消息聊天(当后台状态返回100时，再给对方发送消息，其他状态抛出msg)
Future<BasePageData> chatMessage(int targetUid, String content) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response;
    response = await getDio().post('/index/share/chatMessage',
        data: {'uid': uid, 'targetUid': targetUid, 'content': content});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///发现页面     * page [分页页数]
//      * uid [请求者自己的uid]
//      * sex [请求者自己的性别]
//      * type [栏目id]
Future<BasePageData<List<DiscoverInfo>?>> getDiscoverList(
    int page, int type) async {
  BasePageData<List<DiscoverInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    int sex = GetStorageUtils.getSex();
    Response response = await getDio().post('/index/Index/discover',
        data: {'uid': uid, 'page': page, 'sex': sex, 'type': type});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<DiscoverInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => DiscoverInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/**
 * 我的足迹
 */
Future<BasePageData<List<MyFootInfo>?>> getMyFootList(int page) async {
  BasePageData<List<MyFootInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio()
        .post('/index/share/myFootprint', data: {'uid': uid, 'page': page});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<MyFootInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => MyFootInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///附近
//      * uid [请求者自己的uid]
//      * sex [请求者自己的性别]
Future<BasePageData<List<NearbyInfo>?>> getNearbyList(int page) async {
  BasePageData<List<NearbyInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    int sex = GetStorageUtils.getSex();
    Response response = await getDio().post('/index/Index/nearby',
        data: {'uid': uid, 'page': page, 'sex': sex});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<NearbyInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => NearbyInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///动态-关注列表 接口通了，没有数据
//      * uid [请求者自己的uid]
//      * sex [请求者自己的性别]
Future<BasePageData<List<TrendsLikeInfo>?>> getTrendsLike(
    int page, int sex) async {
  BasePageData<List<TrendsLikeInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/Trends/trendsLike',
        data: {'uid': uid, 'page': page, 'sex': sex});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<TrendsLikeInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => TrendsLikeInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///动态-最新推荐
//      * uid [请求者自己的uid]
//      * sex [请求者自己的性别]
Future<BasePageData<List<NewTrendsInfo>?>> getNewTrends(int page) async {
  BasePageData<List<NewTrendsInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    int sex = GetStorageUtils.getSex();
    Response response = await getDio().post('/index/Trends/newTrends',
        data: {'uid': uid, 'page': page, 'sex': sex});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<NewTrendsInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => NewTrendsInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///动态-视频
//      * uid [请求者自己的uid]
//      * sex [请求者自己的性别]
Future<BasePageData<List<VideoTrendsInfo>?>> getVideoTrends(int page) async {
  BasePageData<List<VideoTrendsInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    int sex = GetStorageUtils.getSex();
    Response response = await getDio().post('/index/Trends/videoTrends',
        data: {'uid': uid, 'page': page, 'sex': sex});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<VideoTrendsInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => VideoTrendsInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
    logger.i(basePageData);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 动态话题分类列表
Future<BasePageData<List<TrendsTopicTypeInfo>?>>
    getTrendsTopicTypeList() async {
  BasePageData<List<TrendsTopicTypeInfo>?> basePageData;
  try {
    Response response = await getDio().post(
      '/index/Trends/trendsTopicTypeList',
    );
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<TrendsTopicTypeInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => TrendsTopicTypeInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      MyToast.show(baseResp.msg);
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 动态话题分类列表 [话题ID]
Future<BasePageData<TrendsTopicTypeInfo?>> getTrendsTopicType(int id) async {
  BasePageData<TrendsTopicTypeInfo?> basePageData;
  try {
    Response response = await getDio()
        .post('/index/Trends/getTrendsTopicData', data: {'id': id});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(baseResp.code, baseResp.msg,
          TrendsTopicTypeInfo.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 添加动态 [话题ID]
///      * uid [发布者UID](必填)
//      * content [动态内容]
//      * imgArr [图片集] {1.jpg,2.jpg,3.jpg}
//      * video [视频地址]如果是视频一个动态只能传一个视频
//      * type 动态类型0-心情（只有一段文字），1-动态（有文字和图片），2-视频]
//      * area [区域]（非必填）
//      * latitude [纬度]（非必填）
//      * longitude [经度]（非必填）
//      * topicId [话题ID]（非必填）
//      * topicName [话题名称]（非必填）
Future<BasePageData> addTrends(
  int type, {
  String content = '',
  List<String> localUrls = const [''],
  String? area,
  double? latitude,
  double? longitude,
  int? topicId,
  String? topicName,
}) async {
  BasePageData basePageData;
  try {
    List<String> urlOSS = [];
    if (localUrls.isNotEmpty) {
      //选中需要上传的文件
      int length = localUrls.length;
      for (int i = 0; i < length; i++) {
        BasePageData<String?> data = await fileUpload(localUrls[i]);
        if (data.isOk()) {
          if (data.data != null) {
            urlOSS.add(data.data ?? "");
          }
        }
      }
    }

    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/Trends/addTrends', data: {
      'uid': uid,
      'content': content,
      'imgArr': urlOSS,
      'type': type,
      'area': area,
      'latitude': latitude,
      'longitude': longitude,
      'topicId': topicId,
      'topicName': topicName,
    });
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  MyToast.show(basePageData.msg);
  return basePageData;
}

/// 动态详情
Future<BasePageData<TrendsDetails?>> trendsDetails(int trendsId) async {
  BasePageData<TrendsDetails?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response =
        await getDio().post('/index/Trends/trendsDetails', data: {
      'uid': uid,
      'trendsId': trendsId,
    });
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, TrendsDetails.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 评论
Future<BasePageData<AddCommentResp?>> addComment(
    int trendsId, String content) async {
  BasePageData<AddCommentResp?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/Trends/addComment', data: {
      'uid': uid,
      'trendsId': trendsId,
      'content': content,
    });
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, AddCommentResp.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 获取动态评论
Future<BasePageData<List<CommentInfo>?>> getTrendsCommentList(
  int page,
  int trendsId,
) async {
  BasePageData<List<CommentInfo>?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response =
        await getDio().post('/index/Trends/getTrendsComment', data: {
      'uid': uid,
      'trendsId': trendsId,
      'page': page,
    });
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      List<CommentInfo>? data = (baseResp.data as List<dynamic>?)
          ?.map((e) => CommentInfo.fromJson(e as Map<String, dynamic>))
          .toList();
      basePageData = BasePageData(baseResp.code, baseResp.msg, data);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 动态点赞
///     * uid [用户uid]
//      * trendsId [动态ID]
Future<BasePageData> addTrendsFabulous(
  int trendsId,
) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response =
        await getDio().post('/index/Trends/addTrendsFabulous', data: {
      'uid': uid,
      'trendsId': trendsId,
    });
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

///删除动态点赞
///     * uid [用户uid]
//      * trendsId [动态ID]
Future<BasePageData> deleteTrendsFabulous(
  int trendsId,
) async {
  BasePageData basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response =
        await getDio().post('/index/Trends/deleteTrendsFabulous', data: {
      'uid': uid,
      'trendsId': trendsId,
    });
    BaseResp baseResp = BaseResp.fromJson(response.data);
    basePageData = BasePageData(baseResp.code, baseResp.msg, null);
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 获取月卡充值列表以及状态显示状态信息
Future<BasePageData<PayList?>> getPayList() async {
  BasePageData<PayList?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response =
        await getDio().post('/index/Pay/payList', data: {'uid': uid});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, PayList.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// 生成内购订单号
Future<BasePageData<Order?>> createOrder(String productID) async {
  BasePageData<Order?> basePageData;
  try {
    int uid = GetStorageUtils.getUID();
    Response response = await getDio().post('/index/Pay/createOrder',
        data: {'uid': uid, 'productID': productID});
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      basePageData = BasePageData(
          baseResp.code, baseResp.msg, Order.fromJson(baseResp.data));
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}

/// OSS文件上传 视频、图片先使用此接口进行上传
Future<BasePageData<String?>> fileUpload(String filePath) async {
  BasePageData<String?> basePageData;
  FormData formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(filePath),
  });
  try {
    Response response = await getNoEncryptionDio()
        .post('/index/share/ossUpload', data: formData);
    BaseResp baseResp = BaseResp.fromJson(response.data);
    if (baseResp.code == respCodeSuccess) {
      String url = baseResp.data['url'];
      basePageData = BasePageData(baseResp.code, baseResp.msg, url);
    } else {
      basePageData = BasePageData(baseResp.code, baseResp.msg, null);
    }
  } catch (error) {
    logger.e(error);
    basePageData = BasePageData(errorCodeNetworkError, '网络异常', null);
  }
  return basePageData;
}
