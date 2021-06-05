import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/src/MainView/StockManage.dart';
import 'package:testflutter/src/MainView/pickZoneManage.dart';

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
                        color: Colors.black,
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
                            "고링크 바코드 시스템",
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
                            "조회 리스트",
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
            child: mainCard("피킹리스트 조회", "조회 하시려면 탭 해주세요.", CupertinoIcons.book,
                StockManage())),
        Container(
            child: mainCard("피킹존 조회 및 관리", "업체별로 조회 가능합니다.",
                CupertinoIcons.square_favorites, pickZoneManageFul())),
        Container(
            child: mainCard("사용자 바코드 이력 조회", "일일 형식으로 조회 가능합니다.",
                CupertinoIcons.barcode, pickZoneManageFul())),
        Container(
            child: mainCard(
                "사용자 송장체크 조회",
                "사용자가 송장 체크한 리스트만 조회",
                CupertinoIcons.square_stack_3d_down_right_fill,
                pickZoneManageFul())),
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
