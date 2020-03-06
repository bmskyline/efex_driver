import 'package:dio/dio.dart';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/data/model/shop_detail_response.dart';
import 'package:driver_app/data/model/shop_model.dart';
import 'package:driver_app/data/repository.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class DetailProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  int limit = 200;
  int page = 0;
  int total = 0;
  List<Order> orders = List();

  DetailProvider(this._repo);

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Observable getShopDetail(String id, String status, int type) => _repo
      .getShopDetail(id, limit, page, status, type)
      .doOnData((r) {
        ShopDetailResponse response = ShopDetailResponse.fromJson(r);
        if (response.result) {
          page++;
          total = response.data.total;
          orders.addAll(response.data.orders);
          notifyListeners();
        }
      })
      .doOnError((e, stacktrace) {
        if (e is DioError) {
          //response = null;
        }
      })
      .doOnListen(() => loading = true)
      .doOnDone(() => loading = false);

  Observable updateStatus(String number, String status, String reason) =>
      _repo.updateStatus(null, number, status, reason).doOnData((r) {});
}
