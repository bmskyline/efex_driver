import 'package:driver_app/data/model/login_data.dart';

class LoginResponse {
  bool result;
  String msg;
  LoginData data;

  LoginResponse({
    this.result,
    this.msg,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        result: json["result"] == null ? null : json["result"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : LoginData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data.toJson(),
      };
}
