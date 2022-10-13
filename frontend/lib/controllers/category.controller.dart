// import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:getx_1/api/category.api.dart';
import 'package:getx_1/models/category.dart';
import 'package:getx_1/services/cache.services.dart';

final CacheService cacheService = new CacheService();

class CategoryController extends GetxController {
  Category? category;
  var isDataLoading = true.obs;

  @override
  Future<void> onInit() async {
    fetchCategory();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  fetchCategory() async {
    try {
      // print(accessToken);
      final response =
          await CategoryApi().FetchCategory();
      // final cat = Category.fromJson(json.decode(response));
      // category = cat;
      category = response;
    } catch (e) {
      print(e);
    } finally {
      isDataLoading(false);
    }
  }
}
