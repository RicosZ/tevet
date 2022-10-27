import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:getx_1/controllers/bottom_navigation_bar.controller.dart';
import 'package:getx_1/views/home.view.dart';
import 'package:getx_1/views/login.view.dart';
import 'package:getx_1/views/page1.dart';
import 'package:getx_1/views/tesr.view.dart';

import '../util/palette.dart';

class bottomNav extends StatelessWidget {
  bottomNav({Key? key}) : super(key: key);

  BottomNavigationController _controller =
      Get.put(BottomNavigationController());
  final screens = [
    HomePage(),
    HomePage(),
    test(),
    page1(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: _controller.selectedIndex.value,
            children: screens,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'บ้าน',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  label: 'รายการ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_none),
                  label: 'แจ้งเตือน',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'ฉัน',
                ),
              ],
              onTap: (index) {
                // homeController.currentindex.value = index;
                _controller.changeindex(index);
              },
              type: BottomNavigationBarType.fixed,
              currentIndex: _controller.selectedIndex.value,
              selectedItemColor: Palette.primary60,
              unselectedItemColor: Palette.outline,
              )
      ),
    );
  }
}
