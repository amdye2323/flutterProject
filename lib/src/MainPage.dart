import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/src/CheckInvoice.dart';
import 'package:testflutter/src/StockManage.dart';
import 'package:testflutter/src/StockMove.dart';

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
  static List<Widget> _widgetOptions = [
    FirstWidget(),
    StockManage(),
    StockMove(),
    CheckInvoice(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      screenIndex = index;
    });
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
                        EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_alert),
                      tooltip: 'Notice User Info',
                    ),
                  ),
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
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.rectangle_fill_on_rectangle_fill),
                    label: '피킹',
                    backgroundColor: Colors.black,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.barcode_viewfinder),
                    label: '재고조회',
                    backgroundColor: Colors.black,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.settings),
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
              backWallpaper(),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 120.0,
                  ),
                  child: Consumer<UserModel>(
                    builder: (context, user, child) {
                      return Flex(
                          mainAxisAlignment: MainAxisAlignment.center,
                          direction: Axis.vertical,
                          children: <Widget>[
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
                              height: 20,
                            ),
                            Card(
                                color: Colors.white,
                                child: ListTile(
                                    leading: Icon(
                                      CupertinoIcons.tag,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      "접속자 아이디 : ${user.userId}",
                                      style: TextStyle(color: Colors.blue),
                                    ))),
                            Card(
                                color: Colors.white,
                                child: ListTile(
                                    leading: Icon(
                                      CupertinoIcons.person_alt,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      "접속자 이름 : ${user.userName}",
                                      style: TextStyle(color: Colors.blue),
                                    ))),
                          ]);
                    },
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
