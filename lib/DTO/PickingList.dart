class PickingList {
  String bin;
  String productDivisionName;
  String skuId;
  String skuName;
  int cnt;
  int cnt2;
  int availableStock;
  int totCnt;

  PickingList(
      {this.bin,
      this.productDivisionName,
      this.skuId,
      this.skuName,
      this.cnt,
      this.cnt2,
      this.availableStock,
      this.totCnt});

  factory PickingList.fromJson(Map<String, dynamic> json) {
    return PickingList(
      bin: json['bin'] as String,
      productDivisionName: json['productDivisionName'] as String,
      skuId: json['skuId'] as String,
      skuName: json['skuName'] as String,
      cnt: json['cnt'] as int,
      cnt2: json['cnt2'] as int,
      availableStock: json['availableStock'] as int,
      totCnt: json['totCnt'] as int,
    );
  }
}
