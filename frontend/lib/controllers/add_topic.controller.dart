import 'package:get/state_manager.dart';
import 'package:getx_1/api/category.api.dart';
import 'package:getx_1/api/tag.api.dart';
import 'package:getx_1/api/topic.api.dart';
import 'package:getx_1/models/category_list.dart';
import 'package:getx_1/models/tag.dart';

class addTopicController extends GetxController {
  // CategoryList? categoryList;
  // Tag? tag;
  String? topicSubject, topicDetail;

  var cat = <CategoryListData>[].obs;
  var tag = <TagData>[].obs;
  Object? selectCategory;
  List<dynamic> selectTag = [];
  var selectedCategory = ''.obs;
  var selectedTag = ''.obs;
  var isDataLoading = true.obs;
  var hint = 'Select Category'.obs;

  @override
  Future<void> onInit() async {
    getCategoryList();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  getCategoryList() async {
    try {
      final CategorylistData = await CategoryApi().GetCategoryList();
      cat.assignAll(CategorylistData);
      //ไม่ใส่ก็ได้มั้ง
      // cat.refresh();
    } catch (e) {
    } finally {
      getTag();
    }
  }

  getTag() async {
    try {
      final TagsData = await TagApi().getTags();
      tag.assignAll(TagsData);
      // tag.refresh();
    } catch (e) {
    } finally {
      isDataLoading(false);
    }
  }

  createTopic() async {
    try {
      final response = await TopicApi().createTopic(
          category: selectCategory!,
          topicSubject: topicSubject!,
          topicDetail: topicDetail!,
          tags: selectTag);
    } catch (e) {
      print(e);
    } finally {
    }
  }
}
