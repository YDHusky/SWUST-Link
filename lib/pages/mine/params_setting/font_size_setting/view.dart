import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'logic.dart';
import '../../../../common/model/font_size_model.dart';

class FontSizeSettingPage extends StatelessWidget {
  FontSizeSettingPage({Key? key}) : super(key: key);

  final FontSizeSettingLogic logic = Get.put(FontSizeSettingLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('字体大小设置')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("字体大小预览", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Obx(() => Column(
              children: logic.getAdjustedFontSizes().map((data) {
                FontType font = data["font"] as FontType; // 确保正确解析
                int adjustedSize = data["size"] as int;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    font.des,
                    style: TextStyle(
                      fontSize: adjustedSize.toDouble(),
                    ),
                  ),
                );
              }).toList(),
            )),
            SizedBox(height: 40),
            Obx(() => Slider(
              value: logic.sliderValue.value,
              min: -2,
              max: 2,
              divisions: 4,
              label: logic.sliderValue.value.toInt().toString(),
              onChanged: (value) {
                logic.updateFontOffset(value.toInt());
              },
            )),
            SizedBox(height: 20),
            Text("拖动滑块调整字体大小"),
          ],
        ),
      ),
    );
  }
}
