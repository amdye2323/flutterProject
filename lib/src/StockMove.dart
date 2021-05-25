import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String _bb = "";
  bool barcodeStatus = false;
  final _viewModel = HomeViewModel();
  final qtyController = TextEditingController();

  int count = 0;
  Future<List<skuInfo>> skuDetail;
  Future<BarcodeZone> barZone;
  Future<String> result;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    skuDetail = _viewModel.skuDetail(_scanBarcode);
    result = _viewModel.stockMoveToZone(_scanBarcode, _zoneBarcode, userId);
  }

  void pageReset() {
    barcodeStatus = false;
    _scanBarcode = "default";
    _zoneBarcode = "default";
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    setState(() {
      skuDetail = _viewModel.skuDetail(_scanBarcode);
      result = _viewModel.stockMoveToZone(_scanBarcode, _zoneBarcode, userId);
    });
  }

  Future<void> stockMoveToZone() async {
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    String result =
        await _viewModel.stockMoveToZone(_scanBarcode, _zoneBarcode, userId);
    if (result == "success") {
      showToastInstance("성공적으로 등록되었습니다.");
    } else {
      showToastInstance("정보를 다시 한번 확인해주세요");
    }
  }

  Future<void> startBarcodeScanStream() async {
    String barcodeScanRes;
    try {
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
              "#ff6666", "Cancel", false, ScanMode.BARCODE)
          .listen((barcode) {
        int barcodeSize = barcode.toString().length;
        _bb = barcode;
        Future<void> del(String bb) async {
          await Future.delayed(Duration(milliseconds: 1000), () {
            if (_bb == bb) {
              barcodeScanRes = bb;
              if (barcodeScanRes.length == 16) {
                if (barcodeStatus == false) {
                  setState(() {
                    _scanBarcode = barcodeScanRes;
                    skuDetail = _viewModel.skuDetail(_scanBarcode);
                    barcodeStatus = true;
                  });
                } else {
                  _scanBarcode = "default";
                  _zoneBarcode = "default";
                  showToastInstance("대상지역을 스캔해주세요.");
                }
              } else if (barcodeScanRes.length == 10) {
                if (barcodeStatus == true) {
                  setState(() {
                    _zoneBarcode = barcodeScanRes;
                    barZone = _viewModel.getBarcodeZone(_zoneBarcode);
                  });
                } else {
                  showToastInstance("대상 지역이 아닙니다.");
                  _scanBarcode = "default";
                  _zoneBarcode = "default";
                }
              } else {
                _scanBarcode = "default";
                _zoneBarcode = "default";
                showToastInstance("바코드를 확안해주세요.");
              }
              // If the widget was removed from the tree while the asynchronous platform
              // message was in flight, we want to discard the reply rather than calling
              // setState to update our non-existent appearance.
              if (!mounted) return;
            }
          });
        }

        del(_bb);
      });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
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
    _bb = barcodeScanRes;

    if (barcodeScanRes.length == 16) {
      if (barcodeStatus == false) {
        setState(() {
          _scanBarcode = barcodeScanRes;
          skuDetail = _viewModel.skuDetail(_scanBarcode);
          barcodeStatus = true;
        });
      } else {
        showToastInstance("대상지역을 스캔해주세요.");
      }
    } else if (barcodeScanRes.length == 10) {
      if (barcodeStatus == true) {
        setState(() {
          _zoneBarcode = barcodeScanRes;
          barZone = _viewModel.getBarcodeZone(_zoneBarcode);
        });
      } else {
        showToastInstance("대상 지역이 아닙니다.");
      }
    } else {
      showToastInstance("바코드를 확안해주세요.");
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    //   skuDetail = _viewModel.skuDetail(_scanBarcode);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            backWallpaper(),
            Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                height: double.infinity,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Flex(
                      mainAxisAlignment: MainAxisAlignment.center,
                      direction: Axis.vertical,
                      children: <Widget>[
                        FutureBuilder<List<skuInfo>>(
                          future: skuDetail,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text(
                                "스캔 버튼을 눌러주세요",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              );
                            } else if (snapshot.hasError) {
                              return Text("에러입니다.");
                            } else if (snapshot.hasData) {
                              return Container(
                                padding: EdgeInsets.all(30.0),
                                child: Column(
                                  children: [
                                    normalTitle("대상 재고"),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    normalCard("${snapshot.data[0].barcode}",
                                        CupertinoIcons.barcode),
                                    normalCard("${snapshot.data[0].skuLabel}",
                                        CupertinoIcons.cube_box_fill),
                                    normalCard(
                                        "입고일 : " + snapshot.data[0].ioDate,
                                        CupertinoIcons.calendar),
                                    normalCard("수량 : " + snapshot.data[0].qty,
                                        CupertinoIcons.number),
                                    normalCard(
                                        "${snapshot.data[0].storageZone}",
                                        CupertinoIcons.eye_fill),
                                    Icon(
                                      CupertinoIcons.arrowtriangle_down_fill,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    normalTitle("대상 구역"),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    FutureBuilder<BarcodeZone>(
                                        future: barZone,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Text(
                                              "스캔 버튼을 눌러주세요",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text("에러입니다.");
                                          } else if (snapshot.hasData) {
                                            return Container(
                                              child: Column(
                                                children: [
                                                  normalCard(
                                                      "${snapshot.data.storageZoneBarcode}",
                                                      CupertinoIcons.barcode),
                                                  normalCard(
                                                      "${snapshot.data.storageZone}",
                                                      CupertinoIcons.tag_fill),
                                                  normalCard(
                                                      "${snapshot.data.useStatus}",
                                                      CupertinoIcons.eye_fill),
                                                  SizedBox(
                                                    height: 20.0,
                                                  )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        }),
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
                onPressed: startBarcodeScanStream,
                child: Icon(
                  CupertinoIcons.barcode,
                  color: Colors.blue,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: pageReset,
                child: Icon(
                  CupertinoIcons.arrow_up_bin,
                  color: Colors.blue,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: stockMoveToZone,
                child: Icon(
                  CupertinoIcons.check_mark,
                  color: Colors.blue,
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
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

Widget normalCard(String content, IconData ico) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: Card(
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          ico,
          color: Colors.blue,
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
      color: Colors.white,
      fontFamily: 'OpenSans',
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

showToastInstance(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.yellowAccent,
      textColor: Colors.black87,
      fontSize: 16);
}
