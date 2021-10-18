import 'package:nim_core/nim_core.dart';
import 'package:untitled/network/logger.dart';

/**
 * 云信网络接口管理
 */
class NimNetworkManager {
  NimNetworkManager._();

  static final NimNetworkManager instance = NimNetworkManager._();

  void nimLogin(int uid, String token) {
    logger.i('云信登录uid=$uid token=$token');
    NimCore.instance.authService
        .login(NIMLoginInfo(
      account: "ll$uid",
      token: token,
    )).then(
      (result) {
        if (result.isSuccess) {
          logger.i('云信登录成功uid=$uid token=$token');
        } else {
          logger.e('云信登录失败uid$uid token=$token      '
              'errorDetails${result.errorDetails}'
              'result.code${result.code}');
        }
      },
    ).whenComplete(() => {
              logger.i('云信登录操作完成'),
            });
  }

  void logout(){
    NimCore.instance.authService
        .logout()
        .then(
            (result) {
          if (result.isSuccess) {
            /// 成功
          } else {
            /// 失败
          }
        }
    );
  }

  void loginStatus(){
    final subscription = NimCore.instance.authService.authStatus.listen((event) {
      if (event is NIMKickOutByOtherClientEvent) {
        /// 监听到被踢事件
      } else if (event is NIMAuthStatusEvent) {
        /// 监听到其他事件
      }
    });
    /// 不再监听时，需要取消监听，否则造成内存泄漏
    /// subscription.cancel();
  }


}
