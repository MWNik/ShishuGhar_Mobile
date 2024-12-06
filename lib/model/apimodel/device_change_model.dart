class DeviceChangeModel {
  String? message;
  String? homePage;
  String? fullName;
  StatusCode? statusCode;

  DeviceChangeModel({
    this.message,
    this.homePage,
    this.fullName,
    this.statusCode,
  });

  // Factory method to create an instance from JSON
  factory DeviceChangeModel.fromJson(Map<String, dynamic> json) {
    return DeviceChangeModel(
      message: json['message'],
      homePage: json['home_page'],
      fullName: json['full_name'],
      statusCode: json['status code'] != null
          ? StatusCode.fromJson(json['status code'])
          : null,
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'home_page': homePage,
      'full_name': fullName,
      'status code': statusCode?.toJson(),
    };
  }
}

class StatusCode {
  int? statusCode;
  String? message;

  StatusCode({
    this.statusCode,
    this.message,
  });

  // Factory method to create an instance from JSON
  factory StatusCode.fromJson(Map<String, dynamic> json) {
    return StatusCode(
      statusCode: json['status code'],
      message: json['message'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status code': statusCode,
      'message': message,
    };
  }
}
