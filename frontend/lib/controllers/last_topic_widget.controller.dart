import 'package:get/state_manager.dart';
import 'package:getx_1/api/topic.api.dart';
import 'package:getx_1/models/multi-topic.dart';

class LastTopicController extends GetxController {
  Topics? topic;
  var isDataLoading = true.obs;

  @override
  Future<void> onInit() async {
    fetchTopic();
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

  fetchTopic() async {
    try {
      final topicData = await TopicApi().getLastTopic();
      topic = topicData;
    } catch (e) {
      print(e);
    } finally {
      isDataLoading(false);
    }
  }
  
}
