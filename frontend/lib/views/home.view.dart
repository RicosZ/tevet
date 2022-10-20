// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:getx_1/controllers/home.controller.dart';
import 'package:getx_1/util/palette.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final homeController = Get.put(HomeController());
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GateVet',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_outlined),
            color: Colors.black,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'บ้าน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'รายการ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'แจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'แจ้งเตือน',
          ),
        ],
        onTap: (index) {
          // homeController.currentindex.value = index;
          homeController.changeIndex(index);
          print(index);
          print(homeController.currentindex);
        },
        currentIndex: homeController.currentindex.value,
        selectedItemColor: Palette.primary60,
        unselectedItemColor: Palette.outline,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              SizedBox(
                height: 240,
                child: PageView.builder(
                  controller: controller,
                  itemCount: 3,
                  itemBuilder: (_, index) {
                    return Image.network(
                        'https://c.tenor.com/Ad-xu5LhRHoAAAAC/elysia-honkai-impact3.gif');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 12),
              ),
              SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  dotHeight: 6,
                  dotWidth: 10,
                  type: WormType.thin,
                  // strokeWidth: 5,
                ),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
