import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'DTO/skuInfo.dart';
import 'Home/HomeViewModel.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key key}) : super(key: key);
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String _scanBarcode = "default";
  String _checkBarcode = "";
  final _viewModel = HomeViewModel();
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
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
    });
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
      _viewModel.skuDetail(_scanBarcode);
    });
  }

  Widget _detailView(skuInfo _skuInfo) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_skuInfo.sku ?? ''),
          Text(_skuInfo.corCode ?? ''),
          Text(_skuInfo.skuLabel ?? ''),
        ],
      ),
    );
  }

  Widget _errorView(String errorMessage) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage ?? ''),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode scan')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start QR scan')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text('Start barcode scan stream')),
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20)),
                        FutureBuilder<skuInfo>(
                            future: _viewModel.skuDetail(_scanBarcode),
                            builder:
                                (context, AsyncSnapshot<skuInfo> snapshot) {
                              if (snapshot.hasData) {
                                return _detailView(snapshot.data);
                              } else if (snapshot.hasError) {
                                return _errorView("error");
                              } else {
                                return Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                            }),
                        FlatButton(
                            onPressed: () {
                              _viewModel.skuDetail(_scanBarcode);
                            },
                            child: Text("push" ?? '')),
                      ]));
            })));
  }
}
