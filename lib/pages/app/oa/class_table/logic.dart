import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swust_link/common/entity/oa/course.dart';
import 'package:swust_link/common/global.dart';
import 'package:swust_link/spider/matrix_oa.dart';
import 'package:swust_link/spider/sjjx_class_table.dart';

import 'state.dart';

class ClassTableLogic extends GetxController {
  final ClassTableState state = ClassTableState();

  Future<void> loadClassTable() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? firstDay = prefs.getString("firstDay");
    try {
      state.firstDay.value = DateTime.parse(firstDay!);
    } catch (e) {
      state.firstDay.value = DateTime.now();
    }
    state.currentWeek.value = getCurrentWeek();
    state.courses.value = await Global.localStorageService.loadFromLocal(
        "${state.title.value}-courses", (json) => Course.fromJson(json));
    state.isLoading.value = false;

    try {
      var data =
          await (await MatrixOa.getInstance())!.undergraduateClassTable.parseClassTable(state.url.value);
      if (state.title.value == "课程表") {
        if (data.isNotEmpty) {
          var sjjxData = await (await SJJXTable.getInstance())?.getCourseList()??[];
          data.addAll(sjjxData);
        }
      }
      if (data.isNotEmpty) {
        await Global.localStorageService
            .saveToLocal(data, "${state.title.value}-courses");
        state.courses.value = data;
        Get.snackbar("获取成功", "刷新本地课表缓存成功! ");

      }
    } catch (e) {
      Get.snackbar("获取失败", "请刷新重试或检查网络连接! ");
      state.courses.value = await Global.localStorageService.loadFromLocal(
          "${state.title.value}-courses", (json) => Course.fromJson(json));
    }
  }

  int getCurrentWeek()  {

    // 计算当前周和星期几
    final today = DateTime.now();
    final daysSinceFirstDay = today.difference(state.firstDay.value).inDays;
    if (daysSinceFirstDay<0){
      return 1;
    } else {
      final currentWeek = (daysSinceFirstDay ~/ 7) + 1;
      return currentWeek;
    }
  }
  List<List<Course>> get filteredCourses {
    final groupedCourses = <String, List<Course>>{};

    for (var course in state.courses) {
      if (state.currentWeek.value >= int.parse(course.startTime) &&
          state.currentWeek.value <= int.parse(course.endTime)) {
        final key = "${course.weekDay}-${course.session}";
        groupedCourses.putIfAbsent(key, () => []).add(course);
      }
    }
    return groupedCourses.values.toList();
  }

  Color getCourseColor(String className) {
    if (!state.courseColors.containsKey(className)) {
      final index = state.courseColors.length % state.predefinedColors.length;
      state.courseColors[className] = state.predefinedColors[index];
    }
    return state.courseColors[className]!;
  }

// 计算指定周的起始日期
  DateTime getWeekStartDate(int week) {
    // 获取第一天的 weekday（1 = 周一, 7 = 周日）
    final firstDayWeekday = state.firstDay.value.weekday;

    // 计算第一天的周一日期（回溯到第一周的周一）
    final firstMonday =
        state.firstDay.value.subtract(Duration(days: firstDayWeekday - 1));

    // 根据指定周数计算对应周的周一日期
    final daysToAdd = (week - 1) * 7;
    final targetDate = firstMonday.add(Duration(days: daysToAdd));

    // 如果计算结果早于第一天，返回第一天的周一
    if (targetDate.isBefore(firstMonday)) {
      return firstMonday;
    }

    return targetDate;
  }

// 设置当前周
}
