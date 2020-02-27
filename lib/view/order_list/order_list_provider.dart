import 'dart:io';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/repository.dart';
import 'package:driver_app/utils/shared_preferences_utils.dart';
import 'package:rxdart/rxdart.dart';

class OrderListProvider extends BaseProvider {
  final GithubRepo _repo;
  final SpUtil spUtil;
  bool _loading = false;
  File _image;
  OrderListProvider(this._repo, this.spUtil);
  String reason = "";

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  File get image => _image;

  set image(File value) {
    _image = value;
    notifyListeners();
  }

  Observable updateOrders(List<String> list, String reason, int type, String name) {
    String result = "[";
    for (int i = 0; i < list.length; i++) {
      String res = reason.isNotEmpty
          ? reason
          : (type == 1
          ? "Nhân viên giao nhận ${spUtil.getString("USER")} đã lấy thành công đơn hàng ${list[i]} tại shop ${name}"
          : "Nhân viên giao nhận ${spUtil.getString("USER")} đã trả thành công đơn hàng ${list[i]} tại shop ${name}");
      if (i == list.length - 1) {
        result +=
            "{\"Trackingnumber\":\"${list[i]}\",\"Status\":\"picked\",\"Reason\":\"$res\"}";
      } else {
        result +=
            "{\"Trackingnumber\":\"${list[i]}\",\"Status\":\"picked\",\"Reason\":\"$res\"},";
      }
    }
    result += "]";
    print(result);
    return _repo
        .updateStatusList(image, result)
        .doOnData((r) {})
        .doOnListen(() => loading = true)
        .doOnDone(() => loading = false);
  }
}
