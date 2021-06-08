import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/barcodeInvoiceInfo.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../../main.dart';

class barcodeInvoiceCheckListView extends StatefulWidget {
  const barcodeInvoiceCheckListView({Key key}) : super(key: key);

  @override
  _barcodeInvoiceCheckListViewState createState() =>
      _barcodeInvoiceCheckListViewState();
}

class _barcodeInvoiceCheckListViewState
    extends State<barcodeInvoiceCheckListView> {
  final _viewModel = HomeViewModel();
  DateTime currentTime = DateTime.now();
  String searchDate;
  String userId = "";

  Future<List<barcodeInvoiceInfo>> invoiceList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = Provider.of<UserModel>(context, listen: false).userId;
    invoiceList = _viewModel.getUserPushedInvoiceList(
        userId, DateFormat('yyyy-MM-dd').format(currentTime));
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
          style: kLabelStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
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
                  fontSize: 16.0),
            ),
          ),
        )
      ],
    );
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
        invoiceList = _viewModel.getUserPushedInvoiceList(
            userId, DateFormat('yyyy-MM-dd').format(currentTime));
      });
    }
  }

  SingleChildScrollView dataGrid(List<barcodeInvoiceInfo> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            sortColumnIndex: 0,
            columns: [
              DataColumn(
                  label: Text("결과"), numeric: false, tooltip: "craetDate"),
              DataColumn(
                  label: Text("송장번호"), numeric: false, tooltip: "SKU LABEL"),
              DataColumn(
                  label: Text("확인자"), numeric: false, tooltip: "corName"),
              DataColumn(label: Text("생성일"), numeric: false, tooltip: "qty"),
            ],
            rows: list
                .map(
                  (info) => DataRow(cells: <DataCell>[
                    DataCell(
                      Text(
                        "${info.result}",
                      ),
                    ),
                    DataCell(
                      Text("${info.deliveryNumber}"),
                    ),
                    DataCell(
                      Text("${info.operator}"),
                    ),
                    DataCell(
                      Text("${info.createDate}"),
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
              width: double.infinity,
              color: Color(0xFF527DAA),
            ),
            Container(
              alignment: Alignment.topCenter,
              color: Color(0xFF527DAA),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '송장체크리스트',
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
                    datePicker(context),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      height: 500,
                      child: FutureBuilder(
                          future: invoiceList,
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
                    SizedBox(height: 40.0)
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
