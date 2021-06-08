import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:testflutter/src/CheckInvoice.dart';
import 'package:testflutter/src/LoginScreen.dart';
import 'package:testflutter/src/MainView/MainPageWidget.dart';
import 'package:testflutter/src/StockMove.dart';
import 'package:testflutter/src/ZoneMove.dart';

import '../main.dart';

class MainPage extends StatelessWidget {
  // const MainPage({Key key}) : super(key: key);
  // final channel = IOWebSocketChannel.connect("ws://echo.websocket.org");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainFulPage(),
    );
  }
}

class MainFulPage extends StatefulWidget {
  // const MainFulPage({Key key}) : super(key: key);

  @override
  _MainFulPageState createState() => _MainFulPageState();
}

class _MainFulPageState extends State<MainFulPage> {
  final socketUrl = "http://172.30.1.1:8072/ws-message";
  StompClient stompClient;
  final Map<String, String> header = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  List<Map<String, dynamic>> noticeList;

  void onConnect(StompFrame frame) {
    stompClient.subscribe(
        destination: '/topic/message',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Map<String, dynamic> result = json.decode(frame.body);
            // noticeList.add(
            //     {"message": result["message"], "userId": result["userId"]});
            // noticeList.forEach((element) {
            //   print(element);
            // });
          }
        });
  }

  void sendMessage() {
    var map = {'message': 'hello', 'userId': 'userId'};
    String body = jsonEncode(map);
    stompClient.send(destination: '/app/send', body: body, headers: header);
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient.deactivate();
    }
    super.dispose();
  }

  int screenIndex = 0;
  static final storage = FlutterSecureStorage();

  static List<Widget> _widgetOptions = [
    MainPageWidget(),
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

    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.SockJS(
              url: socketUrl,
              onConnect: onConnect,
              onWebSocketError: (dynamic error) => print(error.toString())));
    }

    stompClient.activate();
  }

  Future deleteSecureDate(String key) async {
    var deleteData = await storage.delete(key: key);
    return deleteData;
  }

  void logOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(
              "로그아웃 하시겠습니까?",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF527DAA),
                          onPrimary: Colors.white,
                          elevation: 5),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("취소")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF527DAA),
                          onPrimary: Colors.white,
                          elevation: 5),
                      onPressed: () {
                        deleteSecureDate('login');
                        Provider.of<UserModel>(context, listen: false)
                            .popUser();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text("로그아웃")),
                ],
              ),
            ),
          );
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
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                    child: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
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
                        logOutDialog(context);
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
  return Container(
    padding: EdgeInsets.all(5.0),
    child: Card(
        // color: Color(0xFF527DAA),
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xFF527DAA), width: 2))),
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
        )),
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

Border BoxDeco() {
  return Border(
      top: BorderSide(color: Color(0xFF527DAA), width: 2),
      bottom: BorderSide(color: Color(0xFF527DAA), width: 2),
      left: BorderSide(color: Color(0xFF527DAA), width: 2),
      right: BorderSide(color: Color(0xFF527DAA), width: 2));
}
