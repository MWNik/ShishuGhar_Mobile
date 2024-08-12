class TabState {
  int? name;
  String? stateCode;
  String? value;
  String? state_od;
  String? state_hi;

  TabState({
    this.name,
    this.stateCode,
    this.value,
    this.state_od,
    this.state_hi,
  });

  factory TabState.fromJson(Map<String, dynamic> json) => TabState(
        name: json["name"],
        stateCode: json["state_code"],
        value: json["value"],
    state_od: json["state_od"],
    state_hi: json["state_hi"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "state_code": stateCode,
        "value": value,
        "state_od": state_od,
        "state_hi": state_hi,
      };
}
