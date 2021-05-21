class corCode {
  String maincode;
  String subcode;
  String codename;
  String codedetail;

  corCode({this.maincode, this.subcode, this.codename, this.codedetail});

  factory corCode.fromJson(Map<String, dynamic> json) {
    return corCode(
      maincode: json['maincode'] as String,
      subcode: json['subcode'] as String,
      codename: json['codename'] as String,
      codedetail: json['codedetail'] as String,
    );
  }
}
