
class SupervisorModel {
  int? name;
  String? email;
  String? full_name;

  SupervisorModel({
    this.name,
    this.email,
    this.full_name,
  });

  factory SupervisorModel.fromJson(Map<String, dynamic> json) => SupervisorModel(
    name: json["name"],
    email: json["email"],
    full_name: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "full_name": full_name,
  };
}