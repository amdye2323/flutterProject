class barcodeInvoiceInfo {
  String result;
  String deliveryNumber;
  String operator;
  String createDate;

  barcodeInvoiceInfo(
      {this.result, this.deliveryNumber, this.operator, this.createDate});

  factory barcodeInvoiceInfo.fromJson(Map<String, dynamic> json) {
    return barcodeInvoiceInfo(
        result: json["result"] as String,
        deliveryNumber: json["deliveryNumber"] as String,
        operator: json["operator"] as String,
        createDate: json["createDate"] as String);
  }
}
