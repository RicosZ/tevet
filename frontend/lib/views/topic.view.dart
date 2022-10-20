import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
// import 'package:getx_1/api/comment.api.dart';
import 'package:getx_1/controllers/topic.controller.dart';

class TopicView extends StatelessWidget {
  TopicView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topicController = Get.put(TopicController(
        slugid: '${Get.parameters['slugid']}', context: context));
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => topicController.isTopicLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Card(
                            margin: EdgeInsets.all(12),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              topicController
                                                  .topic.first.topicSubject,
                                              style: TextStyle(fontSize: 23),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              topicController
                                                  .topic.first.topicDetail,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(children: [
                                        Icon(Icons.people),
                                        Text(topicController
                                            .topic.first.postName.name),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(Icons.lock_clock_outlined),
                                        Text(topicController
                                            .topic.first.createdAt
                                            .toLocal()
                                            .toString()),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(Icons.remove_red_eye_outlined),
                                        Text(topicController
                                            .topic.first.countViews
                                            .toString()),
                                      ]),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              Obx(
                () => topicController.isCommentLoading.value
                    ? Container()
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: topicController.commentlength.value,
                        itemBuilder: (context, index) {
                          // print(topicController.comment!.data[index].commentBy);
                          return Column(
                            children: [
                              Card(
                                margin: EdgeInsets.all(12),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://c.tenor.com/Ad-xu5LhRHoAAAAC/elysia-honkai-impact3.gif'),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Text(topicController
                                              .comment[index].postName.name)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(topicController
                                          .comment[index].commentDetail),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openDialog(context, topicController);
            // Get.toNamed('/topic/add');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

final _formKey = GlobalKey<FormBuilderState>();

Future openDialog(BuildContext context, TopicController topicController) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Your Comment'),
        content: FormBuilder(
            key: _formKey,
            child: FormBuilderTextField(
              name: 'comment',
              validator: (comment) {
                if (comment!.isEmpty) {
                  return 'Comment can not be null';
                }
              },
              onSaved: (comment) => topicController.commentData = comment,
            )),
        actions: [
          TextButton(
            onPressed: () async {
              // final comment = _formKey.currentState!.fields['comment']!.value;
              // print(comment);
              // var topicId = topicController.topic.first.id;
              // await topicController.addComment(topicId: topicId, comment: comment,slugId: '${Get.parameters['slugid']}');
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                topicController.addComment();
                topicController.getTopic(slugid: '${Get.parameters['slugid']}');
                Get.back(closeOverlays: true);
              }
              // topicController.getComment(topicId: topicId);
              // Get.toNamed('/topic/${topicId}');hell้ำ้ำ้
              // TopicController(slugid: topicId).update();
            },
            child: Text('SUBMIT'),
          ),
        ],
      ),
    );
