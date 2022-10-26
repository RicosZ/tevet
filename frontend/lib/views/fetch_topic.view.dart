import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:getx_1/controllers/fetch-topic.cntroller.dart';
// import 'package:getx_1/views/category.view.dart';
import 'package:intl/intl.dart';

class FecthTTopicView extends StatelessWidget {
  FecthTTopicView({
    Key? key,
  }) : super(key: key);
  // String? _categorySlug = Get.parameters['slug'];
  final fetchTopicController =
      Get.put(FetchTopicController(slug: '${Get.arguments['slug']}'));
      // Get.put(FetchTopicController(slug: '${Get.parameters['slug']}'));
  @override
  Widget build(BuildContext context) {
    // print(_categorySlug);
    return Scaffold(
      body: Obx(
        () => fetchTopicController.isDataLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: fetchTopicController.topic?.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Card(
                      margin: EdgeInsets.all(12),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                          Expanded(
                                            child: Text(
                                              fetchTopicController.topic!
                                                  .data[index].topicSubject,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
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
                                          Text(
                                            getDateFormat(
                                                value: fetchTopicController
                                                    .topic!.data[index].createdAt
                                                    .toUtc()
                                                    .toString()),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Icon(Icons.message),
                                          Text(fetchTopicController
                                              .topic!.data[index].countComment
                                              .toString()),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.remove_red_eye_outlined),
                                          Text(fetchTopicController
                                              .topic!.data[index].countViews
                                              .toString()),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.thumb_up_alt_outlined),
                                          Text(fetchTopicController
                                              .topic!.data[index].countLike
                                              .toString()),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                // Text(categoryController.products[index].Price
                                //     .toString())
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      var _slugid =
                          fetchTopicController.topic!.data[index].slugId;
                      // var topicid = fetchTopicController.topic!.data[index].id;
                      print(_slugid);
                      Get.toNamed('/topic/${_slugid}');
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/topic/add');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

getDateFormat(
    {required value,
    String currentFormat = "yyyy-MM-ddTHH:mm:ssZ",
    String desiredFormat = "yyyy-MM-dd HH:mm:ss",
    isUtc = false}) {
  DateTime? dateTime;
  if (value != null || value.isNotEmpty) {
    try {
      dateTime = DateFormat(desiredFormat).parse(value);
    } catch (e) {
      print("$e");
    }
  }
  return dateTime.toString();
}
