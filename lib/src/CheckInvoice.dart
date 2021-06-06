import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/barcodeCheckList.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../main.dart';

class CheckInvoice extends StatefulWidget {
  const CheckInvoice({Key key}) : super(key: key);

  @override
  _CheckInvoiceState createState() => _CheckInvoiceState();
}

class _CheckInvoiceState extends State<CheckInvoice> {
  String _checkBarcode = "";
  List<String> _checkBarcodeList = List<String>();
  final _viewModel = HomeViewModel();
  Future<List<String>> barcodeCorList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // barcodeCorList = getResultCorcodeList();
  }

  void addList() {
    setState(() {});
  }

  void deleteItemList(int index) {
    _checkBarcodeList.removeAt(index);
    setState(() {});
  }

  void reset() {
    _checkBarcodeList.clear();
    setState(() {});
  }

  Future<List<barcodeCheckList>> getResultCorcodeList() async {
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    return await _viewModel.getResultCorcodeList(_checkBarcodeList, userId);
  }

  void FlutterDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false, //Dialog를 제외한 곳 터치시 x
        builder: (BuildContext context) {
          return AlertDialog(
            //RoundedRectangleBorder 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Column(
              children: <Widget>[Text("등록 결과")],
            ),
            content: Container(
              height: 300,
              width: 300,
              child: FutureBuilder<List<barcodeCheckList>>(
                future: getResultCorcodeList(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("데이터가 없습니다");
                  } else if (snapshot.hasError) {
                    return Text("에러입니다.");
                  } else if (snapshot.hasData) {
                    return Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Expanded(
                          child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GridTileBar(
                                  subtitle: Text(
                                    "${snapshot.data[index].barcode}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                  title: Text(
                                    "${snapshot.data[index].checkResult}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("확인"))
            ],
          );
        });
  }

  Future<void> startBarcodeScanStream() async {
    String barcodeScanRes;
    try {
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
              "#ff6666", "Cancel", false, ScanMode.BARCODE)
          .listen((barcode) {
        int barcodeSize = barcode.toString().length;
        if (_checkBarcode != barcode && barcodeSize == 23) {
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
          int listCount = 0;
          if (_checkBarcodeList != null) {
            _checkBarcodeList.forEach((element) {
              if (element == _checkBarcode) {
                listCount++;
              }
            });
            if (listCount == 0) {
              _checkBarcodeList.add(_checkBarcode);
              addList();
            }
          } else {
            _checkBarcodeList.add(_checkBarcode);
            addList();
          }
        }
      });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                ),
                Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.vertical,
                    children: <Widget>[
                      SizedBox(
                        height: 60.0,
                      ),
                      Container(
                        child: _checkBarcodeList.length == 0
                            ? ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                  Color(0xFF527DAA),
                                )),
                                onPressed: () => startBarcodeScanStream(),
                                child: Text(
                                  '송장번호 체크',
                                  style: TextStyle(color: Colors.white),
                                ))
                            : Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "송장 번호 리스트",
                                    style: TextStyle(
                                        color: Color(0xFF527DAA),
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "현재 [${_checkBarcodeList.length}] 스캔",
                                    style: TextStyle(
                                        color: Color(0xFF527DAA),
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 4.0),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              child: GridTileBar(
                                backgroundColor: Colors.lightBlue,
                                leading: Icon(CupertinoIcons.barcode),
                                title: Text(
                                  "${_checkBarcodeList[index]}",
                                  textAlign: TextAlign.center,
                                ),
                                trailing: IconButton(
                                  onPressed: () => deleteItemList(index),
                                  icon: Icon(CupertinoIcons.delete),
                                ),
                              ),
                            );
                          },
                          itemCount: _checkBarcodeList.length,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            );
          }),
          floatingActionButton: SpeedDial(
            backgroundColor: Color(0xFF527DAA),
            icon: CupertinoIcons.circle_grid_3x3,
            children: [
              SpeedDialChild(
                  backgroundColor: Color(0xFF527DAA),
                  onTap: () {
                    startBarcodeScanStream();
                  },
                  child: Icon(CupertinoIcons.camera)),
              SpeedDialChild(
                  backgroundColor: Color(0xFF527DAA),
                  onTap: () {
                    FlutterDialog(context);
                  },
                  child: Icon(CupertinoIcons.search)),
              SpeedDialChild(
                  backgroundColor: Color(0xFF527DAA),
                  onTap: () {
                    reset();
                  },
                  child: Icon(CupertinoIcons.trash)),
            ],
          )),
    );
  }
}
