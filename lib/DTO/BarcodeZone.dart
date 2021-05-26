class BarcodeZone {
  String storageZoneBarcode;
  String statusZone;
  String storageZone;

  BarcodeZone({this.storageZoneBarcode, this.statusZone, this.storageZone});

  factory BarcodeZone.fromJson(Map<String, dynamic> json) {
    return BarcodeZone(
        storageZoneBarcode: json["storageZoneBarcode"] as String,
        statusZone: json["statusZone"] as String,
        storageZone: json["storageZone"] as String);
  }
}
