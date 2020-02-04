import 'package:dio/dio.dart';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/shop_model.dart';
import 'package:driver_app/data/model/shop_response.dart';
import 'package:driver_app/data/model/status.dart';
import 'package:driver_app/data/repository.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class PickupProvider extends BaseProvider {
  final GithubRepo _repo;
  bool _loading = false;
  List<Shop> _shopsNew = List();
  List<Shop> _shopsSuccess = List();
  List<Shop> _shopsCancel = List();
  int pageNew = 0;
  int totalNew = 0;
  int pageSuccess = 0;
  int totalSuccess = 0;
  int pageCancel = 0;
  int totalCancel = 0;
  int limit = 10;
  PickupProvider(this._repo);

  List<Shop> get shopsNew => _shopsNew;

  set shopsNew(List<Shop> value) {
    _shopsNew = value;
  }

  List<Shop> get shopsSuccess => _shopsSuccess;

  set shopsSuccess(List<Shop> value) {
    _shopsSuccess = value;
  }

  List<Shop> get shopsCancel => _shopsCancel;

  set shopsCancel(List<Shop> value) {
    _shopsCancel = value;
  }

  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Observable getShops(String status) {
    int page = 0;
    if (status == "new")
      page = pageNew;
    else if (status == "picked")
      page = pageSuccess;
    else
      page = pageCancel;
    return _repo
        .getShops(page, limit, getDate(), status, 1)
        .doOnData((r) {
          ShopResponse response = ShopResponse.fromJson(r);
          if (response.result) {
            if (status == "new") {
              pageNew++;
              totalNew = response.data.total;
              _shopsNew.addAll(response.data.shops);
            } else if (status == "picked") {
              pageSuccess++;
              totalSuccess = response.data.total;
              _shopsSuccess.addAll(response.data.shops);
            } else {
              pageCancel++;
              totalCancel = response.data.total;
              _shopsCancel.addAll(response.data.shops);
            }
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

  Observable updateStatus(Shop shop) {
    List<Status> list = List();
    return _repo.updateStatusList(null, statusToJson(list)).doOnData((r) {});
  }
}
