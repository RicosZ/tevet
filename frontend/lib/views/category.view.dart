import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:getx_1/controllers/category.controller.dart';
// import 'package:getx_1/controllers/fetch-topic.cntroller.dart';
// import 'package:getx_1/views/add_topic.view.dart';
import 'package:intl/intl.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({Key? key}) : super(key: key);
  final categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => categoryController.isDataLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: categoryController.category?.data.length,
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
                                Column(
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
                                        Text(
                                          categoryController
                                              .category!.data[index].catName,
                                          style: TextStyle(fontSize: 23),
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
                                              value: categoryController
                                                  .category!
                                                  .data[index]
                                                  .replyDlast
                                                  .toUtc()
                                                  .toString()),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Icon(Icons.message),
                                        Text(categoryController
                                            .category!.data[index].replyDcount
                                            .toString()),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.comment_outlined),
                                        Text(categoryController
                                            .category!.data[index].topicCount
                                            .toString())
                                      ],
                                    )
                                  ],
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
                      var _slug = categoryController.category!.data[index].slug;
                      // var x = utf8.encode(
                      //     categoryController.category!.data[index].slug);
                      // var y = utf8.decode(x);
                      // print(y);
                      Get.toNamed('/category/', arguments: {'slug': _slug});
                      // Get.toNamed('/category/${_slug}');
                    },
                  );
                },
              ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.toNamed('/category/add');
      //   },
      //   child: Icon(Icons.add),
      // ),
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
