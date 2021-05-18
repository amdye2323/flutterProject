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
  final _dateEditController = TextEditingController();
  String corCode = "";
  String step = "1";

  List<S2Choice<String>> options = [
    S2Choice<String>(value: "1", title: "1차"),
    S2Choice<String>(value: "2", title: "2차"),
    S2Choice<String>(value: "3", title: "3차"),
    S2Choice<String>(value: "4", title: "4차"),
    S2Choice<String>(value: "5", title: "5차"),
  ];

  /**
   * 스텝 선택
   */
  Widget pickStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "차수 선택",
          style: kLabelStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: SmartSelect<String>.single(
              title: "${step}차",
              choiceItems: options,
              value: step,
              onChange: (state) => setState(() => step = state.value)),
        )
      ],
    );
  }

  /**
   * 업체 선택
   */
  Widget corCodeSelect(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "업체 선택",
          style: kLabelStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        FutureBuilder(
            future: _corSelFuture(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SmartSelect<String>.single(
                    title: "${corCode}", value: value, onChange: onChange);
              } else if (snapshot.hasError) {
                return Text("error");
              }
            }),
        SmartSelect<String>.single(
            title: "${corCode}",
            choiceItems: _corSelFuture(context),
            value: corCode,
            onChange: (state) => setState(() => corCode = state.value))
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
          height: 60.0,
          child: TextButton(
            onPressed: () {
              _selecetDate(context);
            },
            child: Text(
              DateFormat('yyyy-MM-dd').format(currentTime),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        )
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

  Future<List<S2Choice<String>>> _corSelFuture(BuildContext context) async {
    return await _viewModel.getCorCode();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: GestureDetector(
        onDoubleTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => pickListView())),
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              )),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding:
                    EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "피킹 조회",
                      style: TextStyle(
                          color: Colors.white,
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            elevation: 5),
                        onPressed: () {
                          pickVO pi = pickVO();
                          pi.step = step;
                          pi.corCode = corCode;
                          pi.pickingDate =
                              DateFormat('yyyy-MM-dd').format(currentTime);
                          Provider.of<pickRequirement>(context, listen: false)
                              .setPickRequirment(pi);
                        },
                        child: Text(
                          "조회하기",
                        )),
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

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 14.0,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
);
