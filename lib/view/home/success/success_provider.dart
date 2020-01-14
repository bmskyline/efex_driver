import 'package:dio/dio.dart';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/shop_response.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class SuccessProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  ShopResponse _response;

  SuccessProvider(this._repo);

  ShopResponse get response => _response;
  set response(ShopResponse response) {
    _response = response;
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Observable getShops() => _repo
      .getShops(0, 9)
      .doOnData((r) => _response = ShopResponse.fromJson(r))
      .doOnError((e, stacktrace) {
        if (e is DioError) {
          response = null;
        }
      })
      .doOnListen(() => loading = true)
      .doOnDone(() => loading = false);
}
