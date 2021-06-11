class BarcodeZone {
  String storageZoneBarcode;
  String statusZone;
  String storageZone;
  List<String> skuList;

  BarcodeZone(
      {this.storageZoneBarcode,
      this.statusZone,
      this.storageZone,
      this.skuList});

  factory BarcodeZone.fromJson(Map<String, dynamic> json) {
    return BarcodeZone(
        storageZoneBarcode: json["storageZoneBarcode"] as String,
        statusZone: json["statusZone"] as String,
        storageZone: json["storageZone"] as String,
        skuList: json["skuList"] as List<String>);
  }
}
