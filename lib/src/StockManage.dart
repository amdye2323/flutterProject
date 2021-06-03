import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:testflutter/DTO/pick.dart';
import 'package:testflutter/Home/HomeViewModel.dart';
import 'package:testflutter/src/pickListView.dart';

import '../main.dart';

class StockManage extends StatefulWidget {
  const StockManage({Key key}) : super(key: key);

  @override
  _StockManageState createState() => _StockManageState();
}

class _StockManageState extends State<StockManage> {
  final _viewModel = HomeViewModel();
  DateTime currentTime = DateTime.now();
  String corCode = "";
  String corCodeName = "선택해주세요";
  String step = "1";

  Future<List<Map<String, String>>> corList;

  void initState() {
    super.initState();
    corList = _corSelFuture(context);
  }

  List<Map<String, String>> options = [
    {'value': '1', 'title': 'STEP 1'},
    {'value': '2', 'title': 'STEP 2'},
    {'value': '3', 'title': 'STEP 3'},
    {'value': '4', 'title': 'STEP 4'},
    {'value': '5', 'title': 'STEP 5'},
  ];

  /**
   * 스텝 선택
   */
  Widget pickStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Select Request Step ",
          style: kLabelStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: SmartSelect<String>.single(
              title: "${step}차",
              modalType: S2ModalType.bottomSheet,
              tileBuilder: (context, state) {
                return S2Tile.fromState(
                  state,
                  title: Text(
                    '차수를 선택해주세요',
                    style: TextStyle(color: Color(0xFF527DAA)),
                  ),
                );
              },
              choiceItems: S2Choice.listFrom(
                  source: options,
                  value: (index, item) => item['value'],
                  title: (index, item) => item['title']),
              value: step,
              onChange: (state) => setState(() => step = state.value)),
        )
      ],
    );
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

  /**
   * 업체 선택
   */
  Widget corCodeSelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Company Select",
          style: kLabelStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
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

  Future<void> _selecetDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentTime,
        firstDate: DateTime(2019, 1, 1),
        lastDate: DateTime(2023, 12, 31));
    if (pickedDate != null) {
      setState(() {
        currentTime = pickedDate;
      });
    }
  }

  Future<List<Map<String, String>>> _corSelFuture(BuildContext context) async {
    return await _viewModel.getCorCode();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: GestureDetector(
        child: Stack(
          children: <Widget>[
            // backWallpaper(),
            Container(
              height: double.infinity,
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding:
                    EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "PICKING LIST",
                      style: TextStyle(
                          color: Color(0xFF527DAA),
                          fontFamily: 'OpenSans',
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    datePicker(context),
                    SizedBox(
                      height: 30.0,
                    ),
                    corCodeSelect(context),
                    SizedBox(
                      height: 30.0,
                    ),
                    pickStep(context),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 50.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF527DAA),
                              onPrimary: Colors.white,
                              elevation: 5),
                          onPressed: () {
                            pickVO pi = pickVO();
                            pi.step = step;
                            pi.corCode = corCode;
                            pi.pickingDate =
                                DateFormat('yyyy-MM-dd').format(currentTime);
                            Provider.of<pickRequirement>(context, listen: false)
                                .setPickRequirment(pi);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pickListView()));
                            // Navigator.popAndPushNamed(context, "pickListView");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(CupertinoIcons.arrow_right_circle),
                              Text("조회하기")
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
