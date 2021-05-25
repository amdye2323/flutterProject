class BarcodeZone {
  String storageZoneBarcode;
  String storageZone;
  String useStatus;

  BarcodeZone({this.storageZoneBarcode, this.storageZone, this.useStatus});

  factory BarcodeZone.fromJson(Map<String, dynamic> json) {
    return BarcodeZone(
        storageZoneBarcode: json["storageZoneBarcode"] as String,
        storageZone: json["storageZone"] as String,
        useStatus: json["useStatus"] as String);
  }
}
