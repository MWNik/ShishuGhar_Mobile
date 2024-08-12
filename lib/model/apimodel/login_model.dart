// To parse this JSON data, do
//
//     final loginApiModel = loginApiModelFromJson(jsonString);

import 'dart:convert';

import 'package:shishughar/model/apimodel/auth_login_model.dart';

LoginApiModel loginApiModelFromJson(String str) =>
    LoginApiModel.fromJson(json.decode(str));

String loginApiModelToJson(LoginApiModel data) => json.encode(data.toJson());

class LoginApiModel {
  String? message;
  String? homePage;
  String? fullName;
  Auth? auth;

  LoginApiModel({
    this.message,
    this.homePage,
    this.fullName,
    this.auth,
  });

  factory LoginApiModel.fromJson(Map<String, dynamic> json) => LoginApiModel(
    message: json["message"],
    homePage: json["home_page"],
    fullName: json["full_name"],
    auth: json["auth"] == null ? null : Auth.fromJson(json["auth"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "home_page": homePage,
    "full_name": fullName,
    "auth": auth?.toJson(),
  };
}




