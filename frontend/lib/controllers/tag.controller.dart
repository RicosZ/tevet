import 'package:get/state_manager.dart';
// import 'package:getx_1/api/category.api.dart';
import 'package:getx_1/api/tag.api.dart';
// import 'package:getx_1/models/category_list.dart';
import 'package:getx_1/models/tag.dart';

class TagController extends GetxController {
  // CategoryList? categoryList;
  // Tag? tag;
  // var cat = <CategoryListData>[].obs;
  var tag = <TagData>[].obs;
  // List<dynamic> selectCategory = [];
  List<dynamic> selectTag = [];
  var selectedTag = ''.obs;
  var isDataLoading = true.obs;

  @override
  Future<void> onInit() async {
    // getCategoryList();
    getTag();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  

  getTag() async {
    try {
      final TagsData = await TagApi().getTags();
      tag.assignAll(TagsData);
      tag.refresh();
    } catch (e) {
    } finally {
      isDataLoading(false);
    }
  }
}
