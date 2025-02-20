import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:swust_link/common/entity/oa/exam.dart';
import 'package:swust_link/common/global.dart';
import 'package:swust_link/spider/matrix_oa.dart';
import 'state.dart';

class ExamLogic extends GetxController {
  final ExamState state = ExamState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initExams();
  }

  Future<List<FinalExam>> getExams() async {
    try {
      var data = await (await MatrixOa.getInstance())!.examTable.getExams();
      if(data.isNotEmpty){
        await Global.localStorageService.saveToLocal(state.exams, "exams");
      } else{
        return await Global.localStorageService
            .loadFromLocal("exams", (json) => FinalExam.fromJson(json));
      }
      return data;
    } catch (e) {
      Get.snackbar("获取失败", "请刷新重试或检查网络连接! ");
      return await Global.localStorageService
          .loadFromLocal("exams", (json) => FinalExam.fromJson(json));
    }
  }

  Future<void> initExams() async {
    state.exams.value = await Global.localStorageService
        .loadFromLocal("exams", (json) => FinalExam.fromJson(json));
    Logger().i(state.exams);
    state.isLoading.value = false;
    state.exams.value = await getExams();
  }
}
