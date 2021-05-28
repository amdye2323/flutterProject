import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:testflutter/DTO/skuInfo.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../main.dart';

class ZoneMove extends StatefulWidget {
  const ZoneMove({Key key}) : super(key: key);

  @override
  _ZoneMoveState createState() => _ZoneMoveState();
}

class _ZoneMoveState extends State<ZoneMove> {
  final _viewModel = HomeViewModel();
  final qtyController = TextEditingController();
  Future<List<skuInfo>> skuDetail;

  String _scanBarcode = "default"; //처음 바코드
  String _zoneBarcode = "default"; //대상 바코드
  String qty = ""; //입력 재고
  String oriQty = ""; //현 재고
  String _firstRadio = "구역지정";
  String _bottomMent = "스캔 이후 체크해주세요";

  final Map<String, String> genderMap = {
    '구역지정': '구역지정',
    '거래선출고': '거래선출고',
    '피킹구역': '피킹구역',
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    skuDetail = _viewModel.barcodeSkuList(_scanBarcode);
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', false, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (barcodeScanRes.length == 10) {
      setState(() {
        _scanBarcode = barcodeScanRes;
        skuDetail = _viewModel.barcodeSkuList(_scanBarcode);
      });
    } else {
      showToastInstance("바코드를 확안해주세요.");
    }

    if (!mounted) return;
  }

  void onActionSelected(String key) {
    setState(() {
      _firstRadio = key;
      switch (key) {
        case "구역지정":
          _bottomMent = "스캔 이후 체크해주세요";
          return;
        case "거래선출고":
          _bottomMent = "거래선 선택 이후 체크해주세요";
          return;
        case "피킹구역":
          _bottomMent = "체크버튼을 눌러주세요.";
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          height: double.infinity,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.vertical,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Text("구역 바코드 리스트",
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF527DAA))),
                FutureBuilder<List<skuInfo>>(
                    future: skuDetail,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return TextButton(
                          child: Text(
                            "Please Your Material Barcode",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF527DAA),
                                decoration: TextDecoration.underline),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("에러입니다.");
                      } else if (snapshot.hasData) {
                        return Container(
                          height: 300,
                          child: SingleChildScrollView(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Card(
                                      // color: Color(0xFF527DAA),
                                      color: Colors.white,
                                      child: ListTile(
                                        key: ValueKey(snapshot.data[index].sku),
                                        onTap: () {},
                                        leading: Icon(
                                          CupertinoIcons.barcode,
                                          color: Color(0xFF527DAA),
                                          size: 25,
                                        ),
                                        title: Text(
                                          "${snapshot.data[index].barcode}",
                                          style: kLabelStyle,
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data[index].skuLabel} [${snapshot.data[index].qty}]",
                                          style: kLabelStyle,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
                Icon(
                  CupertinoIcons.arrowtriangle_down_fill,
                  size: 40,
                  color: Color(0xFF527DAA),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      CupertinoRadioChoice(
                          notSelectedColor: Color(0xFF527DAA),
                          selectedColor: Colors.lightGreen,
                          choices: genderMap,
                          onChange: onActionSelected,
                          initialKeyValue: _firstRadio),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: scanBarcodeNormal,
            child: Icon(
              CupertinoIcons.barcode,
              color: Color(0xFF527DAA),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {},
            child: Icon(
              CupertinoIcons.arrow_uturn_left,
              color: Color(0xFF527DAA),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {},
            child: Icon(
              CupertinoIcons.check_mark,
              color: Color(0xFF527DAA),
            ),
          ),
        ),
      ],
    );
  }
}

final kLabelStyle = TextStyle(
  color: Color(0xFF527DAA),
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);
