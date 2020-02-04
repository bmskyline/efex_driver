import 'dart:io';

import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderListProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  File _image;
  OrderListProvider(this._repo);

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

  Observable updateOrders(List<Order> list) {
    String result = "[";
    list.forEach((e) {
      result += "{\"Trackingnumber\":\"${e.trackingNumber}\",\"Status\":\"picked\",\"Reason\":\"picked\"}";
    });
    result +="]";
    print(result);
    return _repo.updateStatusList(image, result)
        .doOnData((r) {})
        .doOnListen(() => loading = true)
        .doOnDone(() => loading = false);
  }
}