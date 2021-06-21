class receivingItem {
  String sku;
  int qty;
  String palletBarcode;
  String zoneBarcode;
  String palletType;
  String workingGubun;

  receivingItem(
      {this.sku,
      this.qty,
      this.palletBarcode,
      this.zoneBarcode,
      this.palletType,
      this.workingGubun});

  factory receivingItem.fromJson(Map<String, dynamic> json) {
    return receivingItem(
      sku: json["sku"] as String,
      qty: json["qty"] as int,
      palletBarcode: json["palletBarcode"] as String,
      zoneBarcode: json["zoneBarcode"] as String,
      palletType: json["palletType"] as String,
      workingGubun: json["workingGubun"] as String,
    );
  }
}
