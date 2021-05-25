class barcodeCheckList {
  String barcode;
  String checkResult;

  barcodeCheckList({this.barcode, this.checkResult});

  factory barcodeCheckList.fromJson(Map<String, dynamic> json) {
    return barcodeCheckList(
      barcode: json["barcode"] as String,
      checkResult: json["checkResult"] as String,
    );
  }
}
