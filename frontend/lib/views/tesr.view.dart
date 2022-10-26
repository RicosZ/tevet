import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:getx_1/controllers/test.comtroller.dart';
import 'package:getx_1/views/home.view.dart';
import 'package:getx_1/views/login.view.dart';

class test extends StatelessWidget {
  const test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(testController());
    if (controller.havetoken.value) {
      return HomePage();
    } else {
      return LoginView();
    }
  }
}
