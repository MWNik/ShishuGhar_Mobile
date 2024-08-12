import 'package:shishughar/model/apimodel/mapping_login_model.dart';

class Auth {
  String? apiKey;
  String? apiSecret;
  String? username;
  String? role;
  List<Mapping>? mapping;
  String? partner;
  String? mobile_no;

  Auth({
    this.apiKey,
    this.apiSecret,
    this.username,
    this.role,
    this.mapping,
    this.partner,
    this.mobile_no,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        apiKey: json["api_key"],
        apiSecret: json["api_secret"],
        username: json["username"],
        role: json["role"],
        mobile_no: json["mobile_no"],
        mapping: json["mapping"] == null
            ? []
            : List<Mapping>.from(
                json["mapping"]!.map((x) => Mapping.fromJson(x))),
        partner: json["partner"],
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "api_secret": apiSecret,
        "username": username,
        "role": role,
        "mobile_no": mobile_no,
        "mapping": mapping == null
            ? []
            : List<dynamic>.from(mapping!.map((x) => x.toJson())),
        "partner": partner,
      };
}
