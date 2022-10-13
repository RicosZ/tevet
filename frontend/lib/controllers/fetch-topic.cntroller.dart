import 'package:get/state_manager.dart';
import 'package:getx_1/api/topic.api.dart';
import 'package:getx_1/models/multi-topic.dart';

class FetchTopicController extends GetxController {
  String slug;
  FetchTopicController({required this.slug});
  Topics? topic;
  var isDataLoading = true.obs;

  @override
  Future<void> onInit() async {
    fetchTopic(categorySlug: slug);
    super.onInit();
  }
  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}
  
  // String get Slug => slug;
  // void set Slug(String categorySlug){
  //   slug = categorySlug;
  // }

  fetchTopic({required String categorySlug}) async {
    try {
      final topicData = await TopicApi().FetchTopic(categorySlug: categorySlug);
      topic = topicData;
    } catch (e) {
      print(e);
    } finally {
      isDataLoading(false);
    }
  }
  
}
