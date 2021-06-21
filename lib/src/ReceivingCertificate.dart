import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/receivingItem.dart';
import 'package:testflutter/Home/HomeViewModel.dart';
import 'package:testflutter/src/Button/Align.dart';

import '../main.dart';
import 'MainPage.dart';

class ReceivingCertificate extends StatefulWidget {
  const ReceivingCertificate({Key key}) : super(key: key);

  @override
  _ReceivingCertificateState createState() => _ReceivingCertificateState();
}

class _ReceivingCertificateState extends State<ReceivingCertificate> {
  final _viewModel = HomeViewModel();
  final skuController = TextEditingController();
  final qtyController = TextEditingController();
  var userId = "";

  String _scanBarcode = "";
  // int PalletCount = 0;

  final _truckList = ["", "120T", "240T"];
  final _workingGubun = ["", "수작업", "컨테이너(수작업)", "파레트", "컨테이너(파레트)", "파레트&수작업"];

  String truck = "";
  String working = "";

  Future<List<receivingItem>> receivingItemList;
  // Future<List<Map<String, String>>> palletBarcodeList;
  Future<List<String>> palletList;
  Future<List<String>> zoneList;

  List _palletList = List<String>();
  String palletType = "";
  List _zoneList = List<String>();
  String zone = "";
  List<String> palletBarcodeList = List<String>();

  List<receivingItem> reList = List<receivingItem>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = Provider.of<UserModel>(context, listen: false).userId;
    receivingItemList = _viewModel.getReceivingItemList(userId, _scanBarcode);
    palletList = _viewModel.getPalletList();
    zoneList = _viewModel.getZoneList();
    callList();
  }

  void callList() async {
    _palletList = await palletList;
    _zoneList = await zoneList;
  }

  void certificateList() async {
    reList = await receivingItemList;
    for(var i= 0;i<reList){

    }
    setState(() {});
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', false, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (barcodeScanRes.length == 11) {
      setState(() {
        _scanBarcode = barcodeScanRes;
        receivingItemList =
            _viewModel.getReceivingItemList(userId, _scanBarcode);
        certificateList();
      });
    } else {
      showToastInstance("바코드를 확안해주세요.");
    }

    if (!mounted) return;
  }

  void addRow() {
    setState(() {
      reList.add(receivingItem(
          sku: "선택해주세요",
          palletType: "",
          qty: 0,
          palletBarcode: "",
          workingGubun: "",
          zoneBarcode: ""));
    });
  }

  void qtyDialog(BuildContext context, int oriQty, int index) {
    showDialog(
        context: context,
        barrierDismissible: false, //Dialog를 제외한 곳 터치시 x
        builder: (BuildContext context) {
          return AlertDialog(
            //RoundedRectangleBorder 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "숫자를 입력해주세요",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xFF527DAA)),
                ),
              ],
            ),
            content: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "원 수량 : ${oriQty}",
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp('[0-9]'))
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '수량',
                    ),
                    controller: qtyController,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      int newQty = int.parse(qtyController.text.toString());
                      reList[index].qty = newQty;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("등록하기")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("닫기")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: normalTitle("입 고 증"),
                        )),
                        SizedBox(
                          width: 30,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: _scanBarcode == ""
                                ? scanButton(scanBarcodeNormal, "바코드 스캔")
                                : barcodeName(
                                    context,
                                    _scanBarcode,
                                    Provider.of<UserModel>(context,
                                            listen: false)
                                        .userId)),
                      ],
                    ),
                  )),
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Color(0xFF527DAA), width: 2)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                      minWidth: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width * 1.2,
                    ),
                    child: Container(
                        child: reList.length == 0
                            ? Container(
                                alignment: Alignment.topCenter,
                                child: Text("리스트가 존재하지 않습니다, 바코드 스캔을 해주세요."),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: reList.length,
                                itemBuilder: (context, index) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            child: Text("${index + 1} 번째 "),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 10.0),
                                              child:
                                                  Text("${reList[index].sku}"),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              qtyDialog(context,
                                                  reList[index].qty, index);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 10.0),
                                              child:
                                                  Text("${reList[index].qty}"),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            child: DropdownButton(
                                              value: reList[index].palletType,
                                              items: _palletList.map((value) {
                                                return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value));
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  reList[index].palletType =
                                                      value;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            child: DropdownButton(
                                              value: reList[index].zoneBarcode,
                                              items: _zoneList.map((value) {
                                                return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value));
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  reList[index].zoneBarcode =
                                                      value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("차 종류"),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: DropdownButton(
                          value: truck,
                          items: _truckList.map((value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              truck = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      Container(
                        child: Text("작업 종류"),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: DropdownButton(
                          value: working,
                          items: _workingGubun.map((value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              working = value;
                            });
                          },
                        ),
                      ),
                    ],
                  )),
              // Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
        leftAlign(addRow, CupertinoIcons.refresh_bold, Alignment.bottomLeft),
        leftAlign(addRow, CupertinoIcons.check_mark, Alignment.bottomRight),
      ],
    );
  }
}

Widget barcodeName(BuildContext context, String barcode, String name) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("입고증 바코드 : [${barcode}]"),
        Text("유저 명 [ ${name} ]"),
      ],
    ),
  );
}
