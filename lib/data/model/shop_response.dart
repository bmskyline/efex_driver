import 'package:driver_app/data/model/shop_data.dart';

class ShopResponse {
  bool result;
  String msg;
  ShopData data;

  ShopResponse({
    this.result,
    this.msg,
    this.data,
  });

  factory ShopResponse.fromJson(Map<String, dynamic> json) => ShopResponse(
        result: json["result"] == null ? null : json["result"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : ShopData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
      };
}
