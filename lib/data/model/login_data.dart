class LoginData {
  String token;

  LoginData({
    this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    token: json["token"] == null ? null : json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token == null ? null : token,
  };
  
}
