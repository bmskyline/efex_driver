import 'package:dio/dio.dart';
import 'package:driver_app/base/base.dart';
import 'package:driver_app/data/model/login_response.dart';
import 'package:driver_app/data/model/shop_model.dart';
import 'package:driver_app/data/model/shop_response.dart';
import 'package:driver_app/data/model/status.dart';
import 'package:driver_app/data/repository.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class HomeProvider extends BaseProvider {
  final GithubRepo _repo;
  int _currentIndex = 0;
  bool _loadingNew = false;
  bool _loadingNewReturn = false;
  bool _loadingWait = false;
  bool _loadingWaitReturn = false;
  bool _loadingSuccess = false;
  bool _loadingSuccessReturn = false;
  bool _loadingCancel = false;
  bool _loadingCancelReturn = false;
  List<Shop> shopsNew = List();
  List<Shop> shopsNewReturn = List();
  List<Shop> shopsWait = List();
  List<Shop> shopsWaitReturn = List();
  List<Shop> shopsSuccess = List();
  List<Shop> shopsSuccessReturn = List();
  List<Shop> shopsCancel = List();
  List<Shop> shopsCancelReturn = List();
  int pageNew = 0;
  int pageNewReturn = 0;
  int totalNew = 0;
  int totalNewReturn = 0;
  int pageWait = 0;
  int pageWaitReturn = 0;
  int totalWait = 0;
  int totalWaitReturn = 0;
  int pageSuccess = 0;
  int pageSuccessReturn = 0;
  int totalSuccess = 0;
  int totalSuccessReturn = 0;
  int pageCancel = 0;
  int pageCancelReturn = 0;
  int totalCancel = 0;
  int totalCancelReturn = 0;
  int limit = 10;
  HomeProvider(this._repo);

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  bool get loadingNew => _loadingNew;

  set loadingNew(bool value) {
    _loadingNew = value;
    notifyListeners();
  }


  bool get loadingWait => _loadingWait;

  set loadingWait(bool value) {
    _loadingWait = value;
    notifyListeners();
  }

  bool get loadingWaitReturn => _loadingWaitReturn;

  set loadingWaitReturn(bool value) {
    _loadingWaitReturn = value;
    notifyListeners();
  }

  bool get loadingSuccess => _loadingSuccess;

  set loadingSuccess(bool value) {
    _loadingSuccess = value;
    notifyListeners();
  }

  bool get loadingCancel => _loadingCancel;

  set loadingCancel(bool value) {
    _loadingCancel = value;
    notifyListeners();
  }

  bool get loadingNewReturn => _loadingNewReturn;

  set loadingNewReturn(bool value) {
    _loadingNewReturn = value;
    notifyListeners();
  }

  bool get loadingSuccessReturn => _loadingSuccessReturn;

  set loadingSuccessReturn(bool value) {
    _loadingSuccessReturn = value;
    notifyListeners();
  }

  bool get loadingCancelReturn => _loadingCancelReturn;

  set loadingCancelReturn(bool value) {
    _loadingCancelReturn = value;
    notifyListeners();
  }

  Observable getShops(String status, int type, bool isRefresh) {
    int page = 0;
    switch (status) {
      case "new":
        if (type == 1)
          page = pageNew;
        else
          page = pageNewReturn;
        break;
      case "wait_picking":
        page = pageWait;
        break;
      case "wait_return":
          page = pageWaitReturn;
        break;
      case "picked":
        if (type == 1)
          page = pageSuccess;
        else
          page = pageSuccessReturn;
        break;
      case "fail":
        if (type == 1)
          page = pageCancel;
        else
          page = pageCancelReturn;
        break;
    }
    return _repo.getShops(page, limit, getDate(), status, type).doOnData((r) {
      ShopResponse response = ShopResponse.fromJson(r);
      if (response.result) {
        switch (status) {
          case "new":
            if (type == 1) {
              pageNew++;
              totalNew = response.data.total;
              shopsNew.addAll(response.data.shops);
            } else {
              pageNewReturn++;
              totalNewReturn = response.data.total;
              shopsNewReturn.addAll(response.data.shops);
            }
            break;
          case "wait_picking":
            pageWait++;
            totalWait = response.data.total;
            shopsWait.addAll(response.data.shops);
            break;
          case "wait_return":
            pageWaitReturn++;
            totalWaitReturn = response.data.total;
            shopsWaitReturn.addAll(response.data.shops);
            break;
          case "picked":
            if (type == 1) {
              pageSuccess++;
              totalSuccess = response.data.total;
              shopsSuccess.addAll(response.data.shops);
            } else {
              pageSuccessReturn++;
              totalSuccessReturn = response.data.total;
              shopsSuccessReturn.addAll(response.data.shops);
            }
            break;
          case "fail":
            if (type == 1) {
              pageCancel++;
              totalCancel = response.data.total;
              shopsCancel.addAll(response.data.shops);
            } else {
              pageCancelReturn++;
              totalCancelReturn = response.data.total;
              shopsCancelReturn.addAll(response.data.shops);
            }
            break;
        }
      }
    }).doOnError((e, stacktrace) {
      if (e is DioError) {
        //response = null;
      }
    }).doOnListen(() {
      switch (status) {
        case "new":
          if(!isRefresh) {
            if (type == 1)
              loadingNew = true;
            else
              loadingNewReturn = true;
          }
          break;
        case "wait_picking":
          if(!isRefresh)
            loadingWait = true;
          break;
        case "wait_return":
          if(!isRefresh)
            loadingWaitReturn = true;
          break;
        case "picked":
          if(!isRefresh) {
            if (type == 1)
              loadingSuccess = true;
            else
              loadingSuccessReturn = true;
          }
          break;
        case "fail":
          if(!isRefresh) {
            if (type == 1)
              loadingCancel = true;
            else
              loadingCancelReturn = true;
          }
          break;
      }
    }).doOnDone(() {
      switch (status) {
        case "new":
          if (type == 1)
            loadingNew = false;
          else
            loadingNewReturn = false;
          break;
        case "wait_picking":
          loadingWait = false;
          break;
        case "wait_return":
          loadingWaitReturn = false;
          break;
        case "picked":
          if (type == 1)
            loadingSuccess = false;
          else
            loadingSuccessReturn = false;
          break;
        case "fail":
          if (type == 1)
            loadingCancel = false;
          else
            loadingCancelReturn = false;
          break;
      }
    });
  }

  Observable turnOnShop(List<Status> list, int type) => _repo
      .updateStatusList(null, statusToJson(list))
      .doOnData((r) {})
      .doOnError((e, stacktrace) {
        if (e is DioError) {
          //response = null;
        }
      })
      .doOnListen(() => type == 1 ? loadingNew = true : loadingNewReturn = true)
      .doOnDone(
          () => type == 1 ? loadingNew = false : loadingNewReturn = false);

  Observable getShopDetail(Shop shop, String status, int type) => _repo
      .getShopDetail(shop, getDate(), 1, 0, status, type)
      .doOnData((r) {})
      .doOnError((e, stacktrace) {
        if (e is DioError) {
          //response = null;
        }
      })
      .doOnListen(() => type == 1 ? loadingNew = true : loadingNewReturn = true)
      .doOnDone(
          () => type == 1 ? loadingNew = false : loadingNewReturn = false);

  Observable logout() => _repo.logout().doOnData((r) {
        LoginResponse res = LoginResponse.fromJson(r);
        if (res.result) {
          _repo.removeToken();
        }
      });
}
