import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_1/controllers/last_topic_widget.controller.dart';
import 'package:getx_1/util/palette.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LastTopic extends StatelessWidget {
  LastTopic({Key? key}) : super(key: key);
  final controller = Get.put(LastTopicController());
  final pageController = PageController(keepPage: true);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            // width: 340,
            height: 130,
            child: Obx(
              () => controller.isDataLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PageView.builder(
                      controller: pageController,
                      itemCount: controller.topic?.data.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.fromLTRB(16, 10, 16, 8),
                        child: Card(
                          elevation: 4,
                          shadowColor: Palette.primary,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    controller.topic!.data[index].topicSubject,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 14),
                                    child: Text('Aofzana  27 เม.ย 2565 16:26'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          Obx(() => controller.isDataLoading.value
              ? Container()
              : SmoothPageIndicator(
                  controller: pageController,
                  count: controller.topic!.data.length,
                  effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Palette.primary50
                      // type: WormType.thin,
                      // strokeWidth: 5,
                      ),
                )),
        ],
      ),
    );
  }
}
