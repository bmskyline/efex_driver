import 'package:driver_app/utils/network_utils.dart';
import 'package:driver_app/utils/shared_preferences_utils.dart';
import 'package:rxdart/rxdart.dart';

import 'model/shop_model.dart';

class GithubService {
  Observable login(map) => post("user/login", map);
  Observable getShops(map) => post("tracking", map);
  Observable getShopDetail(map) => post("tracking/detail", map);
}

class GithubRepo {
  final GithubService _remote;
  final SpUtil _spUtil;

  GithubRepo(this._remote, this._spUtil);

  Observable login(String username, String password) {
    Map<String, String> someMap = {
    "username": username,
    "pw": password,
    };
    return _remote.login(someMap);
  }

  Observable getShops(int offset, int limit) {
    Map<String, dynamic> someMap = {
      "Offset": offset,
      "Limit": limit,
      "FromDate": "2020-01-13",
    };
    return _remote.getShops(someMap);
  }

  Observable getShopDetail(Shop shop) {
    Map<String, dynamic> someMap = {
      "FromAddress": shop.fromAddress,
      "FromPhone": shop.fromPhone,
      "FromName": shop.fromName,
      "FromDate": "2020-01-13",
      "Limit": 9,
      "Offset": 0,
    };
    return _remote.getShopDetail(someMap);
  }

  void saveToken(String token) {
    _spUtil.putString("TOKEN", token);
  }
}
