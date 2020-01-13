import 'package:dio/dio.dart';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/shop_detail_model.dart';
import 'package:driver_app/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class DetailProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  ShopDetail _response;

  DetailProvider(this._repo);

  ShopDetail get response {
    return _response;
  }
  set response(ShopDetail response) {
    _response = response;
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Observable getShopDetail() => _repo
      .getShopDetail()
      .doOnData((r){
        _response = ShopDetail.fromJson(r);
      }
  )
      .doOnError((e, stacktrace) {
    if (e is DioError) {
      //response = null;
    }
  })
      .doOnListen(() => loading = true)
      .doOnDone(() => loading = false);
}
