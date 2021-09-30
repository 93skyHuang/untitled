import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'get_example.dart';

class SimplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('SimplePage--build');
    return Scaffold(
      appBar: AppBar(title: Text('Simple')),
      body: Center(
        child: GetBuilder<ExampleController>(
            init: ExampleController(),
            builder: (controller) {
              return Text(controller.counter.toString());
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<ExampleController>().increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
