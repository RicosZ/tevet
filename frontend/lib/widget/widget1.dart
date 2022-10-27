import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_1/api/auth.api.dart';
import 'package:getx_1/controllers/auth.controller.dart';
import 'package:getx_1/util/palette.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 97,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            // margin: EdgeInsets.only(left: 27,right: 54,bottom: 16),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 27, right: 27, top: 16),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: InkWell(
                            child: Card(
                                color: Palette.customColor1Container,
                                child: Icon(
                                  Icons.videocam,
                                  size: 28,
                                  color: Palette.customColor1,
                                )),
                            onTap: () async {
                              final token = await cacheService.readCache(
                                  key: 'refreshToken');
                              await AuthApi().logout(refreshToken: token);
                              await cacheService.deleteCache(
                                  key: 'accessToken');
                              await cacheService.deleteCache(
                                  key: 'refreshToken');
                              Get.toNamed('/home');
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'วิดีโอคอล',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 27, right: 27, top: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: InkWell(
                          child: Card(
                            color: Palette.secondaryContainer,
                            child: Icon(
                              Icons.forum,
                              size: 28,
                              color: Palette.secondary,
                            ),
                          ),
                          onTap: () {
                            Get.toNamed('/category/all');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'กระทู้ ',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 27, right: 27, top: 16),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: Card(
                              color: Palette.tertiaryContainer,
                              child: Icon(
                                Icons.article,
                                size: 28,
                                color: Palette.tertiary,
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'บทความ',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 27, right: 27, top: 16),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: Card(
                              color: Palette.customColor8Container,
                              child: Icon(
                                Icons.person_search,
                                size: 28,
                                color: Palette.customColor8,
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'ค้นหาหมอ',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 27, right: 27, top: 16),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: Card(
                              color: Palette.secondaryContainer,
                              child: Icon(
                                Icons.portrait,
                                size: 28,
                                color: Palette.secondary,
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'หมอที่ติดตาม',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 27, right: 27, top: 16),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: Card(
                              color: Palette.customColor4Container,
                              child: Icon(
                                Icons.pets,
                                size: 28,
                                color: Palette.customColor4,
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'สัตว์เลี้ยงของฉัน',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 27, right: 27, top: 16),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: Card(
                              color: Palette.customColor3Container,
                              child: Icon(
                                Icons.map,
                                size: 28,
                                color: Palette.customColor3,
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'แผนที่',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
