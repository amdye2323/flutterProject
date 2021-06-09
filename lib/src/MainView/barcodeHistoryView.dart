import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/barcodeHistoryInfo.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../../main.dart';

class barcodeHistoryView extends StatefulWidget {
  const barcodeHistoryView({Key key}) : super(key: key);

  @override
  _barcodeHistoryViewState createState() => _barcodeHistoryViewState();
}

class _barcodeHistoryViewState extends State<barcodeHistoryView> {
  final _viewModel = HomeViewModel();
  DateTime currentTime = DateTime.now();
  String selectedName = "";

  Future<List<barcodeHistoryInfo>> historyList;
  String searchDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    historyList = _viewModel.getUserPushedBarcodeList(userId, searchDate);
  }

  Future<void> _selecetDate(BuildContext context) async {
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentTime,
        firstDate: DateTime(2019, 1, 1),
        lastDate: DateTime(2023, 12, 31));
    if (pickedDate != null) {
      setState(() {
        currentTime = pickedDate;
        historyList = _viewModel.getUserPushedBarcodeList(userId, searchDate);
      });
    }
  }

  /**
   * 날짜 선택
   */
  Widget datePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "조회 일자",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              fontFamily: 'OpenSans',
              color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          height: 35.0,
          alignment: Alignment.center,
          decoration: kBoxDecorationStyle,
          child: TextButton(
            onPressed: () {
              _selecetDate(context);
            },
            child: Text(
              DateFormat('yyyy-MM-dd').format(currentTime),
              style: TextStyle(
                  color: Color(0xFF527DAA),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  fontSize: 14.0),
            ),
          ),
        )
      ],
    );
  }

  SingleChildScrollView dataGrid(List<barcodeHistoryInfo> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            sortColumnIndex: 0,
            dataRowHeight: 30.0,
            headingRowHeight: 35.0,
            columns: [
              DataColumn(
                  label: Text(
                    "시간",
                    style: cColStyle,
                  ),
                  numeric: false,
                  tooltip: "createDate"),
              DataColumn(
                  label: Text(
                    "제품",
                    style: cColStyle,
                  ),
                  numeric: false,
                  tooltip: "SKU LABEL"),
              DataColumn(
                  label: Text(
                    "업체명",
                    style: cColStyle,
                  ),
                  numeric: false,
                  tooltip: "corName"),
              DataColumn(
                  label: Text(
                    "갯수",
                    style: cColStyle,
                  ),
                  numeric: false,
                  tooltip: "qty"),
              DataColumn(
                  label: Text(
                    "입출고",
                    style: cColStyle,
                  ),
                  numeric: false,
                  tooltip: "ioGubun"),
              DataColumn(
                  label: Text(
                    "구역",
                    style: cColStyle,
                  ),
                  numeric: false,
                  tooltip: "storageZone"),
              DataColumn(
                  label: Text(
                    "기타",
                    style: cColStyle,
                  ),
                  numeric: false,
                  tooltip: "remark"),
              DataColumn(
                  label: Text(
                    "바코드",
                    style: cColStyle,
                  ),
                  numeric: false,
                  tooltip: "barcode"),
            ],
            rows: list
                .map(
                  (info) => DataRow(
                      // onSelectChanged: (value) {
                      //   setState(() {
                      //     selectedName = info.barcode + info.createDate;
                      //   });
                      // },
                      // selected: selectedName == info.barcode + info.createDate,
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            "${info.createDate}",
                          ),
                        ),
                        DataCell(
                          Text("${info.skuLabel}"),
                        ),
                        DataCell(
                          Text("${info.corName}"),
                        ),
                        DataCell(
                          Text("${info.qty}"),
                        ),
                        DataCell(
                          Text("${info.ioGubun}"),
                        ),
                        DataCell(
                          Text("${info.storageZone}"),
                        ),
                        DataCell(
                          Text("${info.remark}"),
                        ),
                        DataCell(
                          Text("${info.barcode}"),
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
        body: Stack(
          children: [
            Container(
              height: 200,
              color: Color(0xFF527DAA),
            ),
            Container(
              alignment: Alignment.topCenter,
              // color: Color(0xFF527DAA),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '바코드이력조회',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    datePicker(context),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      child: Container(
                        height: 420,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF527DAA)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: FutureBuilder(
                            future: historyList,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text("데이터가 없습니다."),
                                );
                              } else if (snapshot.hasError) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text("데이터가 없습니다."),
                                );
                              } else if (snapshot.hasData) {
                                return dataGrid(snapshot.data);
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    )
                  ],
                ),
              ),
            )
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

final cColStyle = TextStyle(
    color: Color(0xFF527DAA),
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
    fontSize: 20.0);
