import 'package:dio/dio.dart';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/shop_model.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class CancelProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  List<Shop> _response = List();

  CancelProvider(this._repo);

  List<Shop> get response => _response;
  set response(List<Shop> response) {
    _response = response;
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Observable getUsers() => _repo
      .getUsers()
      .doOnData((r) => _response.addAll((r as List).map((user) => Shop.fromJson(user)).toList()))
      .doOnError((e, stacktrace) {
        if (e is DioError) {
          response = null;
        }
      })
      .doOnListen(() => loading = true)
      .doOnDone(() => loading = false);
}
