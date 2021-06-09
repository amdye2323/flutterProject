class barcodeHistoryInfo {
  String barcode;
  String sku;
  String skuLabel;
  String corCode;
  String corName;
  String qty;
  String ioGubun;
  String storageZone;
  String remark;
  String createDate;

  barcodeHistoryInfo(
      {this.barcode,
      this.sku,
      this.skuLabel,
      this.corCode,
      this.corName,
      this.qty,
      this.ioGubun,
      this.storageZone,
      this.remark,
      this.createDate});

  factory barcodeHistoryInfo.fromJson(Map<String, dynamic> json) {
    return barcodeHistoryInfo(
      barcode: json["barcode"] as String,
      sku: json["sku"] as String,
      skuLabel: json["skuLabel"] as String,
      corCode: json["corCode"] as String,
      corName: json["corName"] as String,
      qty: json["qty"] as String,
      ioGubun: json["ioGubun"] as String,
      storageZone: json["storageZone"] as String,
      remark: json["remark"] as String,
      createDate: json["createDate"] as String,
    );
  }
}
