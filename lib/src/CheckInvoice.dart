import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/barcodeCheckList.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../main.dart';
import 'MainPage.dart';

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

  final Map<String, String> header = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> addList(String barcode) async {
    setState(() {
      _checkBarcodeList.add(barcode);
    });
  }

  void deleteItemList(int index) {
    setState(() {
      _checkBarcodeList.removeAt(index);
    });
  }

  void reset() {
    setState(() {
      _checkBarcodeList.clear();
    });
  }

  void sendMessageInvoice() {
    var userId = Provider.of<UserModel>(context, listen: false).userId;
    var map = {'message': '송장 등록', 'userId': userId};
    String body = jsonEncode(map);
    // stompClient.send(destination: '/app/send', body: body, headers: header);
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
                    sendMessageInvoice();
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
                  child: Text("확인")),
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
              addList(_checkBarcode);
            }
          } else {
            addList(_checkBarcode);
          }
        }
      });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  SingleChildScrollView dataGrid(List<String> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            sortColumnIndex: 0,
            columns: [
              DataColumn(
                  label: Text("결과"), numeric: false, tooltip: "createDate"),
            ],
            rows: list
                .map(
                  (info) => DataRow(cells: <DataCell>[
                    DataCell(
                      Text(
                        "${info}",
                      ),
                    ),
                  ]),
                )
                .toList(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
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
                                    ),
                                  ],
                                ),
                        ),
                        Container(
                            height: 500, child: dataGrid(_checkBarcodeList))
                      ],
                    ),
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: startBarcodeScanStream,
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
                  onPressed: reset,
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
                    MainFulPageState.of(context).sendMessage("송장이 등록되었습니다.");
                    FlutterDialog(context);
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
      ),
    );
  }
}
