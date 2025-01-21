import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:swust_link/common/routes/app_pages.dart';

import 'logic.dart';
import 'state.dart';

class AppPage extends StatelessWidget {
  AppPage({Key? key}) : super(key: key);

  final AppLogic logic = Get.put(AppLogic());
  final AppState state = Get.find<AppLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: state.appNewList.length,
        itemBuilder: (context, sectionIndex) {
          final section = state.appNewList[sectionIndex];
          return Opacity(opacity: 0.8,child: Container(
              padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  // 圆角
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      section['label'] as String,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 每行四个网格项
                      crossAxisSpacing: 10, // 横向间距
                      mainAxisSpacing: 10, // 纵向间距
                    ),
                    itemCount: (section['children'] as List).length,
                    itemBuilder: (context, index) {
                      final app = (section['children'] as List)[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(app['route'] as String);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 48.h,
                              width: 48.w,
                              decoration: BoxDecoration(
                                color: Color((app['text'].hashCode) | 0xFF000000),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                app['text'][0], // 使用文字的首字母作为图标
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              app['text'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )),);
        },
      ),
    );
  }
}
