import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/src/CheckInvoice.dart';
import 'package:testflutter/src/StockManage.dart';
import 'package:testflutter/src/StockMove.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  int screenIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(CupertinoIcons.home),
                ),
                Tab(
                  icon: Icon(CupertinoIcons.rectangle_fill_on_rectangle_fill),
                ),
                Tab(
                  icon: Icon(CupertinoIcons.barcode_viewfinder),
                ),
                Tab(
                  icon: Icon(CupertinoIcons.settings),
                )
              ],
            ),
            title: Text("GOLINK"),
          ),
          body: TabBarView(
            children: [
              FirstWidget(),
              StockManage(),
              StockMove(),
              CheckInvoice(),
            ],
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: screenIndex,
          //   items: [  BottomNavigationBarItem(
          //       icon: Icon(CupertinoIcons.home), title: Text("홈")),
          //     BottomNavigationBarItem(
          //         icon: Icon(CupertinoIcons.rectangle_fill_on_rectangle_fill),
          //         title: Text("피킹조회")),
          //     BottomNavigationBarItem(
          //         icon: Icon(CupertinoIcons.barcode_viewfinder), title: Text("바코드처리")),
          //     BottomNavigationBarItem(
          //         icon: Icon(CupertinoIcons.settings), title: Text("송장처리")),],
          // ),
        ));
  }
}

class FirstWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Center(
    //   child: Consumer<UserModel>(
    //     builder: (context, user, child) {
    //       return Row(children: <Widget>[
    //         Card(
    //             color: Colors.blue,
    //             margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
    //             child: ListTile(
    //                 leading: Icon(CupertinoIcons.tag),
    //                 title: Text(
    //                   "접속자 아이디 : ${user.userId}",
    //                   style: TextStyle(color: Colors.white),
    //                 ))),
    //         Card(
    //             color: Colors.blue,
    //             margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
    //             child: ListTile(
    //                 leading: Icon(CupertinoIcons.person_alt),
    //                 title: Text(
    //                   "접속자 이름 : ${user.userName}",
    //                   style: TextStyle(color: Colors.white),
    //                 ))),
    //       ]);
    //     },
    //   ),
    // )
    return Text("dd");
  }
}
