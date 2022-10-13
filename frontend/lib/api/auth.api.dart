// import 'dart:convert';
// import 'dart:io';

import 'package:dio/dio.dart';
import 'package:getx_1/routes/app.route.dart';
import 'package:getx_1/services/auth.services.dart';

class AuthApi {


  var dio = Dio();

  Future login({required String email, required String password}) async {
    dio.options.baseUrl = APIRoutes.BaseURL;
    // dio.options.headers = {'Set-Cookie': ''};
    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    final String subURL = '/auth/login';
    // final String uri = APIRoutes.BaseURL + subURL;

    try {
      final response =
          await dio.post(subURL, data: {'email': email, 'password': password});
      final statusCode = response.statusCode;
      final body = response.data;
      // print(body);
      if (statusCode == 200) {
        return body;
      }
    } catch (e) {
      print(e);
    }
  }

  Future refreshToken({required String refreshToken}) async {
    final String subURL = '/auth/refresh';
    final String uri = APIRoutes.BaseURL + subURL;

    try {
      final response =
          await dio.post(uri, data: {'refreshToken': refreshToken});
      final statusCode = response.statusCode;
      final body = response.data;
      if (statusCode == 200) {
        // print(body);
        return body;
      }
    } catch (e) {
      print(e);
    }
  }
}
