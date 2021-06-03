class skuZoneList {
  String storageZoneBarcode;
  String qty;
  String storageZone;

  skuZoneList({this.storageZoneBarcode, this.qty, this.storageZone});

  factory skuZoneList.fromJson(Map<String, dynamic> json) {
    return skuZoneList(
        storageZoneBarcode: json["storageZoneBarcode"] as String,
        qty: json["qty"] as String,
        storageZone: json["storageZone"] as String);
  }
}
