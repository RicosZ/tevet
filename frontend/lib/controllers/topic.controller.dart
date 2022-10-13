// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:getx_1/api/comment.api.dart';
import 'package:getx_1/api/topic.api.dart';
import 'package:getx_1/models/comment.dart';
// import 'package:getx_1/models/multi-topic.dart';
import 'package:getx_1/models/topic.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class TopicController extends GetxController {
  String slugid;
  BuildContext context;
  // String topicId;
  TopicController({required this.slugid, required this.context});
  Topic? _topic;
  // Comment? comment;
  var comment = <CommentData>[].obs;
  var topic = <TData>{}.obs;
  var isTopicLoading = true.obs;
  var isCommentLoading = true.obs;
  var commentlength = 0.obs;

  late IO.Socket socket;
  var connected = 0.obs;

  @override
  Future<void> onInit() async {
    getTopic(slugid: slugid);
    socket = IO.io(
        'http://192.168.1.141:5000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    setUpSocketListener();

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  getTopic({required String slugid}) async {
    try {
      final topicData = await TopicApi().getTopic(slugid: slugid);
      _topic = topicData;
      topic.assign(_topic!.data);
      // topic.assign(topicData);
      topic.refresh();
    } catch (e) {
      print(e);
    } finally {
      isTopicLoading(false);
      getComment(topicId: topic.first.id);
    }
  }

  getComment({required String topicId}) async {
    try {
      final commentData = await CommentApi().getComment(topicId: topicId);
      // comment = commentData;
      comment.assignAll(commentData);
      comment.refresh();
      print('reddddddddddddddddddddddddddd');
      commentlength.value = comment.length;
      commentlength.refresh();
      // return true;
    } catch (e) {
      print(e);
    } finally {
      isCommentLoading(false);
    }
  }

  addComment({
    required String topicId,
    required String comment,
    required String slugId,
  }) async {
    try {
      final res =
          await CommentApi().createComment(topicId: topicId, comment: comment);
      print(res);
      socket.emit('message', slugId);
    } catch (e) {}
  }

  setUpSocketListener() {
    socket.on('message-receive', (data) {
      if (slugid == data) {
        getTopic(slugid: data);
        print(data);
      }
    });
    socket.on('connected-user', (data) {
      print(data);
    });
  }
}
