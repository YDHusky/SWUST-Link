import 'package:get/get.dart';
import 'package:swust_link/common/entity/duifene/paper.dart';

import 'package:swust_link/spider/duifene.dart';

class DuifenePaperState {
  final RxList<Paper> papers = <Paper>[].obs;
  final isShowComplete = false.obs;
  final isLoading = true.obs;
}
