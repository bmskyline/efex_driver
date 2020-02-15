import 'package:driver_app/data/model/shop_detail_data.dart';

class ShopDetailResponse {
  bool result;
  String msg;
  ShopDetailData data;

  ShopDetailResponse({
    this.result,
    this.msg,
    this.data,
  });

  factory ShopDetailResponse.fromJson(Map<String, dynamic> json) => ShopDetailResponse(
    result: json["result"] == null ? null : json["result"],
    msg: json["msg"] == null ? null : json["msg"],
    data: json["data"] == null ? null : ShopDetailData.fromJson(json["data"]),
  );
}