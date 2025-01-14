import 'package:swust_link/spider/duifene.dart';
import 'package:swust_link/spider/oa_auth.dart';
import 'package:swust_link/spider/baidu_trans.dart';

class Account {
  String username;
  String password;
  int platformCode;

  Account(this.username, this.password, this.platformCode);

  Future<bool> testLogin() async {
    if (platformCode == 0) {
      var oa = OAAuth(service: "http://soa.swust.edu.cn/", username: username, password: password);
      return oa.login();
    } else if (platformCode == 1) {
      var duifene = DuiFenE(username: username, password: password);
      return duifene.passwordLogin();
    }else if (platformCode == 2) {
      var baiduTrans = BaiduTrans(appID: username, key: password);
      return baiduTrans.connect();
    } else {
      return true;
    }
  }
}

enum Platform {
  OA(0, "一站式大厅"),
  DUIFENE(1, "对分易"),
  BAIDU(2, "百度翻译开放平台");

  final int code;
  final String des;

  const Platform(this.code, this.des);
}
