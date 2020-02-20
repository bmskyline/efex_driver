import 'dart:io';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderListProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  File _image;
  OrderListProvider(this._repo);
  String reason;

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

  Observable updateOrders(List<String> list, String reason) {
    String result = "[";
    for (int i = 0; i < list.length; i++) {
      if (i == list.length - 1) {
        result +=
            "{\"Trackingnumber\":\"${list[i]}\",\"Status\":\"picked\",\"Reason\":\"$reason\"}";
      } else {
        result +=
            "{\"Trackingnumber\":\"${list[i]}\",\"Status\":\"picked\",\"Reason\":\"$reason\"},";
      }
    }
    result += "]";
    return _repo
        .updateStatusList(image, result)
        .doOnData((r) {})
        .doOnListen(() => loading = true)
        .doOnDone(() => loading = false);
  }
}
