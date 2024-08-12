class UserManualResponsesModel {
  String? language;

  String? url;

  UserManualResponsesModel({
    this.language,
    this.url,
  });

  factory UserManualResponsesModel.fromJson(Map<String, dynamic> json) =>
      UserManualResponsesModel(
        language: json["language"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "language": language,
        "url": url,
      };
}
