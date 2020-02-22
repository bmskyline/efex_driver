import 'dart:io';

import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/repository.dart';
import 'package:driver_app/utils/shared_preferences_utils.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailProvider extends BaseProvider {
  final GithubRepo _repo;
  final SpUtil spUtil;
  bool _loading = false;
  File _image;
  String _selected;
  OrderDetailProvider(this._repo, this.spUtil);
  String cancelReason;
  String waitReason = "";
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


  String get selected => _selected;

  set selected(String value) {
    _selected = value;
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
