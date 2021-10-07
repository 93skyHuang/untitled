import 'package:get/get.dart';

//语言包
class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'hello': '你好 世界',
        },
      };
}
