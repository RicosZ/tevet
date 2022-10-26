import 'package:get/state_manager.dart';
import 'package:getx_1/controllers/auth.controller.dart';

class testController extends GetxController {
  final havetoken = false.obs;
  @override
  Future<void> onInit() async {
    checkToken();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  checkToken() async {
    final cache = await cacheService.readCache(key: 'refreshToken');
    if (cache.toString().isNotEmpty) {
      havetoken(true);
    }
  }
}
