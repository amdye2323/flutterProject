import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/PickingList.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../main.dart';

class pickListView extends StatefulWidget {
  const pickListView({Key key}) : super(key: key);

  @override
  _pickListViewState createState() => _pickListViewState();
}

class _pickListViewState extends State<pickListView> {
  String currentDate;
  String corCode;
  String step;
  Future<List<PickingList>> list;
  final _viewModel = HomeViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    pickRequirement pickR =
        Provider.of<pickRequirement>(context, listen: false);
    currentDate = pickR.pickingDate;
    corCode = pickR.corCode;
    step = pickR.step;
    list = _viewModel.getPickList(currentDate, corCode, step);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("피킹리스트"),
        // ),
        body: FutureBuilder(
          future: list,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("데이터가 없습니다"),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("에러가 발생했습니다."),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                          leading: Icon(
                            CupertinoIcons.barcode,
                          ),
                          title: Text(
                              "SKU : ${snapshot.data[index].skuId} 이름 ${snapshot.data[index].skuName} 수량 ${snapshot.data[index].totCnt}")),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(CupertinoIcons.return_icon),
          onPressed: () => Navigator.pop(context),
        ));
  }
}
