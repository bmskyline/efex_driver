import 'package:driver_app/data/model/user_model.dart';

class LoginData {
  String token;
  User user;

  LoginData({this.token, this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        token: json["token"] == null ? null : json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
      };
}
