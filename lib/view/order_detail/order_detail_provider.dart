import 'dart:io';

import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  File _image;
  String _selectedText = "picking_fail";
  OrderDetailProvider(this._repo);
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

  String get selectedText => _selectedText;

  set selectedText(String value) {
    _selectedText = value;
    notifyListeners();
  }

  Observable updateOrder(String number, String status, String reason) {
    return _repo
        .updateStatus(image, number, status, reason)
        .doOnData((r) {})
        .doOnListen(() => loading = true)
        .doOnDone(() => loading = false);
  }
}
