import 'package:dio/dio.dart';
import 'package:getx_1/models/tag.dart';
import 'package:getx_1/routes/app.route.dart';
import 'package:getx_1/services/auth.services.dart';

class TagApi {
  var dio = Dio();

  Future getTags() async {
    dio.options.baseUrl = APIRoutes.BaseURL;
    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    final String subURL = '/forum/tags/';
    try {
      final response = await dio.get(subURL);
      final statusCode = response.statusCode;
      final body = response.data;

      if (statusCode == 200) {
        final tag = Tag.fromJson(body);
        List<TagData> taglist = [];
        taglist.addAll(tag.data);
        return taglist;
      }
    } catch (e) {
      // print(e);
    }
  }
}
