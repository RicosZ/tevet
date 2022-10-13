// import 'dart:convert';
// import 'dart:io';
import 'package:get/get.dart';
import 'package:getx_1/models/category.dart';
import 'package:getx_1/models/category_list.dart';
import 'package:getx_1/routes/app.route.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:getx_1/services/auth.services.dart';

class CategoryApi {
  // final client = http.Client();
  // final headers = {
  //   'Content-type': 'application/json;utf-8',
  //   'Accept': 'application/json',
  //   "Access-Control-Allow-Origin": "*",
  // };
  var dio = Dio();

  Future FetchCategory() async {
    dio.options.baseUrl = APIRoutes.BaseURL;
    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    final String subURL = '/forum/categories/';

    try {
      final response = await dio.get(
        subURL,
        queryParameters: {'page': 1, 'value': -1},
      );
      final statusCode = response.statusCode;
      // final body = response.body;
      final body = response.data;
      // print(body);
      if (statusCode == 200) {
        return Category.fromJson(body);
        // return body;
      }
    } catch (e) {
      // print(e);
      Get.toNamed('/login');
    }
  }

  Future GetCategoryList() async {
    dio.options.baseUrl = APIRoutes.BaseURL;
    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    final String subURL = '/forum/categories/list/name';

    try {
      final response = await dio.get(subURL);
      final statusCode = response.statusCode;
      // final body = response.body;
      final body = response.data;
      // print(body);
      if (statusCode == 200) {
        final cat = CategoryList.fromJson(body);
        List<CategoryListData> category = [];
        category.addAll(cat.categories);
        return category;
        // return body;
      }
    } catch (e) {
      // print(e);
      // Get.toNamed('/login');
    }
  }
}
