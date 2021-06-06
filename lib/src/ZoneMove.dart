import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/BarcodeZone.dart';
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

  Future<List<skuInfo>> skuDetail;
  Future<BarcodeZone> barZone;

  String _zoneScanBarcode = "default"; //처음 바코드
  String _zoneBarcode = "default"; //대상 바코드
  bool _scanCheck = false;
  String qty = ""; //입력 재고
  String oriQty = ""; //현 재고
  String _firstRadio = "구역지정";
  String _bottomMent = "여기를 눌러 스캔해주세요.";
  String selectTapBarcode = "";

  final qtyController = TextEditingController();

  final Map<String, String> genderMap = {
    '구역지정': '구역지정',
    '거래선출고': '거래선출고',
    '피킹구역': '피킹구역',
    '분할등록': '분할등록'
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    skuDetail = _viewModel.barcodeSkuList(_zoneScanBarcode);
    barZone = _viewModel.getBarcodeZone(_zoneBarcode);
  }

  void pageReset() {
    _scanCheck = false;
    _zoneScanBarcode = "default";
    _zoneBarcode = "default";
    _bottomMent = "여기를 눌러 스캔해주세요.";
    selectTapBarcode = "";
    qty = ""; //입력 재고
    oriQty = ""; //현 재고
    setState(() {
      skuDetail = _viewModel.barcodeSkuList(_zoneScanBarcode);
      barZone = _viewModel.getBarcodeZone(_zoneBarcode);
    });
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

    if (barcodeScanRes.length == 10 && _scanCheck == false) {
      setState(() {
        _zoneScanBarcode = barcodeScanRes;
        skuDetail = _viewModel.barcodeSkuList(_zoneScanBarcode);
        _scanCheck = true;
      });
    } else if (barcodeScanRes.length == 10 && _scanCheck == true) {
      if (_zoneScanBarcode == barcodeScanRes) {
        showToastInstance("같은 구역을 설정하셨습니다.");
      } else {
        setState(() {
          _zoneBarcode = barcodeScanRes;
          barZone = _viewModel.getBarcodeZone(_zoneBarcode);
        });
      }
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
          _bottomMent = "여기를 눌러 스캔해주세요.";
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

  Future<void> stockMoveToZone(String dataQty) async {
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    String httpResult = "";
    switch (_firstRadio) {
      case "구역지정":
        httpResult = await _viewModel.stockMoveToZone(
            selectTapBarcode, _zoneBarcode, userId);
        if (httpResult == "success") {
          showToastInstance("성공적으로 등록되었습니다.");
          setState(() {
            skuDetail = _viewModel.barcodeSkuList(_zoneScanBarcode);
          });
        } else {
          showToastInstance("정보를 다시 한번 확인해주세요");
        }
        return;
      case "거래선출고":
        httpResult = await _viewModel.stockMoveToCompany(
            selectTapBarcode, userId, dataQty, oriQty);
        if (httpResult == "success") {
          showToastInstance("성공적으로 등록되었습니다.");
        } else {
          showToastInstance("정보를 다시 한번 확인해주세요");
        }
        setState(() {
          skuDetail = _viewModel.barcodeSkuList(_zoneScanBarcode);
        });
        return;
      case "피킹구역":
        httpResult = await _viewModel.stockMoveToPickingZone(
            selectTapBarcode, userId, dataQty, oriQty);
        if (httpResult == "success") {
          showToastInstance("성공적으로 등록되었습니다.");
        } else {
          showToastInstance("정보를 다시 한번 확인해주세요");
        }
        setState(() {
          skuDetail = _viewModel.barcodeSkuList(_zoneScanBarcode);
        });
        return;
      case "분할등록":
        httpResult = await _viewModel.stockMoveDivision(
            _zoneBarcode, _zoneBarcode, userId, dataQty, oriQty, "");
        if (httpResult == "success") {
          showToastInstance("성공적으로 등록되었습니다.");
        } else {
          showToastInstance("정보를 다시 한번 확인해주세요");
        }
        setState(() {
          skuDetail = _viewModel.skuDetail(_zoneBarcode);
        });
        return;
    }
  }

  void qtyDialog(BuildContext context, String oriQty) {
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
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.trash,
                      color: Color(0xFF527DAA),
                    ),
                  ),
                )
              ],
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
                    stockMoveToZone(qtyController.text);
                    Navigator.pop(context);
                  },
                  child: Text("수정하기"))
            ],
          );
        });
  }

  Widget bottomNavi() {
    if (_firstRadio == "구역지정" || _firstRadio == "분할등록") {
      return FutureBuilder<BarcodeZone>(
          future: barZone,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextButton(
                    onPressed: () {
                      scanBarcodeNormal();
                    },
                    child: Text(
                      _bottomMent,
                      style: TextStyle(fontSize: 20, color: Color(0xFF527DAA)),
                    )),
              );
            } else if (snapshot.hasError) {
              return Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text("에러입니다"),
              );
            } else if (snapshot.hasData) {
              return Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.rectangle_fill_on_rectangle_fill,
                          color: Color(0xFF527DAA),
                        ),
                        title: Text(
                          "${snapshot.data.storageZone}",
                          style: kLabelStyle,
                        ),
                        subtitle: Text(
                          "${snapshot.data.statusZone}",
                          style: kLabelStyle,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${snapshot.data.storageZoneBarcode}",
                            style: kLabelStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      )
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
            Container(
              color: Color(0xFF527DAA),
            ),
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
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("구역 바코드 리스트",
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF527DAA))),
                          SizedBox(
                            height: 20.0,
                          ),
                          FutureBuilder<List<skuInfo>>(
                              future: skuDetail,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                      height: 250,
                                      child: IconButton(
                                        color: Color(0xFF527DAA),
                                        icon: Icon(
                                            CupertinoIcons.add_circled_solid),
                                        iconSize: 30,
                                        onPressed: scanBarcodeNormal,
                                      ));
                                } else if (snapshot.hasError) {
                                  return Container(
                                    height: 220,
                                    child: Text("에러입니다."),
                                  );
                                } else if (snapshot.hasData) {
                                  return Container(
                                    height: 220,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          Text(
                                            "${snapshot.data[0].storageZone}",
                                            style: kLabelStyle,
                                          ),
                                          Container(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapshot.data.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Card(
                                                      // color: Color(0xFF527DAA),
                                                      color: selectTapBarcode ==
                                                              '${snapshot.data[index].barcode}'
                                                          ? Colors.white30
                                                          : Colors.white,
                                                      child: ListTile(
                                                        key: ValueKey(snapshot
                                                            .data[index].sku),
                                                        onTap: () {
                                                          setState(() {
                                                            selectTapBarcode =
                                                                "${snapshot.data[index].barcode}";
                                                            oriQty =
                                                                "${snapshot.data[index].qty} ";
                                                          });
                                                        },
                                                        leading: Icon(
                                                          CupertinoIcons
                                                              .barcode,
                                                          color:
                                                              Color(0xFF527DAA),
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
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              CupertinoRadioChoice(
                                  notSelectedColor: Colors.black45,
                                  selectedColor: Colors.blueAccent,
                                  choices: genderMap,
                                  onChange: onActionSelected,
                                  initialKeyValue: _firstRadio),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 15.0,
                    ),
                    bottomNavi(),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  scanBarcodeNormal();
                },
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
    );
  }
}

final kLabelStyle = TextStyle(
  color: Color(0xFF527DAA),
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);
