import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/add_screen.dart';
import 'package:testflutter/main.dart';
import 'package:testflutter/src/StockManage.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home), title: Text("홈")),
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.rectangle_fill_on_rectangle_fill),
          title: Text("재고관리")),
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.barcode_viewfinder), title: Text("출고처리")),
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings), title: Text("설정")),
    ];
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: items),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return FirstWidget();
            case 1:
              return MaterialApp(
                home: StockManage(),
              );
            case 2:
              return MaterialApp(
                home: AddScreen(),
              );
            case 4:
              return MaterialApp(
                home: ForthWidget(),
              );
            default:
              return FirstWidget();
          }
        });
  }
}

class FirstWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Consumer<UserModel>(
        builder: (context, user, child) {
          return Text("userID : ${user.userId} , userName : ${user.userName}");
        },
      ),
    );
  }
}

class SecondWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: Text("두번째"));
  }
}

class ThirdWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: Text("세번째"));
  }
}

class ForthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: Text("네번째"));
  }
}
