import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
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
  String corCode = "";
  String corCodeName = "선택해주세요";

  Future<List<barcodeInvoiceInfo>> invoiceList;
  Future<List<Map<String, String>>> corList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = Provider.of<UserModel>(context, listen: false).userId;
    invoiceList = _viewModel.getUserPushedInvoiceList(
        userId, DateFormat('yyyy-MM-dd').format(currentTime), corCode);
    corList = _corSelFuture(context);
  }

  Future<List<Map<String, String>>> _corSelFuture(BuildContext context) async {
    return await _viewModel.getCorCode();
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
              fontSize: 14.0,
              fontFamily: 'OpenSans',
              color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 60,
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
            userId, DateFormat('yyyy-MM-dd').format(currentTime), corCode);
      });
    }
  }

  /**
   * 업체 선택
   */
  Widget corCodeSelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Company Select",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              fontFamily: 'OpenSans',
              color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
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
                          invoiceList = _viewModel.getUserPushedInvoiceList(
                              userId,
                              DateFormat('yyyy-MM-dd').format(currentTime),
                              state.value);
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

  SingleChildScrollView dataGrid(List<barcodeInvoiceInfo> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            sortColumnIndex: 0,
            dataRowHeight: 30,
            headingRowHeight: 40,
            headingTextStyle: TextStyle(
                color: Color(0xFF527DAA), fontWeight: FontWeight.bold),
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
              height: 300,
              color: Color(0xFF527DAA),
            ),
            Container(
              alignment: Alignment.topCenter,
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
                      height: 15.0,
                    ),
                    Container(
                      height: 120,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: datePicker(context),
                          ),
                          Expanded(
                            child: corCodeSelect(context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFF527DAA), width: 2),
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
