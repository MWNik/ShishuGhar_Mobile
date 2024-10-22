import 'package:shishughar/utils/globle_method.dart';

class PartnerStockModel {
  int? name;
  String? items;
  String? odia;
  String? hindi;
  String? stock_type;
  String? partner_id;
  String? item_required_per_child_per_months;
  int? is_active;
  int? seq_id;

  PartnerStockModel({
    this.name,
    this.hindi,
    this.is_active,
    this.items,
    this.odia,
    this.item_required_per_child_per_months,
    this.partner_id,
    this.seq_id,
    this.stock_type,
  });

  factory PartnerStockModel.fromJson(Map<String, dynamic> json) =>
      PartnerStockModel(
        name: json["name"],
        hindi: json["hindi"],
        odia: json["odia"],
        item_required_per_child_per_months:
            json["item_required_per_child_per_months"].toString(),
        items: json["items"],
        partner_id: json["partner_id"],
        is_active: json["is_active"],
        seq_id: json["seq_id"],
        stock_type: json["stock_type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "items": items,
        "odia": odia,
        "hindi": hindi,
        "partner_id": partner_id,
        "stock_type": stock_type,
        "item_required_per_child_per_months":
            item_required_per_child_per_months,
        "is_active": is_active,
        "seq_id": seq_id
      };
}
