class skuZoneList {
  String storageMaterialBarcode;
  String storageZoneBarcode;
  String qty;
  String storageZone;

  skuZoneList(
      {this.storageMaterialBarcode,
      this.storageZoneBarcode,
      this.qty,
      this.storageZone});

  factory skuZoneList.fromJson(Map<String, dynamic> json) {
    return skuZoneList(
        storageMaterialBarcode: json["storageMaterialBarcode"] as String,
        storageZoneBarcode: json["storageZoneBarcode"] as String,
        qty: json["qty"] as String,
        storageZone: json["storageZone"] as String);
  }
}
