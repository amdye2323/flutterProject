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
  final qtyController = TextEditingController();
  var userId = "";

  String _scanBarcode = "";
  // int PalletCount = 0;

  final _truckList = ["20T", "40T"];
  String truck = "20T";

  Future<List<receivingItem>> receivingItemList;
  Future<List<Map<String, String>>> palletBarcodeList;
  Future<List<String>> palletList;
  Future<List<String>> zoneList;

  List _palletList = List<String>();
  String palletType = "";
  List _zoneList = List<String>();
  String zone = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = Provider.of<UserModel>(context, listen: false).userId;
    receivingItemList = _viewModel.getReceivingItemList(userId, _scanBarcode);
    palletList = _viewModel.getPalletList();
    zoneList = _viewModel.getZoneList();
  }

  void callList() async {
    _palletList = await palletList;
    _zoneList = await palletList;
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
      });
    } else {
      showToastInstance("바코드를 확안해주세요.");
    }

    if (!mounted) return;
  }

  void reCall() {}

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
                        Container(child: normalTitle("입 고 증")),
                        SizedBox(
                          width: 30,
                        ),
                        _scanBarcode == ""
                            ? scanButton(scanBarcodeNormal, "바코드 스캔")
                            : barcodeName(
                                context,
                                _scanBarcode,
                                Provider.of<UserModel>(context, listen: false)
                                    .userId)
                      ],
                    ),
                  )),
              Expanded(
                flex: 6,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Color(0xFF527DAA), width: 2)),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                              minWidth: MediaQuery.of(context).size.width,
                              maxHeight: MediaQuery.of(context).size.height,
                              maxWidth: MediaQuery.of(context).size.width * 1.2,
                            ),
                            child: FutureBuilder(
                              future: receivingItemList,
                              builder: (BuildContext context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text("데이터가 없습니다."),
                                  );
                                } else if (snapshot.hasError) {
                                  return Container(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  // PalletCount = snapshot.data[0].palletCount;
                                  callList();
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0),
                                                child: Text(
                                                    "${snapshot.data[index].sku}"),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0),
                                                child: Text(
                                                    "${snapshot.data[index].qty}"),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0),
                                                child: DropdownButton(
                                                  value: truck,
                                                  items:
                                                      _truckList.map((value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value));
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      truck = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0),
                                                child: DropdownButton(
                                                  value: palletType,
                                                  items:
                                                      _palletList.map((value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value));
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      palletType = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0),
                                                child: DropdownButton(
                                                  value: zone,
                                                  items: _zoneList.map((value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value));
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      zone = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              snapshot.data[index]
                                                          .checkButton ==
                                                      'false'
                                                  ? ElevatedButton(
                                                      onPressed: () {},
                                                      child: Text("확인"))
                                                  : SizedBox(
                                                      width: 20.0,
                                                    ),
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  return Container(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        ))),
              ),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
        leftAlign(reCall, CupertinoIcons.refresh_bold, Alignment.bottomLeft),
        leftAlign(reCall, CupertinoIcons.check_mark, Alignment.bottomRight),
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
        Text(barcode),
        Text(name),
      ],
    ),
  );
}
