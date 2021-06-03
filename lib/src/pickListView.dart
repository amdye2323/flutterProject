import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/PickingList.dart';
import 'package:testflutter/DTO/skuZoneList.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../main.dart';

class pickListView extends StatefulWidget {
  const pickListView({Key key}) : super(key: key);

  @override
  _pickListViewState createState() => _pickListViewState();
}

class _pickListViewState extends State<pickListView> {
  String currentDate;
  String corCode;
  String step;
  String sku = "";
  String skuName = "";
  Future<List<PickingList>> list;
  Future<List<skuZoneList>> zoneList;

  final _viewModel = HomeViewModel();
  String countIndex = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickRequirement pickR =
        Provider.of<pickRequirement>(context, listen: false);
    currentDate = pickR.pickingDate;
    corCode = pickR.corCode;
    step = pickR.step;
    list = _viewModel.getPickList(currentDate, corCode, step);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  Future<void> skuZoneDialog(BuildContext context, String onSku) async {
    zoneList = _viewModel.getSkuZoneList(sku);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "재고 위치",
                  style: TextStyle(color: Color(0xFF527DAA), fontSize: 20.0),
                )
              ],
            ),
            content: Container(
              height: 300,
              width: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("${skuName}"),
                    SizedBox(
                      height: 10.0,
                    ),
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
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                          "${snapshot.data[index].storageZone}[${snapshot.data[index].qty} 개]"),
                                      subtitle: Text(
                                          "barcode : ${snapshot.data[index].storageZoneBarcode}"),
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
            ),
          );
        });
  }

  SingleChildScrollView dataGrid(List<PickingList> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            sortColumnIndex: 0,
            columns: [
              DataColumn(label: Text("SKU"), numeric: false, tooltip: "SKU ID"),
              DataColumn(
                  label: Text("제품 이름"), numeric: false, tooltip: "SKU LABEL"),
              DataColumn(label: Text("수량"), numeric: false, tooltip: "수량"),
              DataColumn(label: Text("현재고"), numeric: false, tooltip: "현재고"),
              DataColumn(label: Text("출고후"), numeric: false, tooltip: "출고후재고량"),
            ],
            rows: list
                .map(
                  (info) => DataRow(
                      onSelectChanged: (value) {
                        setState(() {
                          countIndex = info.skuId;
                          sku = info.skuId;
                          skuName = info.skuName;
                          skuZoneDialog(context, info.skuId);
                        });
                      },
                      selected: info.skuId == countIndex,
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            "${info.skuId}",
                          ),
                        ),
                        DataCell(
                          Text("${info.skuName}"),
                        ),
                        DataCell(
                          Text("${info.cnt.toString()}"),
                        ),
                        DataCell(
                          Text("${info.availableStock.toString()}"),
                        ),
                        DataCell(
                          Text("${info.totCnt.toString()}"),
                        ),
                      ]),
                )
                .toList(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: list,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("데이터가 없습니다"),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("에러가 발생했습니다."),
                );
              } else if (snapshot.hasData) {
                return dataGrid(snapshot.data);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(CupertinoIcons.return_icon),
          onPressed: () => Navigator.pop(context),
        ));
  }
}
