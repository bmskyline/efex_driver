import 'package:dio/dio.dart';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/shop_detail_data.dart';
import 'package:driver_app/data/model/shop_detail_response.dart';
import 'package:driver_app/data/model/shop_model.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class DetailProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  ShopDetailData _response;
  String date = "2020-01-15";
  int limit = 100;
  int page = 0;

  DetailProvider(this._repo);

  ShopDetailData get response {
    return _response;
  }

  set response(ShopDetailData response) {
    _response = response;
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Observable getShopDetail(Shop shop, String status, int type) => _repo
      .getShopDetail(shop, date, limit, page, status, type)
      .doOnData((r) {
        ShopDetailResponse response = ShopDetailResponse.fromJson(r);
        if(response.result) {
          _response = response.data;
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
