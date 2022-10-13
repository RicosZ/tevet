import 'package:dio/dio.dart';
import 'package:getx_1/controllers/auth.controller.dart';
import 'package:getx_1/models/comment.dart';
import 'package:getx_1/routes/app.route.dart';
import 'package:getx_1/services/auth.services.dart';
import 'package:jwt_decode/jwt_decode.dart';

class CommentApi {
  var dio = Dio();

  Future getComment({required String topicId}) async {
    dio.options.baseUrl = APIRoutes.BaseURL;
    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    final String subURL = '/forum/comments/';
    try {
      final response =
          await dio.get(subURL, queryParameters: {'topicId': topicId});
      final statusCode = response.statusCode;
      final body = response.data;

      if (statusCode == 200) {
        final cmt = Comment.fromJson(body);
        List<CommentData> comment = [];
        comment.addAll(cmt.data);
        return comment;
        // return Comment.fromJson(body);
      }
    } catch (e) {
      // print(e);
    }
  }

  Future createComment(
      {required String topicId, required String comment}) async {
    var token = await cacheService.readCache(key: 'accessToken');
    Map<String, dynamic> payload = Jwt.parseJwt(token.toString());
    final userId = payload['id'];
    dio.options.baseUrl = APIRoutes.BaseURL;
    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());
    final String subURL = '/forum/comments/';
    try {
      final response = await dio.post(subURL, data: {
        'topicId': topicId,
        'commentBy': userId,
        'commentDetail': comment
      });
      final statusCode = response.statusCode;
      final body = response.data;
      print(statusCode);
      if (statusCode == 201) {
        // print('objectaaaaaaaaaaaaaaaaaaaaaaaa');
        return body;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
