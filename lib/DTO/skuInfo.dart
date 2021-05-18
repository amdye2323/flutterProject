class skuInfo {
  final String sku;
  final String corCode;
  final String skuLabel;

  skuInfo({this.sku,this.corCode,this.skuLabel});

  factory skuInfo.fromJson(Map<String,dynamic> json){
    return skuInfo(
      sku : json["sku"] as String,
      corCode : json["corCode"] as String,
      skuLabel : json["skuLabel"] as String,
    );
  }
}