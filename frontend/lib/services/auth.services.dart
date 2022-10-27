import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:getx_1/api/auth.api.dart';
import 'package:getx_1/controllers/auth.controller.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final listOfPaths = <String>[
      '/auth/login',
      '/forum/topics/',
      '/forum/categories/list/name',
      '/forum/tags/'
      '/auth/logout'
    ];

    if (listOfPaths.contains(options.path.toString())) {
      // if the endpoint is matched then skip adding the token.
      return handler.next(options);
    }
    try {
      var rf = await cacheService.readCache(key: 'refreshToken');
      final response = await AuthApi().refreshToken(refreshToken: rf);
      final Map<String, dynamic> parsedValue = response;
      final accessToken = parsedValue['accessToken'];
      final refreshToken = parsedValue['refreshToken'];
      // final isCustomer = parsedValue['isCustomer'];
      if (parsedValue['success'] == true) {
        cacheService.writeCache(key: 'accessToken', value: accessToken);
        cacheService.writeCache(key: 'refreshToken', value: refreshToken);
        // cacheService.writeCache(key: 'isCustomer', value: isCustomer);
        // print('auth $accessToken');
        // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        // sharedPreferences.setString('jwt', accessToken);
      }
      var token = await cacheService.readCache(key: 'accessToken');
      options.headers.addAll({'Authorization': 'Bearer ${token}'});
      return handler.next(options);
    } catch (e) {
      Get.offAndToNamed("/login");
    }
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   return handler.next(response);
  // }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}
