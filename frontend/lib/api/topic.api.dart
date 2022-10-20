import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:getx_1/controllers/auth.controller.dart';
import 'package:getx_1/models/multi-topic.dart';
import 'package:getx_1/models/topic.dart';

import 'package:getx_1/routes/app.route.dart';
import 'package:getx_1/services/auth.services.dart';
import 'package:jwt_decode/jwt_decode.dart';

class TopicApi {
  var dio = Dio();

  Future FetchTopic({required String categorySlug}) async {
    dio.options.baseUrl = APIRoutes.BaseURL;
    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    final String subURL = '/forum/topics/';
    try {
      final response = await dio
          .get(subURL, queryParameters: {'categorySlug': categorySlug});
      final statusCode = response.statusCode;
      final body = response.data;

      if (statusCode == 200) {
        return Topics.fromJson(body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getTopic({required String slugid}) async {
    dio.options.baseUrl = APIRoutes.BaseURL;
    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    final String subURL = '/forum/topics/';

    try {
      final response = await dio.get(subURL + slugid);
      final statusCode = response.statusCode;
      final body = response.data;

      if (statusCode == 200) {
        // final tps = Topic.fromJson(body);
        // List<TData> topic = [];
        // topic.add(tps.data);
        // // print(topic);
        // return topic.first;
        return Topic.fromJson(body);
      }
    } catch (e) {
      // print(e);
    }
  }

  Future createTopic(
      {required Object category,
      required String topicSubject,
      required String topicDetail,
      // required String topicBy,
      required Object tags}) async {
    dio.options.baseUrl = APIRoutes.BaseURL;
    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    final token = await cacheService.readCache(key: 'accessToken');
    Map<String, dynamic> tokenData = Jwt.parseJwt(token.toString());
    var userId = tokenData['id'];
    final String subURL = '/forum/topics/';
    try {
      final response = await dio.post(subURL, data: {
        'category': category,
        'topicSubject': topicSubject,
        'topicDetail': topicDetail,
        'topicBy': userId,
        'tags': tags
      });
      final statusCode = response.statusCode;
      final body = response.data;
      if (statusCode == 200) {
        // print(body);
        Get.toNamed('/category/all');
      }
    } catch (e) {
      print(e);
    }
  }
}
