import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/src/MainView/StockManage.dart';
import 'package:testflutter/src/MainView/pickZoneManage.dart';

import 'barcodeHistoryView.dart';
import 'barcodeInvoiceCheckListView.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPageWidgetFul(),
    );
  }
}

class MainPageWidgetFul extends StatefulWidget {
  const MainPageWidgetFul({Key key}) : super(key: key);

  @override
  _MainPageWidgetFulState createState() => _MainPageWidgetFulState();
}

class _MainPageWidgetFulState extends State<MainPageWidgetFul> {
  int screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: Scaffold(
            body: GestureDetector(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        color: Color(0xFF527DAA),
                        height: 200.0,
                      ),
                    ],
                  ),
                  Container(
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 50.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: 20.0,
                          // ),
                          Text(
                            'GOLINK',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "????????? ????????? ?????????",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "?????? ?????????",
                            style: TextStyle(color: Colors.white38),
                          ),
                          MainList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget mainCard(
      String content, String subContent, IconData ico, Widget wiName) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Card(
        // color: Color(0xFF527DAA),
        color: Colors.white,
        child: ListTile(
          leading: Icon(
            ico,
            color: Colors.black,
            size: 25,
          ),
          title: Text(
            content,
            style: kBlackLabelStyle,
          ),
          subtitle: Text(subContent),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => wiName));
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => wiName),
            //     (route) => false);
          },
        ),
      ),
    );
  }

  Widget MainList() {
    return Column(
      children: [
        Container(
            child: mainCard("??????????????? ??????", "?????? ???????????? ??? ????????????.", CupertinoIcons.book,
                StockManage())),
        Container(
            child: mainCard("????????? ?????? ??? ??????", "???????????? ?????? ???????????????.",
                CupertinoIcons.square_favorites, pickZoneManageFul())),
        Container(
            child: mainCard("????????? ????????? ?????? ??????", "?????? ???????????? ?????? ???????????????.",
                CupertinoIcons.barcode, barcodeHistoryView())),
        Container(
            child: mainCard(
                "????????? ???????????? ??????",
                "???????????? ?????? ????????? ???????????? ??????",
                CupertinoIcons.square_stack_3d_down_right_fill,
                barcodeInvoiceCheckListView())),
      ],
    );
  }
}

final kLabelStyle = TextStyle(
  color: Color(0xFF527DAA),
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBlackLabelStyle = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);
