import 'dart:io';

import 'package:dio/dio.dart';
import 'package:driver_app/utils/network_utils.dart';
import 'package:driver_app/utils/shared_preferences_utils.dart';
import 'package:rxdart/rxdart.dart';

import 'model/shop_model.dart';

class GithubService {
  Observable login(map) => post("user/login", map);
  Observable logout(map) => post("user/logoff", map);
  Observable getShops(map) => post("https://apimobiletest.efex.vn/api/v2/tracking", map);
  Observable getShopDetail(map) => post("https://apimobiletest.efex.vn/api/v2/tracking/detail", map);
  Observable updateStatusList(map) => post("tracking/status/list", map);
  Observable updateStatus(map) => post("tracking/status", map);
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

  Observable logout() {
    Map<String, String> someMap = {"x-token": _spUtil.getString("TOKEN")};
    return _remote.logout(someMap);
  }

  Observable getShops(
      int offset, int limit, String status, int type) {
    Map<String, dynamic> someMap = {
      "Offset": offset*limit,
      "Limit": limit,
      "Status": status,
      "Type": type
    };
    return _remote.getShops(someMap);
  }

  Observable getShopDetail(String id, int limit, int offset, String status, int type) {
    Map<String, dynamic> someMap = {
      "ShopID": id,
      "Limit": limit,
      "Offset": offset*limit,
      "Status": status,
      "Type": type
    };
    return _remote.getShopDetail(someMap);
  }

  Observable updateStatus(
      File image, String number, String status, String reason) {
    FormData formData = FormData.from({
      "Trackingnumber": number,
      "Status": status,
      "Reason": reason,
      "Img": image == null ? null : UploadFileInfo(image, "image")
    });
    return _remote.updateStatus(formData);
  }

  Observable updateStatusList(File image, String list) {
    FormData formData = FormData.from({
      "Trackings": list,
      "Img": image == null ? null : UploadFileInfo(image, "image")
    });
    return _remote.updateStatusList(formData);
  }

  void saveToken(String token, String name) {
    _spUtil.putString("TOKEN", token);
    _spUtil.putString("USER", name);
  }

  void removeToken() {
    _spUtil.clear();
  }
}
