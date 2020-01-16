import 'package:dio/dio.dart';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/shop_model.dart';
import 'package:driver_app/data/model/shop_response.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class PickupProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  List<Shop> _shops = List();
  int page = 0;
  int limit = 10;
  int total = 0;
  PickupProvider(this._repo);

  List<Shop> get shops => _shops;

  set shops(List<Shop> value) {
    _shops = value;
  }

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Observable getShops() => _repo
      .getShops(page, limit)
      .doOnData((r) {
        ShopResponse response = ShopResponse.fromJson(r);
        if (response.result) {
          page++;
          total = response.data.total;
          _shops.addAll(response.data.shops);
        }
      })
      .doOnError((e, stacktrace) {
        if (e is DioError) {
          //response = null;
        }
      })
      .doOnListen(() => loading = true)
      .doOnDone(() => loading = false);
}
