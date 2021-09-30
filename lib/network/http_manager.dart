import 'package:dio/dio.dart';
import 'bean/user_info.dart';
import 'dio_util.dart';
import 'logger.dart';


Future<UserInfo?> getUserInfo() async {
  try {
    Response response =
        await getDio().post('/index/User/getUserInfo', data: {'uid': 105324});
    logger.i('-----${response.data['data']['uid']}');
    return UserInfo.fromJson(response.data);
  } on DioError catch (error) {
    logger.i(error);
    rethrow;
  }
}
