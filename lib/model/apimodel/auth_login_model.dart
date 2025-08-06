 import 'package:shishughar/model/apimodel/mapping_login_model.dart';

class Auth {
  String? apiKey;
  String? apiSecret;
  String? username;
  String? role;
  List<Mapping>? mapping;
  String? partner;
  String? mobile_no;
  String? AppDeviceId;
  int? isDeviceChanged;
  int? houseHoldNumber;
  String? backDateDataEntry;
  int? max_allow_range;

  Auth({
    this.apiKey,
    this.apiSecret,
    this.username,
    this.role,
    this.mapping,
    this.partner,
    this.mobile_no,
    this.isDeviceChanged,
    this.houseHoldNumber,
    this.backDateDataEntry,
    this.max_allow_range
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
      isDeviceChanged: json["is_device_changed"],
      houseHoldNumber: json["household"],
      backDateDataEntry: json["Back_data_entry_date"],
    max_allow_range: json["max_allow_range"],
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
        "is_device_changed": isDeviceChanged,
        "household": houseHoldNumber,
        "Back_data_entry_date": backDateDataEntry,
        "max_allow_range": max_allow_range
      };
}
