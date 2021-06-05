class pickZoneInfo {
  String sku;
  String skuLabel;
  String qty;
  String remark;
  String updateDate;

  pickZoneInfo(
      {this.sku, this.skuLabel, this.qty, this.remark, this.updateDate});

  factory pickZoneInfo.fromJson(Map<String, dynamic> json) {
    return pickZoneInfo(
        sku: json["sku"] as String,
        skuLabel: json["skuLabel"] as String,
        qty: json["qty"] as String,
        remark: json["remark"] as String,
        updateDate: json["updateDate"] as String);
  }
}
