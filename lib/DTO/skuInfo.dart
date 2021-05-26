class skuInfo {
  String barcode;
  String sku;
  String corCode;
  String skuLabel;
  String qty;
  String ioDate;
  String storageZone;

  skuInfo(
      {this.barcode,
      this.sku,
      this.corCode,
      this.skuLabel,
      this.qty,
      this.ioDate,
      this.storageZone});

  factory skuInfo.fromJson(Map<String, dynamic> json) {
    return skuInfo(
      barcode: json["barcode"] as String,
      sku: json["sku"] as String,
      corCode: json["corCode"] as String,
      skuLabel: json["skuLabel"] as String,
      qty: json["qty"] as String,
      ioDate: json["ioDate"] as String,
      storageZone: json["storageZone"] as String,
    );
  }
}
