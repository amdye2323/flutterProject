class skuInfo {
  String sku;
  String corCode;
  String skuLabel;
  String qty;

  skuInfo({this.sku, this.corCode, this.skuLabel, this.qty});

  factory skuInfo.fromJson(Map<String, dynamic> json) {
    return skuInfo(
        sku: json["sku"] as String,
        corCode: json["corCode"] as String,
        skuLabel: json["skuLabel"] as String,
        qty: json["qty"] as String);
  }
}
