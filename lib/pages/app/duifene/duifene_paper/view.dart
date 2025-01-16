import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:swust_link/spider/duifene.dart';

import 'logic.dart';
import 'state.dart';

class DuifenePaperPage extends StatelessWidget {
  DuifenePaperPage({Key? key}) : super(key: key);

  final DuifenePaperLogic logic = Get.put(DuifenePaperLogic());
  final DuifenePaperState state = Get.find<DuifenePaperLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f4f6),
      appBar: AppBar(
        backgroundColor: Color(0xfff3f4f6),
        title: Row(
          children: [
            Expanded(child: Text("对分易练习")),
            Text("筛选"),
            Obx(()=>Switch(
                value: state.isShowComplete.value,
                onChanged: (value) {

                  state.isShowComplete.value = value;
                  state.papers.refresh();
                }))
          ],
        ),
      ),
      body: Obx(() {
        if (state.isLoading.value) {
          // 显示加载占位符
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.papers.isEmpty) {
          return Center(
            child: Text("无作业"),
          );
        }

        return Column(
          children: [
            // 其他组件保持不变
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  itemCount: state.papers.length,
                  itemBuilder: (context, index) {

                    final paper = state.papers[index];
                    if(state.isShowComplete.value){
                      if(paper.isSubmit){
                        return SizedBox.shrink();
                      }
                    }
                    return ListTile(
                      title: Text(paper.name),
                      subtitle: Text("开始: ${paper.createDate}\n结束: ${paper.endDate}"),
                      trailing: Column(
                        children: [
                          Text(paper.isSubmit ? "分数: ${paper.myScore}" : "未提交"),
                        ],
                      ),
                      leading: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Color((paper.name.hashCode) | 0xFF000000),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          paper.name[0], // 使用文字的首字母作为图标
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      }),

    );
  }
}
