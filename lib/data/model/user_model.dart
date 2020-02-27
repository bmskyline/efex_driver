class User {
  String email;
  String firstName;
  String lastName;

  User({
    this.email,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"] == null ? null : json["email"],
        firstName: json["firstname"] == null ? null : json["firstname"],
        lastName: json["lastname"] == null ? null : json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "email": email == null ? null : email,
        "firstname": firstName == null ? null : firstName,
        "lastname": lastName == null ? null : lastName,
      };
}
