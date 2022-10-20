// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:get/state_manager.dart';
import 'package:getx_1/api/auth.api.dart';
import 'package:getx_1/services/cache.services.dart';

final CacheService cacheService = new CacheService();

class AuthController extends GetxController {
  // var isDataLoading = true.obs;
  String? email, password;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  Login() async {
    try {
      final response = await AuthApi().login(email: email!, password: password!);
      final Map<String, dynamic> parsedValue = response;
      final accessToken = parsedValue['accessToken'];
      final refreshToken = parsedValue['refreshToken'];
      final isCustomer = parsedValue['isCustomer'];
      if (parsedValue['success'] == true) {
        // print(accessToken);
        await cacheService.writeCache(key: 'accessToken', value: accessToken);
        await cacheService.writeCache(key: 'refreshToken', value: refreshToken);
        await cacheService.setBool(key: 'isCustomer', value: isCustomer);
        // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        // sharedPreferences.setString('jwt', accessToken);
        Get.toNamed('/category/all');
        // Get.toNamed('/test');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Somthing went wrong')));
      print(e);
    }
  }

  // refreshToken()async{
  //   var rf = await cacheService.readCache(key: 'refreshToken');
  //   try {
  //     final response = await AuthApi().refreshToken(refreshToken: rf);
  //     final Map<String, dynamic> parsedValue = response;
  //     final accessToken = parsedValue['accessToken'];
  //     final isCustomer = parsedValue['isCustomer'];
  //     if (parsedValue['success'] == true) {
  //       await cacheService.writeCache(key: 'accessToken',value: accessToken);
  //       // print(accessToken);
  //       // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //       // sharedPreferences.setString('jwt', accessToken);
  //     }
  //   } catch (e) {

  //   }
  // }
}
