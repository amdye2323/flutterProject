import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../DTO/skuInfo.dart';
import '../Home/HomeViewModel.dart';

class StockMove extends StatefulWidget {
  const StockMove({Key key}) : super(key: key);
  @override
  _StockMoveState createState() => _StockMoveState();
}

class _StockMoveState extends State<StockMove> {
  String _scanBarcode = "default";
  String _checkBarcode = "";
  final _viewModel = HomeViewModel();
  final qtyController = TextEditingController();

  int count = 0;
  Future<List<skuInfo>> skuDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    skuDetail = _viewModel.skuDetail(_scanBarcode);
  }

  Future<void> startBarcodeScanStream() async {
    String barcodeScanRes;
    try {
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
              "#ff6666", "Cancel", false, ScanMode.BARCODE)
          .listen((barcode) {
        int barcodeSize = barcode.toString().length;
        print(barcodeSize);
        if (_checkBarcode != barcode && barcodeSize == 8) {
          FlutterBeep.beep();
          Fluttertoast.showToast(
              msg: "${barcode}가 등록되었습니다.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white60,
              textColor: Colors.black,
              fontSize: 16);
          _checkBarcode = barcode;
        }
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
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      skuDetail = _viewModel.skuDetail(_scanBarcode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('바코드 업무')),
      body: Builder(builder: (BuildContext context) {
        return Container(
            alignment: Alignment.center,
            child: Flex(direction: Axis.vertical, children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              FutureBuilder<List<skuInfo>>(
                future: skuDetail,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("데이터가 없습니다");
                  } else if (snapshot.hasError) {
                    return Text("에러입니다.");
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                            color: Colors.blue,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 25.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(CupertinoIcons.bookmark),
                                  title:
                                      Text("${snapshot.data[index].skuLabel}"),
                                  subtitle:
                                      Text("수량 : ${snapshot.data[index].qty}"),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "누르기",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ));
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ]));
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: IconButton(
        onPressed: scanBarcodeNormal,
        icon: Icon(CupertinoIcons.camera_fill),
      )),
    );
  }
}
