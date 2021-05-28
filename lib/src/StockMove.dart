import 'dart:async';

import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/BarcodeZone.dart';

import '../DTO/skuInfo.dart';
import '../Home/HomeViewModel.dart';
import '../main.dart';

class StockMove extends StatefulWidget {
  const StockMove({Key key}) : super(key: key);

  @override
  _StockMoveState createState() => _StockMoveState();
}

class _StockMoveState extends State<StockMove> {
  //재고 바코드
  String _scanBarcode = "default";
  String _zoneBarcode = "default";
  String _firstRadio = "구역지정";
  String _bottomMent = "스캔 이후 체크해주세요";

  String qty = "";
  String oriQty = "";

  bool barcodeStatus = false;
  final _viewModel = HomeViewModel();
  final qtyController = TextEditingController();

  final Map<String, String> genderMap = {
    '구역지정': '구역지정',
    '거래선출고': '거래선출고',
    '피킹구역': '피킹구역',
  };

  int count = 0;
  Future<List<skuInfo>> skuDetail;
  Future<BarcodeZone> barZone;
  Future<String> result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    skuDetail = _viewModel.skuDetail(_scanBarcode);
    result = _viewModel.stockMoveToZone(_scanBarcode, _zoneBarcode, userId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void pageReset() {
    barcodeStatus = false;
    _scanBarcode = "default";
    _zoneBarcode = "default";
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    setState(() {
      skuDetail = _viewModel.skuDetail(_scanBarcode);
      result = _viewModel.stockMoveToZone(_scanBarcode, _zoneBarcode, userId);
      barZone = _viewModel.getBarcodeZone(_zoneBarcode);
    });
  }

  Future<void> stockMoveToZone(String dataQty) async {
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    String httpResult = "";
    switch (_firstRadio) {
      case "구역지정":
        httpResult = await _viewModel.stockMoveToZone(
            _scanBarcode, _zoneBarcode, userId);
        if (httpResult == "success") {
          showToastInstance("성공적으로 등록되었습니다.");
          setState(() {
            skuDetail = _viewModel.skuDetail(_scanBarcode);
          });
        } else {
          showToastInstance("정보를 다시 한번 확인해주세요");
        }
        return;
      case "거래선출고":
        httpResult =
            await _viewModel.stockMoveToCompany(_scanBarcode, userId, dataQty);
        if (httpResult == "success") {
          showToastInstance("성공적으로 등록되었습니다.");
        } else {
          showToastInstance("정보를 다시 한번 확인해주세요");
        }
        setState(() {
          skuDetail = _viewModel.skuDetail(_scanBarcode);
        });
        return;
      case "피킹구역":
        httpResult = await _viewModel.stockMoveToPickingZone(
            _scanBarcode, userId, dataQty);
        if (httpResult == "success") {
          showToastInstance("성공적으로 등록되었습니다.");
        } else {
          showToastInstance("정보를 다시 한번 확인해주세요");
        }
        setState(() {
          skuDetail = _viewModel.skuDetail(_scanBarcode);
        });
        return;
    }
  }

  void onActionSelected(String key) {
    setState(() {
      _firstRadio = key;
      switch (key) {
        case "구역지정":
          _bottomMent = "스캔 버튼을 누른 이후 체크해주세요.";
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', false, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (barcodeScanRes.length == 16) {
      setState(() {
        _scanBarcode = barcodeScanRes;
        skuDetail = _viewModel.skuDetail(_scanBarcode);
      });
    } else if (barcodeScanRes.length == 10) {
      setState(() {
        _zoneBarcode = barcodeScanRes;
        barZone = _viewModel.getBarcodeZone(_zoneBarcode);
      });
    } else {
      showToastInstance("바코드를 확안해주세요.");
    }

    // if (barcodeScanRes.length == 16) {
    //   if (barcodeStatus == false) {
    //     setState(() {
    //       _scanBarcode = barcodeScanRes;
    //       skuDetail = _viewModel.skuDetail(_scanBarcode);
    //       barcodeStatus = true;
    //     });
    //   } else {
    //     showToastInstance("대상지역을 스캔해주세요.");
    //   }
    // } else if (barcodeScanRes.length == 10) {
    //   if (barcodeStatus == true) {
    //     setState(() {
    //       _zoneBarcode = barcodeScanRes;
    //       barZone = _viewModel.getBarcodeZone(_zoneBarcode);
    //     });
    //   } else {
    //     showToastInstance("대상 지역이 아닙니다.");
    //   }
    // } else {
    //   showToastInstance("바코드를 확안해주세요.");
    // }
    if (!mounted) return;

    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    //   skuDetail = _viewModel.skuDetail(_scanBarcode);
    // });
  }

  /**
   * 수량
   */
  void qtyDialog(BuildContext context, String oriQty) {
    showDialog(
        context: context,
        barrierDismissible: false, //Dialog를 제외한 곳 터치시 x
        builder: (BuildContext context) {
          return AlertDialog(
            //RoundedRectangleBorder 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(
              "숫자를 입력해주세요",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color(0xFF527DAA)),
            ),
            content: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "전체 수량 : ${oriQty}",
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
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
                    stockMoveToZone(qtyController.text);
                    Navigator.pop(context);
                  },
                  child: Text("수정하기"))
            ],
          );
        });
  }

  Widget bottomNavi() {
    if (_firstRadio == "구역지정") {
      return FutureBuilder<BarcodeZone>(
          future: barZone,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                _bottomMent,
                style: TextStyle(fontSize: 20, color: Color(0xFF527DAA)),
              );
            } else if (snapshot.hasError) {
              return Text("에러입니다.");
            } else if (snapshot.hasData) {
              return Container(
                height: 250,
                child: SingleChildScrollView(
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      normalCard("${snapshot.data.storageZoneBarcode}",
                          CupertinoIcons.barcode),
                      normalCard("보관장소 : ${snapshot.data.storageZone}",
                          CupertinoIcons.eye_fill),
                      normalCard("장소상태 : ${snapshot.data.statusZone}",
                          CupertinoIcons.tag_fill),
                      ElevatedButton(
                          onPressed: () {
                            stockMoveToZone(oriQty);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                            Color(0xFF527DAA),
                          )),
                          child: Text(
                            "등록하기",
                            style: TextStyle(fontSize: 20.0),
                          )),
                      SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          });
    } else {
      return Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
              onPressed: () {
                qtyDialog(context, oriQty);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                Color(0xFF527DAA),
              )),
              child: Text(
                "등록하기",
                style: TextStyle(fontSize: 20.0),
              )),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            // backWallpaper(),
            Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                height: double.infinity,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Flex(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      direction: Axis.vertical,
                      children: <Widget>[
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
                                onPressed: scanBarcodeNormal,
                              );
                            } else if (snapshot.hasError) {
                              return Text("에러입니다.");
                            } else if (snapshot.hasData) {
                              oriQty = snapshot.data[0].qty;
                              return Container(
                                padding: EdgeInsets.all(30.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    normalTitle("스캔 재고"),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                        height: 250,
                                        child: SingleChildScrollView(
                                          child: Flex(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            direction: Axis.vertical,
                                            children: [
                                              normalCard(
                                                  "${snapshot.data[0].barcode}",
                                                  CupertinoIcons.barcode),
                                              normalCard(
                                                  "${snapshot.data[0].skuLabel}",
                                                  CupertinoIcons.cube_box_fill),
                                              normalCard(
                                                  "입고일 : " +
                                                      snapshot.data[0].ioDate,
                                                  CupertinoIcons.calendar),
                                              normalCard(
                                                  "재고 수량 : ${snapshot.data[0].qty}",
                                                  CupertinoIcons.number),
                                              normalCard(
                                                  "보관 장소 : ${snapshot.data[0].storageZone}",
                                                  CupertinoIcons.eye_fill),
                                            ],
                                          ),
                                        )),
                                    Icon(
                                      CupertinoIcons.arrowtriangle_down_fill,
                                      size: 40,
                                      color: Color(0xFF527DAA),
                                    ),
                                    // normalTitle("대상 구역"),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          CupertinoRadioChoice(
                                              notSelectedColor:
                                                  Color(0xFF527DAA),
                                              selectedColor: Colors.lightGreen,
                                              choices: genderMap,
                                              onChange: onActionSelected,
                                              initialKeyValue: _firstRadio),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    bottomNavi(),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ]),
                )),
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
                onPressed: pageReset,
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
                onPressed: () {
                  if (_firstRadio == "구역지정") {
                    stockMoveToZone(oriQty);
                  } else {
                    qtyDialog(context, oriQty);
                  }
                },
                child: Icon(
                  CupertinoIcons.check_mark,
                  color: Color(0xFF527DAA),
                ),
              ),
            ),
          ],
        );
      }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

final kLabelStyle = TextStyle(
  color: Color(0xFF527DAA),
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

Widget normalCard(String content, IconData ico) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: Card(
      // color: Color(0xFF527DAA),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          ico,
          color: Color(0xFF527DAA),
          size: 25,
        ),
        title: Text(
          content,
          style: kLabelStyle,
        ),
      ),
    ),
  );
}

Widget normalTitle(String content) {
  return Text(
    content,
    style: TextStyle(
      color: Color(0xFF527DAA),
      fontFamily: 'OpenSans',
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
  );
}
