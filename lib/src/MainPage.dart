import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/src/CheckInvoice.dart';
import 'package:testflutter/src/LoginScreen.dart';
import 'package:testflutter/src/StockManage.dart';
import 'package:testflutter/src/StockMove.dart';
import 'package:testflutter/src/ZoneMove.dart';
import 'package:testflutter/src/pickZoneManage.dart';

import '../main.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainFulPage(),
    );
  }
}

class MainFulPage extends StatefulWidget {
  const MainFulPage({Key key}) : super(key: key);

  @override
  _MainFulPageState createState() => _MainFulPageState();
}

class _MainFulPageState extends State<MainFulPage> {
  int screenIndex = 0;
  static final storage = FlutterSecureStorage();
  final qtyController = TextEditingController();

  static List<Widget> _widgetOptions = [
    FirstWidget(),
    // StockManage(),
    StockMove(),
    ZoneMove(),
    CheckInvoice(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      screenIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future deleteSecureDate(String key) async {
    var deleteData = await storage.delete(key: key);
    return deleteData;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('GOLINK'),
                actions: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_alert),
                      tooltip: 'Notice User Info',
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.clear),
                      onPressed: () {
                        deleteSecureDate('login');
                        Provider.of<UserModel>(context, listen: false)
                            .popUser();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    ),
                  )
                ],
              ),
              body: Center(
                child: _widgetOptions.elementAt(screenIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.black,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home),
                    label: '홈',
                    backgroundColor: Colors.black,
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(CupertinoIcons.rectangle_fill_on_rectangle_fill),
                  //   label: '피킹',
                  //   backgroundColor: Colors.black,
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.barcode_viewfinder),
                    label: '재고스캔',
                    backgroundColor: Colors.black,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.arrow_up_arrow_down_circle_fill),
                    label: '구역스캔',
                    backgroundColor: Colors.black,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.doc_person_fill),
                    label: '송장체크',
                    backgroundColor: Colors.black,
                  ),
                ],
                onTap: _onItemTapped,
                selectedItemColor: Colors.blue,
                currentIndex: screenIndex,
              ))),
    );
  }
}

class FirstWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
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
                      Container(
                          child: mainCard("피킹리스트 조회", "조회 하시려면 탭 해주세요.",
                              CupertinoIcons.book, StockManage(), context)),
                      Container(
                          child: mainCard(
                              "피킹존 조회 및 관리",
                              "업체별로 조회 가능합니다.",
                              CupertinoIcons.square_favorites,
                              pickZoneManage(),
                              context)),
                      Container(
                          child: mainCard(
                              "사용자 바코드 이력 조회",
                              "일일 형식으로 조회 가능합니다.",
                              CupertinoIcons.barcode,
                              pickZoneManage(),
                              context)),
                      Container(
                          child: mainCard(
                              "사용자 송장체크 조회",
                              "사용자가 송장 체크한 리스트만 조회",
                              CupertinoIcons.square_stack_3d_down_right_fill,
                              StockManage(),
                              context)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle mainLabel() {
  return TextStyle(
    color: Color(0xFF527DAA),
    letterSpacing: 1.5,
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );
}

Widget listCard(IconData iconData, String content) {
  return Card(
      color: Color(0xFF527DAA),
      child: ListTile(
        leading: Icon(
          iconData,
          color: Colors.white,
        ),
        title: Text(
          "접속자 이름 : ${content}",
          style: TextStyle(color: Colors.white),
        ),
      ));
}

Widget normalCard(String content, IconData ico) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: Card(
      // color: Color(0xFF527DAA),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          ico,
          color: Color(0xFF527DAA),
          size: 25,
        ),
        title: Text(
          content,
          style: kLabelStyle,
        ),
      ),
    ),
  );
}

Widget mainCard(String content, String subContent, IconData ico, Widget wiName,
    BuildContext context) {
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
          // Navigator.popAndPushNamed(context, pushName);
          // Navigator.pushNamed(context, pushName);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => wiName));
        },
      ),
    ),
  );
}

Widget normalTitle(String content) {
  return Text(
    content,
    style: TextStyle(
      color: Color(0xFF527DAA),
      fontFamily: 'OpenSans',
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
  );
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
