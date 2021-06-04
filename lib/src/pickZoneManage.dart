import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:testflutter/DTO/pickZoneInfo.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../main.dart';
import 'LoginScreen.dart';

class pickZoneManage extends StatelessWidget {
  const pickZoneManage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: pickZoneManageFul(),
    );
  }
}

class pickZoneManageFul extends StatefulWidget {
  const pickZoneManageFul({Key key}) : super(key: key);

  @override
  _pickZoneManageFulState createState() => _pickZoneManageFulState();
}

class _pickZoneManageFulState extends State<pickZoneManageFul> {
  final _viewModel = HomeViewModel();
  String corCode = "";
  String corCodeName = "업체선택";
  static final storage = FlutterSecureStorage();
  String userId = "";

  Future<List<Map<String, String>>> corList;
  Future<List<pickZoneInfo>> pickList;

  void initState() {
    super.initState();
    corList = _viewModel.getCorCode();
    String userId = Provider.of<UserModel>(context, listen: false).userId;
    pickList = _viewModel.getCompanyPickingZoneInquiry(corCode);
  }

  Future deleteSecureDate(String key) async {
    var deleteData = await storage.delete(key: key);
    return deleteData;
  }

  /**
   * 업체 선택
   */
  Widget corCodeSelect(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 50,
          decoration: kBoxDecorationStyle,
          transformAlignment: Alignment.center,
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
                          pickList =
                              _viewModel.getCompanyPickingZoneInquiry(corCode);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('GOLINK'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_alert),
                tooltip: 'Notice User Info',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: IconButton(
                icon: const Icon(CupertinoIcons.clear),
                onPressed: () {
                  deleteSecureDate('login');
                  Provider.of<UserModel>(context, listen: false).popUser();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              // height: double.infinity,
              width: double.infinity,
              color: Colors.black,
            ),
            Container(
              // height: double.infinity,
              alignment: Alignment.topCenter,
              color: Colors.black,
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
                      '피킹존리스트',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    corCodeSelect(context),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      child: Container(
                        height: 600,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: FutureBuilder(
                            future: pickList,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text("업체 선택시 리스트가 조회됩니다."),
                                );
                              } else if (snapshot.hasError) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text("업체 선택시 리스트가 조회됩니다."),
                                );
                              } else if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Card(
                                                  child: ListTile(
                                                    onTap: () {
                                                      // getSkuZone();
                                                    },
                                                    title: Text(
                                                        "${snapshot.data[index].sku} / ${snapshot.data[index].skuLabel}"),
                                                    subtitle: Text(
                                                        "${snapshot.data[index].updateDate} / ${snapshot.data[index].remark}"),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(CupertinoIcons.return_icon),
          onPressed: () => Navigator.pop(context),
        ));
  }
}

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  border: Border.all(
    color: Color(0xFF527DAA),
  ),
  borderRadius: BorderRadius.circular(10.0),
);
