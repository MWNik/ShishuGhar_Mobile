class TabSocialCategoryModel {
  int? name;
  String? value;

  TabSocialCategoryModel({
    this.name,
    this.value,
  });

  factory TabSocialCategoryModel.fromJson(Map<String, dynamic> json) =>
      TabSocialCategoryModel(
        name: json["name"],
        value: json["social_category_name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "social_category_name": value,
      };
}
