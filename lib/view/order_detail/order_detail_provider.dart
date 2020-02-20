import 'dart:io';

import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  File _image;
  String _selectedPick = "picking_fail";
  String _selectedReturn = "return_fail";
  OrderDetailProvider(this._repo);
  String cancelReason;
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


  String get selectedPick => _selectedPick;

  set selectedPick(String value) {
    _selectedPick = value;
    notifyListeners();
  }

  String get selectedReturn => _selectedReturn;

  set selectedReturn(String value) {
    _selectedReturn = value;
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
