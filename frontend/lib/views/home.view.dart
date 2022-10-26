// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:getx_1/controllers/home.controller.dart';
import 'package:getx_1/util/palette.dart';
import 'package:getx_1/widget/last_topic.dart';
import 'package:getx_1/widget/widget1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final homeController = Get.put(HomeController());
  final controller = PageController(keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'GateVet',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Palette.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_outlined),
            color: Colors.black,
          )
        ],
      ),
      // bottomNavigationBar: bottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Palette.bgNew,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                SizedBox(
                  height: 160,
                  // width: 100,
                  child: PageView.builder(
                    controller: controller,
                    itemCount: 3,
                    itemBuilder: (_, index) {
                      return Container(
                        child: Image.network(
                            'https://img.freepik.com/free-photo/group-portrait-adorable-puppies_53876-64778.jpg?w=2000&t=st=1666603866~exp=1666604466~hmac=ee012db529e213abd1b8e3a1af0fdeec34b56a6336570760bc01e31700f93498'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 12),
                ),
                Center(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Palette.primary50
                        // type: WormType.thin,
                        // strokeWidth: 5,
                        ),
                  ),
                ),
                SizedBox(height: 36.0),
                MyWidget(),
                //forum
                SizedBox(
                  height: 26,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'กระทู้ล่าสุด',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                LastTopic(),
                //article
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'บทความล่าสุด',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                Container(
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
                              'เสมียนปราบดาภิเษกนมส้ม ดับก็ล็อกอิน มะเมียศกจิบเจ็บท้องข้องใจดูกหัว'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 14),
                              child: Text('Aofzana  27 เม.ย 2565 16:26'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //promotion
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'โปรโมชั่นล่าสุด',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                Container(
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
                              'เสมียนปราบดาภิเษกนมส้ม ดับก็ล็อกอิน มะเมียศกจิบเจ็บท้องข้องใจดูกหัว'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 14),
                              child: Text('Aofzana  27 เม.ย 2565 16:26'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
