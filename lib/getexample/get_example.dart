import 'package:get/get.dart';
import 'package:untitled/network/logger.dart';

class ExampleController extends GetxController{

  int _counter = 0.obs();
  int get counter => _counter;

  void increment() {
    _counter++;
    update();
  }

  @override
  void onInit() {
    logger.i("onInit");
  }

  @override
  void onClose() {
    logger.i("onClose");
  }

  @override
  void onReady() {
    logger.i("onReady");
  }
}

