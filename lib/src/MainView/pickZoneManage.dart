import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:testflutter/DTO/pickZoneInfo.dart';
import 'package:testflutter/DTO/skuZoneList.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../../main.dart';

class pickZoneManageFul extends StatefulWidget {
  const pickZoneManageFul({Key key}) : super(key: key);

  @override
  _pickZoneManageFulState createState() => _pickZoneManageFulState();
}

class _pickZoneManageFulState extends State<pickZoneManageFul> {
  String corCode = "";
  String corCodeName = "업체선택";
  String userId = "";

  final _viewModel = HomeViewModel();
  final qtyController = TextEditingController();
  static final storage = FlutterSecureStorage();

  Future<List<Map<String, String>>> corList;
  Future<List<pickZoneInfo>> pickList;
  Future<List<skuZoneList>> zoneList;

  void initState() {
    super.initState();
    corList = _viewModel.getCorCode();

    pickList = _viewModel.getCompanyPickingZoneInquiry(corCode);
  }

  Future deleteSecureDate(String key) async {
    var deleteData = await storage.delete(key: key);
    return deleteData;
  }

  Future<void> revertPickZoneMaterial(
      String barcode, String sku, String qty, String oriQty) async {
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    String result = await _viewModel.revertPickZoneMaterial(
        barcode, sku, qty, oriQty, userId);
    if (result == "success") {
      showToastInstance("성공적으로 등록되었습니다.");
      zoneList = _viewModel.getSkuZoneList(sku);
      pickList = _viewModel.getCompanyPickingZoneInquiry(corCode);
    } else {
      showToastInstance("정보를 다시 확인해주세요.");
      zoneList = _viewModel.getSkuZoneList(sku);
      pickList = _viewModel.getCompanyPickingZoneInquiry(corCode);
    }
  }

  /**
   * 업체 선택
   */
  Widget corCodeSelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 50,
          decoration: kBoxDecorationStyle,
          transformAlignment: Alignment.center,
          child: FutureBuilder(
              future: corList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SmartSelect<String>.single(
                      title: corCodeName,
                      modalType: S2ModalType.bottomSheet,
                      tileBuilder: (context, state) {
                        return S2Tile.fromState(
                          state,
                          title: Text(corCodeName,
                              style: TextStyle(color: Color(0xFF527DAA))),
                        );
                      },
                      choiceItems: S2Choice.listFrom(
                        source: snapshot.data,
                        value: (index, item) => item['value'],
                        title: (index, item) => item['title'],
                      ),
                      onChange: (state) {
                        setState(() {
                          corCode = state.value;
                          corCodeName = state.valueTitle;
                          pickList =
                              _viewModel.getCompanyPickingZoneInquiry(corCode);
                        });
                      });
                } else if (snapshot.hasError) {
                  return Text("업체가 존재하지 않습니다.");
                }
                return CircularProgressIndicator();
              }),
        ),
      ],
    );
  }

  void skuDialog(BuildContext context, String oriQty, String sku) async {
    zoneList = _viewModel.getSkuZoneList(sku);
    String selectedTapBarcode = "";
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Container(
              alignment: Alignment.center,
              height: 60,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("SKU : ${sku}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("갯수 [${oriQty}] "),
                          Container(
                              height: 30,
                              width: 100,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter(
                                      RegExp('[0-9]'))
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '수량만 입력가능합니다',
                                ),
                                controller: qtyController,
                              )),
                        ],
                      )
                    ],
                  )),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 300,
                  width: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: zoneList,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("데이터가 없습니다.");
                              } else if (snapshot.hasError) {
                                return Text("데이터가 없습니다.");
                              } else if (snapshot.hasData) {
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        color: selectedTapBarcode ==
                                                '${snapshot.data[index].storageMaterialBarcode}'
                                            ? Colors.white30
                                            : Colors.white,
                                        child: ListTile(
                                          key: ValueKey(snapshot.data[index]
                                              .storageMaterialBarcode),
                                          onTap: () {
                                            setState(() {
                                              selectedTapBarcode = snapshot
                                                  .data[index]
                                                  .storageMaterialBarcode;
                                            });
                                          },
                                          title: Text(
                                              "${snapshot.data[index].storageZone}[${snapshot.data[index].qty} 개]"),
                                          subtitle: Text(
                                              "barcode : ${snapshot.data[index].storageMaterialBarcode}"),
                                        ),
                                      );
                                    });
                              } else {
                                return CircularProgressIndicator();
                              }
                            })
                      ],
                    ),
                  ),
                );
              },
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    revertPickZoneMaterial(
                        selectedTapBarcode, sku, qtyController.text, oriQty);
                  },
                  child: Text("되돌리기"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              // height: double.infinity,
              width: double.infinity,
              color: Color(0xFF527DAA),
            ),
            Container(
              // height: double.infinity,
              alignment: Alignment.topCenter,
              color: Color(0xFF527DAA),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '피킹존리스트',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    corCodeSelect(context),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      child: Container(
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: FutureBuilder(
                            future: pickList,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text("업체 선택시 리스트가 조회됩니다."),
                                );
                              } else if (snapshot.hasError) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text("업체 선택시 리스트가 조회됩니다."),
                                );
                              } else if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Card(
                                                child: ListTile(
                                                  onTap: () {
                                                    skuDialog(
                                                        context,
                                                        snapshot
                                                            .data[index].qty,
                                                        snapshot
                                                            .data[index].sku);
                                                  },
                                                  title: Text(
                                                      "${snapshot.data[index].sku} / ${snapshot.data[index].skuLabel}"),
                                                  subtitle: Text(
                                                      "최근 업데이트 : ${snapshot.data[index].updateDate} / 개수 : ${snapshot.data[index].qty}"),
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(CupertinoIcons.return_icon),
            onPressed: () => Navigator.pop(context)));
  }
}

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  border: Border.all(
    color: Color(0xFF527DAA),
  ),
  borderRadius: BorderRadius.circular(10.0),
);
