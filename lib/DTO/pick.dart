class pickVO {
  String pickingDate;
  String corCode;
  String step;

  pickVO({this.pickingDate, this.corCode, this.step});

  factory pickVO.fromJson(Map<String, dynamic> json) {
    return pickVO(
        pickingDate: json['id'], corCode: json['corCode'], step: json['step']);
  }
}
