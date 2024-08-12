
class AuthModel {
  String? username;
  String? role;
  String? partner;
  String? password;

  AuthModel({
    this.username,
    this.role,
    this.partner,
    this.password,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    username: json["username"],
    role: json["role"],
    partner: json["partner"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "role": role,
    "partner": partner,
    "password": password,
  };
}